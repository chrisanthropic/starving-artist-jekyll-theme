# Changelog

This project uses [Semantic Versioning](http://semver.org).

## 1.7.1

* Change CloudFront `OriginProtocolPolicy` to `http-only`

  See <https://github.com/laurilehmijoki/s3_website/issues/152> for discussion.

## 1.7.0

* Add eu-central-1 Region

## 1.6.0

* Add switches `--headless` and `--autocreate-cloudfront-dist`

## 1.5.5

* Fix bug that prevented creating new CloudFront distributions in the EU region

## 1.5.4

* Remove usage of the deprecated OpenSSL::Digest::Digest

## 1.5.3

* Do not override ERB code when adding CloudFront dist

## 1.5.2

* Support location constraint eu-west-1

## 1.5.1

* Use the S3 website domain as the Cloudfront origin

  Replace `S3OriginConfig` with `CustomOriginConfig`. This solves the issue
  https://github.com/laurilehmijoki/configure-s3-website/issues/6.

## 1.5.0

* Add support for custom index and error documents

## 1.4.0

* Allow the user to store his CloudFront settings in the config file
 * Support updating configs of an existing CloudFront distribution
 * Support creating of new distros with custom CloudFront configs

## 1.3.0

* Create a CloudFront distro if the user wants to deliver his S3 website via the
  CDN

## 1.2.0

* Support configuring redirects on the S3 website

## 1.1.2

* Use UTC time when signing requests

## 1.1.1

* Do not send the location constraint XML when using the standard region

## 1.1.0

* Add support for non-standard AWS regions
