require "retrying_s3_client/version"
require "aws-sdk-s3"
class RetryingS3Client
  def self.wrap(s3, logger, options)
    return s3 if s3.is_a?(RetryingS3Client)
    new(s3, logger, options)
  end

  def initialize(s3, logger, options = {})
    @s3 = s3
    @logger = logger
    @sleeper = options[:sleeper] || Kernel.method(:sleep)
  end

  def method_missing(sym, *args, &block)
    with_backoff { @s3.send(sym, *args, &block) }
  end

  def with_backoff(backoff = 1)
    yield
  rescue Aws::S3::Errors::Http503Error
    @logger.error "Got Aws::S3::Errors::Http503Error, sleeping #{backoff}"
    @sleeper.call(backoff)
    @logger.info "Woke up after Aws::S3::Errors::Http503Error retrying again"
    backoff *= 2
    retry
  end
end
