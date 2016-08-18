---
layout: post
title: "Deploy Jekyll to S3 With S3_website"
date: 2014-12-05T11:01:42-08:00
sitemap:
  lastmod: 2014-12-05T11:01:42-08:00
  priority: 0.5
  changefreq: monthly
  exclude: 'no'
---

I'd originally set this up to deploy to S3 using the new-ish Octopress-Deploy gem but after using it a bit I've found that it's still too rough to be my goto.

The main benefits of switching to S3_website are:

* Incremental deploy. It only pushes files that have been updated.
* Proper metadata. Octopress-deploy marked all of my files as `Content-Type: image/jpeg` 
* Caching. Setting max-age is very simple with this plugin.
* Gzip. The plugin can automatically compress the files before pushing it to S3. This makes things load faster and reduces your bandwidth costs.

Below are the steps I took to migrate from `octopress-deploy` to [S3_website](https://github.com/laurilehmijoki/s3_website).

* First I added `s3_website.yml` to .gitignore since it'll hold our S3 credentials and we don't want those public.
* add s3_website to Gemfile
* Install the gem by running `bundle install --binstubs --path=vendor`
* Create the default config by running `bundle exec s3_website cfg create`
* add your S3 credentials to `s3_config.yml`
* **GZIP** add `gzip: true` to `s3_website.yml`
* **CACHE** Update max-age in `s3_website.yml`
```
max_age:
  "css/*": 604800
  "*": 300
```
* update Rakefile build command to `system "bundle exec s3_website push"`
* bundle exec rake build
* run the initial push with the --force flag just to make sure it updates cache metadata for all files
  `bundle exec s3_website push --force`
* Login to Cloudflare and purge the cache to make sure your serving up your new gzip/cache files

From now on you can run `bundle exec rake deploy` and the S3_website plugin will compress all of your files, add cache headers to them, and push any that have changed to your S3 bucket.