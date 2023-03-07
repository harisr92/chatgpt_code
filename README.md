# Chatgpt code completion

Use [chatgpt](https://platform.openai.com/docs/guides/code) for code completion

Complete or generate code with ChatGPT

## Bundler

``` ruby
gem 'chatgpt_code'
```

## Usage

``` ruby
ChatgptCode.complete('snippet')
```

### Example

``` ruby
ChatgptCode.complete('const user = ')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ChatgptCode project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/chatgpt/blob/master/CODE_OF_CONDUCT.md).
