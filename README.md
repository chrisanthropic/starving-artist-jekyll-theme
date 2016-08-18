slim-pickins-jekyll-theme
=============

Live Demo [HERE](http://chrisanthropic.github.io/slim-pickins-jekyll-theme/)

Slim Pickins is what I consider to be a minimal 'core' theme with everything I need to quickly develop new themes for Jekyll.

## Basic features include:

* Jekyll 3.0 compatible
* SASS
* Minimal Zurb Foundation 6 Integration
    * Responsive grid
    * Visibility classes
* Responsive navigation
* Optional full-width banner
* Sticky footer
* **Javascript free**
* Custom Rakefile with tasks for deploying, minifying, and notifying search engines about updates
* image_optim plugin to optimize all images
* Basic SEO

### SASS
Includes the following variables:

**Base Colors**
* $primary-color
* $secondary-color
* $complimentary-color
* $body-bg
* $body-font-color

**Links**
* link-color
* link-hover-color
* link-visited-color

**Text**
* $base-font-family
* $base-font-size
* $small-font-size
* $base-line-height

**Navbar Settings**
* $navbar-height
* $navbar-color
* $navbar-text-color
* $navbar-hover-color
* $navbar-active-color
* $navbar-font-size
* $navbar-font-family

**Socials Navbar Settings**
* $socials-font-color
* $socials-font-size

**Utility**
* $spacing-unit

**Footer**
* $footer-height
* $footer-color

### GRID
Uses minimal sass from Zurb Foundation:

* [grid](http://foundation.zurb.com/sites/docs/grid.html)

### NAVIGATION
A fully responsive navigation bar with the following features:

* 2 navigation areas
  * Left - Primary navigation 
  * Right - Social media links
* Both navigation areas are populated using Jekyll 'data' files, nav.yml and socials.yml respectively
* Ability to create 'external' links that link offsite while still using socials.yml to do so
* Easily customizable text, link, and background colors using the supplied sass variables

### BANNER
This theme is configured with a 'wrap' of 1920px so banner images look best at that width.

First it checks a pages yaml frontmatter for the header image, if none is found then it checks for a site-wide default in your config.yml, if none is found then no banner image is displayed.

**Site-Wide**
You can set a site-wide default banner image by adding the following to your _config.yml:
  `header_image: "path/to/image.jpg"`

**Per Page**
You can also override it per page by adding the following code to a pages yaml front matter:
  `header_image: path/to/image.jpg`

### STICKY FOOTER
I like my footers to stay on the bottom of the page no matter what. You can easily edit the size and color using the supplied sass variables.

### JAVASCRIPT FREE
The only thing in the theme that uses Javascript is the optional use of google analytics.

### RAKEFILE
Includes the following custom tasks:

* *minify_html* - uses HTML_compressor to minify HTML
* *notify* - pings google and bing to notify them about changes to the site/sitemap

These tasks have been bundled into custom build and deploy tasks

* *build* - runs `jekyll build` followed by `minify_html`
* *deploy* - runs `s3_website push` and then `notify`

### IMAGE_OPTIM PLUGIN

* Custom [image_optim](https://github.com/chrisanthropic/image_optim-jekyll-plugin) plugin will optimize all images in the /images folder and any subdirectories
  * Uses the original [image_optim](https://github.com/toy/image_optim)
* Cache file is created on the first run so that only updated/new images are optimized

### BASIC SEO

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

## Basic Use
For now it's best to start fresh or install the them and then transfer over any old files (posts, images, etc) from your old site.

* Git clone this repo, cd into the directory and run `bundle install --binstubs --path=vendor` to install the required dependencies.
* Edit your config.yml file
  * Change the title and description at a minimum.
* Update your navigation 
  * edit the `_data/nav.yml` file as needed
* Update your social links
  * edit the `_data/socials.yml` file as needed

## Deploying
I use S3 to host my site and the [s3_website](https://github.com/laurilehmijoki/s3_website) plugin to deploy, if you don't do both of these, delete the `s3_website.yml` file and edit the deploy raketask to fit your needs.

If you plan on using S3 make sure you edit the configs:

* FIRST - add the s3_website.yml file to your gitignore so your credentials don't end up on the web.
* s3_website.yml
  * add your `s3_id`. `s3_secret`, and `s3_bucket`
* Update the Rakefile notify task to use your url
  * replace `site = "www.YOUR-URL.com"` with your actual url.

## MISC.
The blog posts included are duplicated from my actual blog and are the documentation of how I created this theme. From starting with a fresh Jekyll installation to the final product.