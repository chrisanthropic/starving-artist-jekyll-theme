---
layout: page
title: seo
permalink: "/documentation/seo/"
---   
# SEO
This theme uses the following options SEO options:
- [Keyword Metadata](#keyword-metadata)
- [Description Metadata](#description-metadata)
- [Google Analytics](#google-analytics)
- [Facebook Open Graph](#facebook-open-graph)
- [Twitter Cards](#twitter-cards)

--------
## Keyword Metadata
### Sitewide Defaults
If you set keywords via `_config.yml` they will be used as the default keywords for the metadata for each page.

**Example**     
```
keywords: jekyll, jekyll theme, portfolio theme, artist theme
```

### Per Page
You can override the `_config.yml` defaults for any page or post by adding the following to it's yaml frontmatter.

**Example**     
```
keywords: "different, words, than the defaults"
```

--------
## Description Metadata
### Sitewide Defaults
If you set a description via `_config.yml` it will be used as the default description for the metadata for each page.

**Example**     
```
description: A witty description.
```

### Per Page
You can override the `_config.yml` defaults for any page or post by adding the following to it's yaml frontmatter.

**Example**     
```
description: "An even wittier description."
```

--------
## Google Analytics*
- *Uses Javascript
- Enable by adding the following code to your `_config.yml`
```
google_universal_analytics: YOUR-ANALYTICS-ID
google_universal_analytics_cookiedomain: auto
```
- Replace YOUR-ANALYTICS-ID with your actual analytics ID.

--------
## Facebook Open Graph
### Sitewide Defaults
Enable by filling out the following in your `config.yml`

```
facebook_app_id: 
facebook_locale: en_US
facebook_page: https://www.facebook.com/YOUR-ACCOUNT
facebook_image: images/author.jpg 
```

- facebook_app_id: [Get One Here](https://developers.facebook.com/?advanced_app_create=true)
- facebook_locale: your locale
- facebook_page: the link to your facebook page
- facebook_image: the default image to use when someone shares your post/page on Facebook
    - this image should be at least 200x200 pixels

### Per Page
You can set a custom opengraph metadata per page/post by adding the following to it's yaml frontmatter:

```
facebook_image: /images/path-to-your-image.jpg
facebook_type: article
```
- facebook_image: the path to the image you want displayed when shared on Facebook. 200x200 pixel minimum.
- facebook_type: defaults to 'article'
  - other options at [http://ogp.me/#types](http://ogp.me/#types)

---------
## Twitter Cards
### Sitewide Defaults
Fill out the following in your config.yml

```
twitter_user: YOUR-USER
twitter_card: true
twitter_image: images/author.jpg
```
- twitter_user: Enter your username (no @ before it)
- twitter_card: true/false 
  - enables/disables twitter cards
- twitter_image: the default image to use when someone shares your post/page on Facebook
  - this image should be at least 200x200 pixels

### Per Page
You can set a custom Twitter card metadata per page/post by adding the following to it's yaml frontmatter:

```
twitter_image: /images/path-to-your-image.jpg
```
- twitter_image: the path to the image you want displayed when shared on Facebook. 200x200 pixel minimum.
