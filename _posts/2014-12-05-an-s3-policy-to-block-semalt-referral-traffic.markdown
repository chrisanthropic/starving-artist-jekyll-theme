---
layout: post
title: "An S3 Policy to Block Semalt Referral Traffic"
date: 2014-12-05T14:06:15-08:00
sitemap:
  lastmod: 2014-12-05T14:06:15-08:00
  priority: 0.5
  changefreq: monthly
  exclude: 'no'
---

A lot of people have noticed shit tons of ferferral spam from semalt.com and their various other domains.

It's fucking annoying.

I found a short S3 policy [here](http://admium.tumblr.com/) that blocked semalt.com from accessing static sites hosted on S3 and adapted it to include larger list of all know semalt.com domains as well as some from my logs.

I created a repo for the policy and you can find it [here](https://github.com/chrisanthropic/S3-semalt-blocklist-policy).

### About
The policy blocks variations and subdomains of the given sites: ie `semalt.com`, `semalt.com/anything`, `randomstringsemalt.com`, `www.semalt.com`, `www.semalt.com/anything`

### Use
Copy and past the contents of [blocklist.txt](https://raw.githubusercontent.com/chrisanthropic/S3-semalt-blocklist-policy/master/Policy.txt) to your S3 bucket policy and change the two instances of `YOURBUCKETNAME` to the actual name of your bucket.

### Blocklist
The following sites are blocked:

  * semalt.com
  * backgroundpictures.net
  * baixar-musicas-gratis.com
  * buttons-for-website.com
  * darodar.com
  * descargar-musica-gratis.net
  * embedle.com
  * extener.com
  * extener.org
  * fbdownloader.com
  * fbfreegifts.com
  * feedouble.com
  * feedouble.net
  * japfm.com
  * joinandplay.me
  * joingames.org
  * kambasoft.com
  * musicprojectfoundation.com
  * myprintscreen.com
  * openfrost.com
  * openfrost.net
  * openmediasoft.com
  * pictureframingperth.net.au
  * savetubevideo.com
  * serw.clicksor.com
  * sharebutton.net
  * softomix.com
  * softomix.net
  * softomix.ru
  * soundfrost.org
  * srecorder.com
  * star61.de
  * torontoplumbinggroup.com
  * vapmedia.org
  * videofrost.com
  * youtubedownload.org
  * zazagames.org