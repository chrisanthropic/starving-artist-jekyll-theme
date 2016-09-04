require 'rspec'
require 'configure-s3-website'

describe ConfigureS3Website::S3Client do
  describe '#enable_website_configuration' do
    context 'custom index and error documents' do
      let(:config_source) {
        ConfigureS3Website::FileConfigSource.new('spec/sample_files/_custom_index_and_error_docs.yml')
      }

      it 'calls the S3 API with the custom index document' do
        expect_api_call(
          :enable_website_configuration,
          /<IndexDocument>\s*<Suffix>default.html<\/Suffix>\s*<\/IndexDocument>/,
          config_source
        )
      end

      it 'calls the S3 API with the custom error document' do
        expect_api_call(
          :enable_website_configuration,
          /<ErrorDocument>\s*<Key>404.html<\/Key>\s*<\/ErrorDocument>/,
          config_source
        )
      end
    end
  end

  describe '#configure_bucket_redirects' do
    context 'custom index and error documents' do
      let(:config_source) {
        ConfigureS3Website::FileConfigSource.new('spec/sample_files/_custom_index_and_error_docs_with_routing_rules.yml')
      }

      it 'calls the S3 API with the custom index document' do
        expect_api_call(
          :configure_bucket_redirects,
          /<IndexDocument>\s*<Suffix>default.html<\/Suffix>\s*<\/IndexDocument>/,
          config_source
        )
      end

      it 'calls the S3 API with the custom error document' do
        expect_api_call(
          :configure_bucket_redirects,
          /<ErrorDocument>\s*<Key>missing.html<\/Key>\s*<\/ErrorDocument>/,
          config_source
        )
      end
    end
  end

  describe '#create_bucket' do
    context 'invalid s3_endpoint value' do
      let(:config_source) {
        mock = double('config_source')
        mock.stub(:s3_endpoint).and_return('invalid-location-constraint')
        mock
      }

      it 'throws an error' do
        expect {
          extractor = ConfigureS3Website::S3Client.
          send(:create_bucket, config_source)
        }.to raise_error(InvalidS3LocationConstraintError)
      end
    end

    context 'no s3_endpoint value' do
      let(:config_source) {
        ConfigureS3Website::FileConfigSource.new('spec/sample_files/_config_file.yml')
      }

      it 'calls the S3 api without request body' do
        ConfigureS3Website::HttpHelper.should_receive(:call_s3_api).
          with(anything(), anything(), '', anything())
        ConfigureS3Website::S3Client.send(:create_bucket,
                                          config_source)
      end
    end

    context 'valid s3_endpoint value' do
      let(:config_source) {
        ConfigureS3Website::FileConfigSource.new(
          'spec/sample_files/_config_file_oregon.yml'
      )
      }

      it 'calls the S3 api with location constraint XML' do
        ConfigureS3Website::HttpHelper.should_receive(:call_s3_api).
          with(anything(), anything(),
        %|
          <CreateBucketConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
            <LocationConstraint>us-west-2</LocationConstraint>
          </CreateBucketConfiguration >
         |, anything())
        ConfigureS3Website::S3Client.send(:create_bucket,
                                          config_source)
      end
    end
  end

  def expect_api_call(operation, body, config_source)
    ConfigureS3Website::HttpHelper.
      should_receive(:call_s3_api).
      with(
        anything(),
        anything(),
        body,
        anything()
    )
    ConfigureS3Website::S3Client.send(
      operation,
      config_source
    )
  end
end
