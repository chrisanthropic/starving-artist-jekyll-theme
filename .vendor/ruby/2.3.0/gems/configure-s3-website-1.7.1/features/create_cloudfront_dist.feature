Feature: Create a CloudFront distribution

  @create-cf-dist
  Scenario: The user wants to deliver his website via CloudFront
    Given I answer 'yes' to 'do you want to use CloudFront'
    When I run the configure-s3-website command with parameters
      | option        | value                                                   |
      | --config-file | features/support/sample_config_files/create_cf_dist.yml |
    Then the output should be
      """
      Bucket website-via-cf now functions as a website
      Bucket website-via-cf is now readable to the whole world
      No redirects to configure for website-via-cf bucket
      Do you want to deliver your website via CloudFront, the CDN of Amazon? [y/N]
        The distribution E45H2VN49KPDU at d3feoe9t5ufu01.cloudfront.net now delivers the origin website-via-cf.s3-website-us-east-1.amazonaws.com
          Please allow up to 15 minutes for the distribution to initialise
          For more information on the distribution, see https://console.aws.amazon.com/cloudfront
        Added setting 'cloudfront_distribution_id: E45H2VN49KPDU' into features/support/sample_config_files/create_cf_dist.yml

      """
    And the config file should contain the distribution id

  @create-cf-dist
  Scenario: The user wants to go headless
    When I run the configure-s3-website command with parameters
      | option        | value                                                   |
      | --config-file | features/support/sample_config_files/create_cf_dist.yml |
      | --headless    |  |
    Then the output should be
      """
      Bucket website-via-cf now functions as a website
      Bucket website-via-cf is now readable to the whole world
      No redirects to configure for website-via-cf bucket

      """

  @create-cf-dist
  Scenario: The user wants to go headless and automatically create a CloudFront dist
    When I run the configure-s3-website command with parameters
      | option                       | value                                                   |
      | --config-file                | features/support/sample_config_files/create_cf_dist.yml |
      | --headless                   |  |
      | --autocreate-cloudfront-dist |  |
    Then the output should be
      """
      Bucket website-via-cf now functions as a website
      Bucket website-via-cf is now readable to the whole world
      No redirects to configure for website-via-cf bucket
      Creating a CloudFront distribution for your S3 website ...
        The distribution E45H2VN49KPDU at d3feoe9t5ufu01.cloudfront.net now delivers the origin website-via-cf.s3-website-us-east-1.amazonaws.com
          Please allow up to 15 minutes for the distribution to initialise
          For more information on the distribution, see https://console.aws.amazon.com/cloudfront
        Added setting 'cloudfront_distribution_id: E45H2VN49KPDU' into features/support/sample_config_files/create_cf_dist.yml

      """

  @create-cf-dist
  Scenario: The user wants create a CloudFront distribution with his own settings
    Given I answer 'yes' to 'do you want to use CloudFront'
    When I run the configure-s3-website command with parameters
      | option        | value                                                                       |
      | --config-file | features/support/sample_config_files/create_cf_dist_with_custom_configs.yml |
    Then the output should be
      """
      Bucket website-via-cf now functions as a website
      Bucket website-via-cf is now readable to the whole world
      No redirects to configure for website-via-cf bucket
      Do you want to deliver your website via CloudFront, the CDN of Amazon? [y/N]
        The distribution E45H2VN49KPDU at d3feoe9t5ufu01.cloudfront.net now delivers the origin website-via-cf.s3-website-us-east-1.amazonaws.com
          Please allow up to 15 minutes for the distribution to initialise
          For more information on the distribution, see https://console.aws.amazon.com/cloudfront
        Added setting 'cloudfront_distribution_id: E45H2VN49KPDU' into features/support/sample_config_files/create_cf_dist_with_custom_configs.yml
        Applied custom distribution settings:
          default_cache_behavior:
            min_TTL: 600
          default_root_object: index.json

      """
    And the config file should contain the distribution id

  @create-cf-dist
  Scenario: The user wants to deliver his website via CloudFront and see details on the new distribution
    Given I answer 'yes' to 'do you want to use CloudFront'
    When I run the configure-s3-website command with parameters
      | option        | value                                                   |
      | --config-file | features/support/sample_config_files/create_cf_dist.yml |
      | --verbose     |                                                         |
    Then the output should be
      """
      Bucket website-via-cf now functions as a website
      Bucket website-via-cf is now readable to the whole world
      No redirects to configure for website-via-cf bucket
      Do you want to deliver your website via CloudFront, the CDN of Amazon? [y/N]
        The distribution E45H2VN49KPDU at d3feoe9t5ufu01.cloudfront.net now delivers the origin website-via-cf.s3-website-us-east-1.amazonaws.com
          Please allow up to 15 minutes for the distribution to initialise
          For more information on the distribution, see https://console.aws.amazon.com/cloudfront
        Below is the response from the CloudFront API:
          <?xml version='1.0'?>
          <Distribution xmlns='http://cloudfront.amazonaws.com/doc/2012-07-01/'>
            <Id>
              E45H2VN49KPDU
            </Id>
            <Status>
              InProgress
            </Status>
            <LastModifiedTime>
              2013-05-18T20:08:00.350Z
            </LastModifiedTime>
            <InProgressInvalidationBatches>
              0
            </InProgressInvalidationBatches>
            <DomainName>
              d3feoe9t5ufu01.cloudfront.net
            </DomainName>
            <ActiveTrustedSigners>
              <Enabled>
                false
              </Enabled>
              <Quantity>
                0
              </Quantity>
            </ActiveTrustedSigners>
            <DistributionConfig>
              <CallerReference>
                configure-s3-website gem 2013-05-18 23:07:56 +0300
              </CallerReference>
              <Aliases>
                <Quantity>
                  0
                </Quantity>
              </Aliases>
              <DefaultRootObject>
                index.html
              </DefaultRootObject>
              <Origins>
                <Quantity>
                  1
                </Quantity>
                <Items>
                  <Origin>
                    <Id>
                      website-via-cf-S3-origin
                    </Id>
                    <DomainName>
                      website-via-cf.s3-website-us-east-1.amazonaws.com
                    </DomainName>
                    <CustomOriginConfig>
                      <HTTPPort>
                        80
                      </HTTPPort>
                      <HTTPSPort>
                        443
                      </HTTPSPort>
                      <OriginProtocolPolicy>
                        match-viewer
                      </OriginProtocolPolicy>
                    </CustomOriginConfig>
                  </Origin>
                </Items>
              </Origins>
              <DefaultCacheBehavior>
                <TargetOriginId>
                  website-via-cf-S3-origin
                </TargetOriginId>
                <ForwardedValues>
                  <QueryString>
                    true
                  </QueryString>
                  <Cookies>
                    <Forward>
                      all
                    </Forward>
                  </Cookies>
                </ForwardedValues>
                <TrustedSigners>
                  <Enabled>
                    false
                  </Enabled>
                  <Quantity>
                    0
                  </Quantity>
                </TrustedSigners>
                <ViewerProtocolPolicy>
                  allow-all
                </ViewerProtocolPolicy>
                <MinTTL>
                  86400
                </MinTTL>
              </DefaultCacheBehavior>
              <CacheBehaviors>
                <Quantity>
                  0
                </Quantity>
              </CacheBehaviors>
              <Comment>
                Created by the configure-s3-website gem
              </Comment>
              <Logging>
                <Enabled>
                  false
                </Enabled>
                <IncludeCookies>
                  false
                </IncludeCookies>
                <Bucket/>
                <Prefix/>
              </Logging>
              <PriceClass>
                PriceClass_All
              </PriceClass>
              <Enabled>
                true
              </Enabled>
            </DistributionConfig>
          </Distribution>
        Added setting 'cloudfront_distribution_id: E45H2VN49KPDU' into features/support/sample_config_files/create_cf_dist.yml

      """
    And the config file should contain the distribution id

  @bucket-exists
  Scenario: The user already has CloudFront configured in his configuration file
    When I run the configure-s3-website command with parameters
      | option        | value                                                                           |
      | --config-file | features/support/sample_config_files/config_with_cloudfront_distribution_id.yml |
    Then the output should be
      """
      Bucket name-of-an-existing-bucket now functions as a website
      Bucket name-of-an-existing-bucket is now readable to the whole world
      No redirects to configure for name-of-an-existing-bucket bucket

      """
