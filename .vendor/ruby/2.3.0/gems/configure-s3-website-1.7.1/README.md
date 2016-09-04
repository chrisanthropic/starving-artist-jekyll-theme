# Configure-s3-website

[![Build Status](https://secure.travis-ci.org/laurilehmijoki/configure-s3-website.png)](http://travis-ci.org/laurilehmijoki/configure-s3-website)
[![Gem Version](https://fury-badge.herokuapp.com/rb/configure-s3-website.png)](http://badge.fury.io/rb/configure-s3-website)

Configure an AWS S3 bucket to function as a website. Easily from the
command-line interface.

The bucket may or may not exist. If the bucket does not exist,
`configure-s3-website` will create it.

For deploying websites to S3, consider using [s3_website](https://github.com/laurilehmijoki/s3_website).

## Install

    gem install configure-s3-website

## Usage

Create a file that contains the S3 credentials and the name of the bucket:

```yaml
s3_id: your-aws-access-key
s3_secret: your-aws-secret-key
s3_bucket: name-of-your-bucket
```

Save the file (as *config.yml*, for example). Now you are ready to go. Run the
following command:

    configure-s3-website --config-file config.yml

Congratulations! You now have an S3 bucket that can act as a website server for
you.

### Deliver your website via CloudFront

This gem can create new CloudFront distributions and update existing ones.

#### Creating a new distribution

`configure-s3-website` can create a CloudFront distribution for you. It will ask
you whether you want to deliver your website via the CDN. If you answer yes,
`configure-s3-website` will create a CloudFront distribution that has the
configured S3 bucket as its origin. In addition, it will add the entry
`cloudfront_distribution_id: [id-of-the-new-distribution]` into your
configuration file.

CloudFront can be configured in various ways. However, the distribution created
by `configure-s3-website` uses sensible defaults for an S3-based website and
thus saves you the burden of figuring out how to configure CloudFront. For
example, it assumes that your default root object is *index.html*.

You can see all the settings this gem applies on the new distribution by running
the command in verbose mode:

    configure-s3-website --config-file config.yml --verbose

Note that if you already have the key `cloudfront_distribution_id` in your
configuration file, `configure-s3-website` will not create a new distribution.
Conversely, if you remove the `cloudfront_distribution_id` key from the file and
run `configure-s3-website` again, it will create you a new distribution.

##### Creating a new distribution with custom settings

If the default settings do not suit you, you can create a new distribution with
your settings by adding `cloudfront_distribution_config` values into your config
file. For example:

```yaml
cloudfront_distribution_config:
  default_cache_behavior:
    min_TTL: 600
  aliases:
    quantity: 1
    items:
      CNAME: your.domain.net
```

See the section below for more information about the valid values of the
`cloudfront_distribution_config` setting.

If you want to, you can look at the distribution settings on the management console
at <https://console.aws.amazon.com/cloudfront>.

#### Updating an existing distribution

You can modify an existing CloudFront distribution by defining the id of the
distribution and the configs you wish to override the defaults with.

Let's say your config file contains the following fragment:

```yaml
cloudfront_distribution_id: AXSAXSSE134
cloudfront_distribution_config:
  default_cache_behavior:
    min_TTL: 600
  default_root_object: index.json
```

When you invoke `configure-s3-website`, it will overwrite the default value of
*default_cache_behavior's* *min_TTL* as well as the default value of
*default_root_object* setting in the [default distribution configs](#default-distribution-configs).

This gem generates `<DistributionConfig>` of the CloudFront REST API. For
reference, see
<http://docs.aws.amazon.com/AmazonCloudFront/latest/APIReference/GetConfig.html#GetConfig_Responses>
(example) and
<https://cloudfront.amazonaws.com/doc/2012-07-01/AmazonCloudFrontCommon.xsd>
(XSD). In other words, When you call `configure-s3-website`, it will turn the values of your
`cloudfront_distribution_config` into XML, include them in the
`<DistributionConfig>` element and send them to the CloudFront REST API.

The YAML keys in the config file will be turned into CloudFront REST API XML
with the same logic as in [configuring redirects](#configuring-redirects).

Having the distribution settings in the config file is handy, because it allows
you to store most (in many cases all) website deployment settings in one file.

#### Default distribution configs

Below is the default CloudFront distribution config. It is built based on the
API version 2012-07-01 of [DistributionConfig Complex
Type](http://docs.aws.amazon.com/AmazonCloudFront/latest/APIReference/DistributionConfigDatatype.html).

```ruby
{
  'caller_reference' => 'configure-s3-website gem [generated-timestamp]',
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
    'target_origin_id' => '[generated-string]',
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
```

### Specifying a non-standard S3 endpoint

By default, `configure-s3-website` creates the S3 website into the US Standard
region.

If you want to create the website into another region, add into the
configuration file a row like this:

    s3_endpoint: EU

The valid *s3_endpoint* values consist of the [S3 location constraint
values](http://docs.amazonwebservices.com/general/latest/gr/rande.html#s3_region).


### Specifying non-standard index or error documents

By default, `configure-s3-website` uses `index.html` for the index document and `error.html` for the error document.

You can override either or both of these defaults like this:

    index_document: default.html
    error_document: 404.html

You can specify the name of any document in the bucket.


### Configuring redirects

You can configure redirects on your S3 website by adding `routing_rules` into
the config file.

Here is an example:

````yaml
routing_rules:
  - condition:
      key_prefix_equals: blog/some_path
    redirect:
      host_name: blog.example.com
      replace_key_prefix_with: some_new_path/
      http_redirect_code: 301
````

You can use any routing rule property that the [REST
API](http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketPUTwebsite.html)
supports. All you have to do is to replace the uppercase letter in AWS XML with
an underscore and an undercase version of the same letter. For example,
`KeyPrefixEquals` becomes `key_prefix_equals` in the config file.

Apply the rules by invoking `configure-s3-website --config [your-config-file]`
on the command-line interface. You can verify the results by looking at your
bucket on the [S3 console](https://console.aws.amazon.com/s3/home).

## How does `configure-s3-website` work?

`configure-s3-website` uses the AWS REST API of S3 for creating and modifying
the bucket. In brief, it does the following things:

1. Create a bucket for you (if it does not yet exist)
2. Add the website configuration on the bucket via the [website REST
   API](http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketPUTwebsite.html)
3. Make the bucket **readable to the whole world**
4. Apply the redirect (a.k.a routing) rules on the bucket website

When interacting with CloudFront, `configure-s3-website` uses the [POST
Distribution](http://docs.aws.amazon.com/AmazonCloudFront/latest/APIReference/CreateDistribution.html),
[GET
Distribution](http://docs.aws.amazon.com/AmazonCloudFront/latest/APIReference/GetDistribution.html) and [PUT Distribution Config](http://docs.aws.amazon.com/AmazonCloudFront/latest/APIReference/PutConfig.html) APIs.

### Running headlessly

Use the `--headless` option to run without user interaction. If you add the
`--autocreate-cloudfront-dist` option, `configure-s3-website` will automatically
create a CloudFront distribution for your S3 website.

## Development

* This project uses [Semantic Versioning](http://semver.org)

## Credit

Created by Lauri Lehmijoki.

Big thanks to the following contributors (in alphabetical order):

* SlawD
* Steve Schwartz
* Toby Marsden

## Supported Ruby versions

The file `.travis.yml` defines the officially supported Ruby versions. This gem
might work on other versions as well, but they are not covered with continuous
integration.

## License

See the file LICENSE.
