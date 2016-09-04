require 'rspec'
require 'configure-s3-website'
require 'tempfile'

describe ConfigureS3Website::FileConfigSource do
  let(:yaml_file_path) {
    'spec/sample_files/_config_file_with_eruby.yml'
  }

  let(:config_source) {
    ConfigureS3Website::FileConfigSource.new(yaml_file_path)
  }

  it 'can parse files that contain eRuby code' do
    config_source.s3_access_key_id.should eq('hello world')
    config_source.s3_secret_access_key.should eq('secret world')
    config_source.s3_bucket_name.should eq('my-bucket')
  end

  it 'returns the yaml file path as description' do
    config_source.description.should eq(yaml_file_path)
  end

  describe 'setter for cloudfront_distribution_id' do
    let(:original_yaml_contents) {
      %Q{
s3_id: foo
s3_secret: <%= ENV['my-s3-secret'] %>
s3_bucket: helloworld.com

# This is a comment
      }
    }

    let(:result) {
      config_file = Tempfile.new 'testfile'
      config_file.write original_yaml_contents
      config_file.close
      config_source = ConfigureS3Website::FileConfigSource.new(config_file.path)
      config_source.cloudfront_distribution_id = 'xxyyzz'
      File.open(config_file.path).read
    }

    it 'retains the ERB code' do
      result.should include "<%= ENV['my-s3-secret'] %>"
    end

    it 'appends the CloudFront id as the last enabled value in the YAML file' do
      expected = %Q{
s3_id: foo
s3_secret: <%= ENV['my-s3-secret'] %>
s3_bucket: helloworld.com
cloudfront_distribution_id: xxyyzz

# This is a comment
      }
      result.should == expected
    end
  end
end
