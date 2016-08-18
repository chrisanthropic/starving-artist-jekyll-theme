---
layout: post
title: "Moving From Github-Pages to S3"
date: 2014-12-03T17:17:18-08:00
sitemap:
  lastmod: 2014-12-03T17:17:18-08:00
  priority: 0.5
  changefreq: monthly
  exclude: 'no'
---

I decided to move from free github-pages hosting to dirt cheap AWS S3 hosting. I also decided to move my DNS from namecheap to the free CloudFlare plan. Here's the steps I took to transfer everything over.

Most of the steps were adapted from here [http://blog.mindthecloud.com/2014/08/31/create-your-static-blog-from-scratch-in-1-hour.html](http://blog.mindthecloud.com/2014/08/31/create-your-static-blog-from-scratch-in-1-hour.html)

## Prepare AWS

* Login to AWS S3 and create a bucket called `www.YOURSITE.com` (This is important for CNAME/DNS record stuff)
  * Make sure you select the `US Standard` region
* Create a new policy for the bucket that gives everyone read-only access so they can view the site

```
{
	"Version": "2008-10-17",
	"Statement": [
		{
			"Sid": "AddPerm",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::NAME-OF-BUCKET/*"
		}
	]
}
```

* Select the bucket you created and choose `options`
* Go to the `Static Website Hosting` tab and enable it.
* Enter `index.html` for `index document` and `404.html` for `error document`
* Login to [AWS IAM console](https://console.aws.amazon.com/iam)
* Create new user with full access to S3
  * Create new user
  * Choose `attach user policy`
  * Choose `custom policy` and enter the following code:

```
{
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::NAME-OF-BUCKET",
        "arn:aws:s3:::NAME-OF-BUCKET/*"
      ]
    }
  ]
}
```

* The above policy gives the user you created full access to the bucket you created to host your site. This is the user that will be used to deploy your site.

## setup octopress-deploy

* run `octopress deploy init s3` to create default `deploy.yml` file
* Enter the user credentials in the `deploy.yml` file
* Run `octopress deploy`

## Check your work
* Go to AWS / S3, open your bucket, and choose `properties`
* There should be a link listed as `Endpoint`, go to that link and you should see your blog!

## Edit namecheap cname record
* All host records
  * @ points to `www.chrisanthropic.com` and is a `URL Redirect`
  * hostname `www` points to bucket Endpoint (rather than github.io) and is a `CNAME (Alias)`

## Remove Github site
I deleted the github version so for now only the source lives there
  * Delete master or gh-pages branch so that only the source remains

## Use Cloudflare
* Login to CloudFlare
* add your domain
  * Your CNAME and A records should be listed and 'active'
* Select the free plan, CDN only, and Medium security.

## Update your DNS Records
* Login to your DNS provider (I use Namecheap)
* Remove all other DNS providers and add the two that CloudFlare told you to
