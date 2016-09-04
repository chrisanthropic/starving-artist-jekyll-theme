module ConfigureS3Website
  class HttpHelper
    def self.call_s3_api(path, method, body, config_source)
      endpoint = Endpoint.by_config_source(config_source)
      date = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S %Z")
      digest = create_s3_digest(path, method, config_source, date)
      self.call_api(
        path,
        method,
        body,
        config_source,
        endpoint.hostname,
        digest,
        date
      )
    end

    def self.call_cloudfront_api(path, method, body, config_source, headers = {})
      date = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S %Z")
      digest = create_cloudfront_digest(config_source, date)
      self.call_api(
        path,
        method,
        body,
        config_source,
        'cloudfront.amazonaws.com',
        digest,
        date,
        headers
      )
    end

    private

    def self.call_api(path, method, body, config_source, hostname, digest, date, additional_headers = {})
      url = "https://#{hostname}#{path}"
      uri = URI.parse(url)
      req = method.new(uri.to_s)
      req.initialize_http_header({
        'Date' => date,
        'Content-Type' => '',
        'Content-Length' => body.length.to_s,
        'Authorization' => "AWS %s:%s" % [config_source.s3_access_key_id, digest]
      }.merge(additional_headers))
      req.body = body
      http = Net::HTTP.new(uri.host, uri.port)
      # http.set_debug_output $stderr
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = http.request(req)
      if res.code.to_i.between? 200, 299
        res
      else
        raise ConfigureS3Website::ErrorParser.create_error res.body
      end
    end

    def self.create_s3_digest(path, method, config_source, date)
      digest = OpenSSL::Digest.new('sha1')
      method_string = method.to_s.match(/Net::HTTP::(\w+)/)[1].upcase
      can_string = "#{method_string}\n\n\n#{date}\n#{path}"
      hmac = OpenSSL::HMAC.digest(digest, config_source.s3_secret_access_key, can_string)
      signature = Base64.encode64(hmac).strip
    end

    def self.create_cloudfront_digest(config_source, date)
      digest = Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha1'),
          config_source.s3_secret_access_key,
          date
        )
      ).strip
    end
  end
end

private

module ConfigureS3Website
  class ErrorParser
    def self.create_error(amazon_error_xml)
      error_code = amazon_error_xml.delete('\n').match(/<Code>(.*?)<\/Code>/)[1]
      begin
        Object.const_get("#{error_code}Error").new
      rescue NameError
        GenericError.new(amazon_error_xml)
      end
    end
  end
end

class GenericError < StandardError
  def initialize(error_message)
    super("AWS API call failed:\n#{error_message}")
  end
end
