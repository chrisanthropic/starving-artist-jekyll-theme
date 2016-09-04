Feature: Modify an existing CloudFront distribution

  @apply-configs-on-cf-dist
  Scenario: The user wants to modify an existing CloudFront distribution
    When I run the configure-s3-website command with parameters
      | option        | value                                                             |
      | --config-file | features/support/sample_config_files/apply_configs_on_cf_dist.yml |
    Then the output should be
      """
      Bucket website-via-cf now functions as a website
      Bucket website-via-cf is now readable to the whole world
      No redirects to configure for website-via-cf bucket
      Detected an existing CloudFront distribution (id E13NX4HCPUP9BP) ...
        Applied custom distribution settings:
          default_cache_behavior:
            min_TTL: 3600
          default_root_object: index.json

      """
