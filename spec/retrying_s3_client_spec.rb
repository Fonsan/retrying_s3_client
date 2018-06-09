RSpec.describe RetryingS3Client do
  let(:s3) { double(:s3) }
  let(:logger) { spy(:logger) }
  let(:sleeper) { spy(:sleeper) }
  subject { RetryingS3Client.wrap(s3, logger, sleeper: sleeper) }
  it "has a version number" do
    expect(RetryingS3Client::VERSION).not_to be nil
  end

  it 'retries if Aws::S3::Errors::Http503Error' do
    times = 0
    allow(s3).to receive(:get_object) do |args|
      times += 1
      if times < 3
        raise Aws::S3::Errors::Http503Error.new(nil, 'test')
      end
    end
    subject.get_object
    expect(logger).to have_received(:error).with("Got Aws::S3::Errors::Http503Error, sleeping 1").once
    expect(logger).to have_received(:error).with("Got Aws::S3::Errors::Http503Error, sleeping 2").once
  end

  it 'sleeps with correct exponential backoff if Aws::S3::Errors::Http503Error' do
    times = 0
    allow(s3).to receive(:head_object) do |args|
      times += 1
      if times < 5
        raise Aws::S3::Errors::Http503Error.new(nil, 'test')
      end
    end
    subject.head_object
    expect(sleeper).to have_received(:call).with(1).once
    expect(sleeper).to have_received(:call).with(2).once
    expect(sleeper).to have_received(:call).with(4).once
    expect(sleeper).to have_received(:call).with(8).once
  end
end
