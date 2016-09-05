---
layout: page
title: social-icons
permalink: "/documentation/social-icons/"
---
# Social Icons

Social Media Icons are set using Jekyll's [Data Files](https://jekyllrb.com/docs/datafiles/) feature.     
You can add links to the following services to your navigation menu:
- RSS / Feed
- Google+
- Facebook
- Tumblr
- Twitter
- Github
- LinkedIn

## Create Your Social Icons File
To set your social icon links:
- Create a new file called `_data/socials.yml`
  - create the directory `_data` if it doesn't exist.

To add a service simply copy and paste it's corresponding code into the `_data/socials.yml` file.

## RSS
```
- title: "feed"
  href: "https://YOUR-URL/atom.xml"
```

## Google+
```
- title: "googleplus"
  href: "https://plus.google.com/+YOUR-ACCOUNT"
```

## Facebook
```
- title: "facebook"
  href: "https://facebook.com/YOUR-ACCOUNT"
```

## Tumblr
```
- title: "tumblr"
  href: "https://YOUR-ACCOUNT.tumblr.com"
```

## Twitter
```
- title: "twitter"
  href: "https://twitter.com/YOUR-ACCOUNT"
```

## Github
```
- title: "github"
  href: "https://github.com/YOUR-ACCOUNT"
```

## LinkedIn
```
- title: "linkedin"
  href: "https://www.linkedin.com/in/YOUR-ACCOUNT"
```
