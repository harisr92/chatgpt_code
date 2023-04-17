# frozen_string_literal: true

require 'net/http'
require 'json'
require 'benchmark'

module ChatgptCode
  # Suggestions get the code completion text from chatgpt
  # ChatgptCode::Suggestions.new(snippet: 'const user = ').complete
  class Suggestions
    class << self
      def complete(snippet)
        return if snippet.nil?

        new(snippet: snippet).complete
      end
    end

    attr_reader :snippet

    def initialize(snippet: '')
      @snippet = snippet
    end

    def complete
      response = request
      return unless response

      response['choices'].map { |choice| choice['text'] }
    end

    private

    def request
      res = Net::HTTP.start(
        request_uri.host, request_uri.port,
        use_ssl: true,
        read_timeout: 5000
      ) do |http|
        req = Net::HTTP::Post.new(request_uri.request_uri, headers)
        req.body = JSON.dump(request_data)
        do_request(http, req, request_uri)
      end
      return unless res.is_a?(Net::HTTPOK)

      # decode json data
      res.body.to_s.empty? ? {} : JSON.parse(res.body.to_s)
    rescue Errno::ECONNREFUSED, SocketError => e
      raise ConnectionError.new(request_uri, e.message)
    end

    def request_data
      {
        model: ChatgptCode.config.model,
        prompt: snippet,
        temperature: 0,
        max_tokens: 60,
        top_p: 1.0
      }
    end

    def headers
      {
        'Authorization' => "Bearer #{ChatgptCode.config.api_key}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    end

    def request_uri
      @request_uri ||= URI.parse('https://api.openai.com/v1/completions')
    end

    def do_request(http, req, uri)
      if ChatgptCode.config.logger.nil?
        do_request_without_log(http, req)
      else
        do_request_with_log(http, req, uri)
      end
    end

    def do_request_with_log(http, req, uri)
      res = nil
      time = nil
      begin
        time = Benchmark.realtime { res = do_request_without_log(http, req) }
        res
      ensure
        if res
          ChatgptCode.config.logger.info(
            { name: 'chatgpt', code: res.code,
              response: res.body.to_s.force_encoding(Encoding::UTF_8),
              status: log_severity(res), elapsed_time: (time * 1000).round(1),
              request_method: req.method.upcase, request_params: req.body,
              url: uri.to_s }.to_json
          )
        end
      end
    end

    def do_request_without_log(http, req)
      http.request(req)
    end

    def log_severity(res)
      errors = [Net::HTTPClientError, Net::HTTPServerError, Net::HTTPUnknownResponse]
      errors.any? { |klass| res.is_a?(klass) } ? 'E' : 'I'
    end
  end
end
