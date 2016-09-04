require 'rspec'
require 'configure-s3-website'

describe ConfigureS3Website::XmlHelper do
  context '#hash_to_api_xml' do
    it 'returns an empty string, if the hash is empty' do
      str = ConfigureS3Website::XmlHelper.send(:hash_to_api_xml,
                                        { })
      str.should eq('')
    end

    it 'capitalises hash keys but not values' do
      str = ConfigureS3Website::XmlHelper.send(:hash_to_api_xml,
                                        { 'key' => 'value' })
      str.should eq("\n<Key>value</Key>")
    end

    it 'removes underscores and capitalises the following letter' do
      str = ConfigureS3Website::XmlHelper.send(:hash_to_api_xml,
                                        { 'hello_key' => 'value' })
      str.should eq("\n<HelloKey>value</HelloKey>")
    end

    it 'can handle hash values as well' do
      str = ConfigureS3Website::XmlHelper.send(:hash_to_api_xml,
                                        { 'key' => { 'subkey' => 'subvalue' } })
      str.should eq("\n<Key>\n  <Subkey>subvalue</Subkey></Key>")
    end

    it 'indents' do
      str = ConfigureS3Website::XmlHelper.send(
        :hash_to_api_xml,
        { 'key' => { 'subkey' => 'subvalue' } },
        indent = 1
      )
      str.should eq("\n  <Key>\n    <Subkey>subvalue</Subkey></Key>")
    end
  end
end
