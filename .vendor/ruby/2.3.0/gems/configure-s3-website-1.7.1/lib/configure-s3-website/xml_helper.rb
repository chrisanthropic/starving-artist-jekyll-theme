module ConfigureS3Website
  class XmlHelper
    def self.hash_to_api_xml(hash={}, indent=0)
      "".tap do |body|
        hash.each do |key, value|
          key_name = key.sub(/^[a-z\d]*/) { $&.capitalize }.gsub(/(?:_|(\/))([a-z\d]*)/) { $2.capitalize }
          value = value.is_a?(Hash) ? self.hash_to_api_xml(value, indent+1) : value
          body << "\n"
          body << " " * indent * 2 # 2-space indentation formatting for xml
          body << "<#{key_name}>#{value}</#{key_name}>"
        end
      end
    end
  end
end
