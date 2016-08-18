---
layout: page
title: "SEO"
permalink: /documentation/seo.html
--- 
 
* Google Analytics*
  * *Uses Javascript
  * just add your `google_universal_analytics ID` to the _config.yml file.
* Facebook Open Graph
  Fill out the following in your config.yml

  ```
    facebook_app_id:                      #enter your App ID
    facebook_locale: en_US
    facebook_page:                        #the URL of your Facebook Page
    facebook_image:			#enter a default image (at least 200x200px) to use here for posts/pages that don't have one.	
  ```

* Twitter Cards
  Fill out the following in your config.yml

  ```
    twitter_user: 
    twitter_card: true
    twitter_image: 			 #enter a default image (at least 200x200px) to use here for posts/pages that don't have one.
  ```

* Sitewide description/keywords
  * Edit the description in your config.yml and it will be used as the default description in the metadata for every page/post.
  * Add `Keywords: some, bunch, of random keywords` to your config.yml and it will be used as the default keywords in the metadata for every post/page.
  * Set specific keywords per page/post (override the sitewide defaults) by adding them to the front matter of any page/post.
    * Example:

```
---
Title: Example Post
Description: Some Yaml Frontmatter to show what's what.
Keywords: Example, Zim, this is only a test
---
```