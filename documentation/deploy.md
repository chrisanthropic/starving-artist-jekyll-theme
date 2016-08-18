---
layout: page
title: "deployment"
permalink: /documentation/deploy.html
--- 
I use S3 to host my site and the [s3_website](https://github.com/laurilehmijoki/s3_website) plugin to deploy, if you don't do both of these, delete the `s3_website.yml` file and edit the deploy raketask to fit your needs.

If you plan on using S3 make sure you edit the configs:

* FIRST - add the s3_website.yml file to your gitignore so your credentials don't end up on the web.
* s3_website.yml
  * add your `s3_id`. `s3_secret`, and `s3_bucket`
* Update the Rakefile notify task to use your url
  * replace `site = "www.YOUR-URL.com"` with your actual url.