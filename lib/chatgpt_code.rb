# frozen_string_literal: true

require 'dry-configurable'
require 'logger'
require 'chatgpt_code/version'
require 'chatgpt_code/suggestions'

# ChatgptCode base module
module ChatgptCode
  class Error < StandardError; end

  extend Dry::Configurable

  def self.complete(snippet)
    Suggestions.complete(snippet)
  end

  setting :api_key
  setting :model, default: 'gpt-3.5-turbo'
  setting :logger, default: $stdout, constructor: lambda { |value|
    ::Logger.new(value, level: ::Logger::INFO)
  }
end
