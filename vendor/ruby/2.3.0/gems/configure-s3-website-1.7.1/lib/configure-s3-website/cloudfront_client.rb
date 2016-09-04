require "rexml/document"
require "rexml/xpath"

module ConfigureS3Website
  class CloudFrontClient
    def self.apply_distribution_config(options)
      config_source = options[:config_source]
      puts "Detected an existing CloudFront distribution (id #{config_source.cloudfront_distribution_id}) ..."

      # Get caller reference and ETag (will be required by the PUT config resource)
      response = HttpHelper.call_cloudfront_api(
        path = "/2012-07-01/distribution/#{config_source.cloudfront_distribution_id}/config",
        method = Net::HTTP::Get,
        body = '',
        config_source
      )
      etag = response['ETag']
      caller_reference = REXML::XPath.first(
        REXML::Document.new(response.body),
        '/DistributionConfig/CallerReference'
      ).get_text.to_s

      # Call the PUT config resource with the caller reference and ETag
      custom_distribution_config = config_source.cloudfront_distribution_config || {}
      custom_distribution_config_with_caller_ref = custom_distribution_config.merge({
        'caller_reference' => caller_reference,
        'comment' => 'Updated by the configure-s3-website gem'
      })
      HttpHelper.call_cloudfront_api(
        path = "/2012-07-01/distribution/#{options[:config_source].cloudfront_distribution_id}/config",
        method = Net::HTTP::Put,
        body = distribution_config_xml(
          config_source,
          custom_distribution_config_with_caller_ref
        ),
        config_source,
        headers = { 'If-Match' => etag }
      )

      # Report
      unless custom_distribution_config.empty?
        print_report_on_custom_distribution_config custom_distribution_config
      end
    end

    def self.create_distribution_if_user_agrees(options, standard_input)
      if options['autocreate-cloudfront-dist'] and options[:headless]
        puts 'Creating a CloudFront distribution for your S3 website ...'
        create_distribution options
      elsif options[:headless]
        # Do nothing
      else
        puts 'Do you want to deliver your website via CloudFront, the CDN of Amazon? [y/N]'
        case standard_input.gets.chomp
        when /(y|Y)/ then create_distribution options
        end
      end
    end

    private

    def self.create_distribution(options)
      config_source = options[:config_source]
      custom_distribution_config = config_source.cloudfront_distribution_config || {}
      response_xml = REXML::Document.new(
        HttpHelper.call_cloudfront_api(
          '/2012-07-01/distribution',
          Net::HTTP::Post,
          distribution_config_xml(config_source, custom_distribution_config),
          config_source
        ).body
      )
      dist_id = REXML::XPath.first(response_xml, '/Distribution/Id').get_text
      print_report_on_new_dist response_xml, dist_id, options, config_source
      config_source.cloudfront_distribution_id = dist_id.to_s
      puts "  Added setting 'cloudfront_distribution_id: #{dist_id}' into #{config_source.description}"
      unless custom_distribution_config.empty?
        print_report_on_custom_distribution_config custom_distribution_config
      end
    end

    def self.print_report_on_custom_distribution_config(custom_distribution_config, left_padding = 4)
      puts '  Applied custom distribution settings:'
      puts custom_distribution_config.
        to_yaml.
        to_s.
        gsub("---\n", '').
        gsub(/^/, padding(left_padding))
    end

    def self.print_report_on_new_dist(response_xml, dist_id, options, config_source)
      config_source = options[:config_source]
      dist_domain_name = REXML::XPath.first(response_xml, '/Distribution/DomainName').get_text
      s3_website_domain_name = REXML::XPath.first(
        response_xml,
        '/Distribution/DistributionConfig/Origins/Items/Origin/DomainName'
      ).get_text
      puts "  The distribution #{dist_id} at #{dist_domain_name} now delivers the origin #{s3_website_domain_name}"
      puts '    Please allow up to 15 minutes for the distribution to initialise'
      puts '    For more information on the distribution, see https://console.aws.amazon.com/cloudfront'
      if options[:verbose]
        puts '  Below is the response from the CloudFront API:'
        print_verbose_response_from_cloudfront(response_xml)
      end
    end

    def self.print_verbose_response_from_cloudfront(response_xml, left_padding = 4)
      lines = []
      response_xml.write(lines, 2)
      puts lines.join().
        gsub(/^/, "" + padding(left_padding)).
        gsub(/\s$/, "")
    end

    def self.distribution_config_xml(config_source, custom_cf_settings)
      domain_name = "#{config_source.s3_bucket_name}.#{Endpoint.by_config_source(config_source).website_hostname}"
      %|
      <DistributionConfig xmlns="http://cloudfront.amazonaws.com/doc/2012-07-01/">
        <Origins>
          <Quantity>1</Quantity>
          <Items>
            <Origin>
              <Id>#{origin_id config_source}</Id>
              <DomainName>#{domain_name}</DomainName>
              <CustomOriginConfig>
                <HTTPPort>80</HTTPPort>
                <HTTPSPort>443</HTTPSPort>
                <OriginProtocolPolicy>http-only</OriginProtocolPolicy>
              </CustomOriginConfig>
            </Origin>
          </Items>
        </Origins>
        #{
          require 'deep_merge'
          settings = default_cloudfront_settings config_source
          settings.deep_merge! custom_cf_settings
          XmlHelper.hash_to_api_xml(settings)
        }
      </DistributionConfig>
      |
    end

    # Changing these default settings probably necessitates a
    # backward incompatible release.
    #
    # If you change these settings, remember to update also the README.md.
    def self.default_cloudfront_settings(config_source)
      {
        'caller_reference' => 'configure-s3-website gem ' + Time.now.to_s,
        'default_root_object' => 'index.html',
        'logging' => {
          'enabled' => 'false',
          'include_cookies' => 'false',
          'bucket' => '',
          'prefix' => ''
        },
        'enabled' => 'true',
        'comment' => 'Created by the configure-s3-website gem',
        'aliases' => {
          'quantity' => '0'
        },
        'default_cache_behavior' => {
          'target_origin_id' => (origin_id config_source),
          'trusted_signers' => {
            'enabled' => 'false',
            'quantity' => '0'
          },
          'forwarded_values' => {
            'query_string' => 'true',
            'cookies' => {
              'forward' => 'all'
            }
          },
          'viewer_protocol_policy' => 'allow-all',
          'min_TTL' => '86400'
        },
        'cache_behaviors' => {
          'quantity' => '0'
        },
        'price_class' => 'PriceClass_All'
      }
    end

    def self.origin_id(config_source)
      "#{config_source.s3_bucket_name}-S3-origin"
    end

    def self.padding(amount)
      padding = ''
      amount.times { padding << " " }
      padding
    end
  end
end
