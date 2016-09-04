Feature: load credentials and the S3 bucket name from a file

  As an AWS S3 user
  Who has S3 credentials and the S3 bucket name in a YAML file
  I would like to configure the bucket to function as a website

  Scenario: config file is missing property "s3_id"
    Given a directory named "website-project"
    And a file named "website-project/s3_config.yml" with:
      """
      id: key
      s3_secret: SECRET
      s3_bucket: my-bucket
      """
    When I run `configure-s3-website --config-file website-project/s3_config.yml`
    Then the output should contain:
      """
      website-project/s3_config.yml does not contain the required key(s) s3_id
      """

  Scenario: config file is missing property "s3_secret"
    Given a directory named "website-project"
    And a file named "website-project/s3_config.yml" with:
      """
      s3_id: key
      s3_bucket: my-bucket
      """
    When I run `configure-s3-website --config-file website-project/s3_config.yml`
    Then the output should contain:
      """
      website-project/s3_config.yml does not contain the required key(s) s3_secret
      """

  Scenario: config file is missing property "s3_bucket"
    Given a directory named "website-project"
    And a file named "website-project/s3_config.yml" with:
      """
      s3_id: key
      s3_secret: secret
      """
    When I run `configure-s3-website --config-file website-project/s3_config.yml`
    Then the output should contain:
      """
      website-project/s3_config.yml does not contain the required key(s) s3_bucket
      """

  Scenario: config file is missing properties "s3_bucket" and "s3_id"
    Given a directory named "website-project"
    And a file named "website-project/s3_config.yml" with:
      """
      s3_secret: secret
      """
    When I run `configure-s3-website --config-file website-project/s3_config.yml`
    Then the output should contain:
      """
      website-project/s3_config.yml does not contain the required key(s) s3_id, s3_bucket
      """
