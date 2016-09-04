require 'yaml'
require 'erb'

module ConfigureS3Website
  class FileConfigSource < ConfigSource
    def initialize(yaml_file_path)
      @yaml_file_path = yaml_file_path
      @config = FileConfigSource.parse_config yaml_file_path
    end

    def description
      @yaml_file_path
    end

    def s3_access_key_id
      @config['s3_id']
    end

    def s3_secret_access_key
      @config['s3_secret']
    end

    def s3_bucket_name
      @config['s3_bucket']
    end

    def s3_endpoint
      @config['s3_endpoint']
    end

    def routing_rules
      @config['routing_rules']
    end

    def index_document
      @config['index_document']
    end

    def error_document
      @config['error_document']
    end

    def cloudfront_distribution_config
      @config['cloudfront_distribution_config']
    end

    def cloudfront_distribution_id
      @config['cloudfront_distribution_id']
    end

    def cloudfront_distribution_id=(dist_id)
      @config['cloudfront_distribution_id'] = dist_id
      file_contents = File.open(@yaml_file_path).read
      File.open(@yaml_file_path, 'w') do |file|
        result = file_contents.gsub(
          /(s3_bucket:.*$)/,
          "\\1\ncloudfront_distribution_id: #{dist_id}"
        )
        file.write result
      end
    end

    private

    def self.parse_config(yaml_file_path)
      config = YAML.load(ERB.new(File.read(yaml_file_path)).result)
      validate_config(config, yaml_file_path)
      config
    end

    def self.validate_config(config, yaml_file_path)
      required_keys = %w{s3_id s3_secret s3_bucket}
      missing_keys = required_keys.reject do |key| config.keys.include?key end
      unless missing_keys.empty?
        raise "File #{yaml_file_path} does not contain the required key(s) #{missing_keys.join(', ')}"
      end
    end
  end
end
