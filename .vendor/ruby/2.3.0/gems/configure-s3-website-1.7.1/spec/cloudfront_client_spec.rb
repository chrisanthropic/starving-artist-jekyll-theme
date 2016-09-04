require 'rspec'
require 'configure-s3-website'
require "rexml/document"
require "rexml/xpath"

describe ConfigureS3Website::CloudFrontClient do
  context '#distribution_config_xml' do
    describe 'letting the user to override the default values' do
      let(:config_source) {
        mock = double('config_source')
        mock.stub(:s3_bucket_name).and_return('test-bucket')
        mock.stub(:s3_endpoint).and_return(nil)
        mock
      }

      let(:custom_settings) {
        { 'default_cache_behavior' => { 'min_TTL' => '987' } }
      }

      let(:distribution_config_xml) {
        REXML::Document.new(
          ConfigureS3Website::CloudFrontClient.send(
            :distribution_config_xml,
            config_source,
            custom_settings
          )
        )
      }

      it 'allows the user to override default CloudFront settings' do
        REXML::XPath.first(
          distribution_config_xml,
          '/DistributionConfig/DefaultCacheBehavior/MinTTL'
        ).get_text.to_s.should eq('987')
      end

      it 'retains the default values that are not overriden' do
        REXML::XPath.first(
          distribution_config_xml,
          '/DistributionConfig/DefaultCacheBehavior/ViewerProtocolPolicy'
        ).get_text.to_s.should eq('allow-all')
      end
    end

    describe 'inferring //Origins/Items/Origin/DomainName' do
      let(:config_source) {
        mock = double('config_source')
        mock.stub(:s3_bucket_name).and_return('test-bucket')
        mock.stub(:s3_endpoint).and_return('us-west-1')
        mock
      }

      let(:distribution_config_xml) {
        REXML::Document.new(
          ConfigureS3Website::CloudFrontClient.send(
            :distribution_config_xml,
            config_source,
            custom_distribution_config = {}
          )
        )
      }

      it 'honors the endpoint of the S3 website' do
        REXML::XPath.first(
          distribution_config_xml,
          '/DistributionConfig/Origins/Items/Origin/DomainName'
        ).get_text.to_s.should eq('test-bucket.s3-website-us-west-1.amazonaws.com')
      end
    end
  end
end
