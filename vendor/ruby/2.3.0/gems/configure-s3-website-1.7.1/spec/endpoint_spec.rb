require 'rspec'
require 'configure-s3-website'

describe ConfigureS3Website::Endpoint do
  it 'should return the same value for EU and eu-west-1' do
    eu = ConfigureS3Website::Endpoint.new('EU')
    eu_west_1 = ConfigureS3Website::Endpoint.new('eu-west-1')
    eu.region.should eq(eu_west_1.region)
    eu.hostname.should eq(eu_west_1.hostname)
    eu.website_hostname.should eq(eu_west_1.website_hostname)
  end
end
