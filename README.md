# RetryingS3Client

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/retrying_s3_client`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'retrying_s3_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install retrying_s3_client

## Usage

```ruby
require 'retrying_s3_client'
require 'logger'
s3 = Aws::S3::Client.new
logger = Logger.new($stderr)
retrying_s3_client = RetryingS3Client.wrap(s3, logger)
retrying_s3_client.head_object(bucket: 'bucket', key: 'key') # Will retry with exponential backoff and logging attempts to logger
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fonsan/retrying_s3_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RetryingS3Client project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Fonsan/retrying_s3_client/blob/master/CODE_OF_CONDUCT.md).
