# starving-artist-jekyll-theme

Live Demo [HERE](http://chrisanthropic.github.io/starving-artist-jekyll-theme/)

Starving Artist is a simple portfolio theme for visual artists to easily share their work.

## Installation

Add this line to your Jekyll site's Gemfile:

```ruby
gem 'starving-artist-jekyll-theme', github: 'chrisanthropic/starving-artist-jekyll-theme'
```

And add this line to your Jekyll site:

```yaml
theme: starving-artist
```

And then execute:

    $ bundle

## Usage

Includes the following custom layouts:

- about.html
- blog.html
- contact.html
- gallery.html

## Basic features include:

* Jekyll 3.0 compatible
* SASS
* Minimal Zurb Foundation 6 Integration
    * Flexbox grid
    * Visibility classes
* Responsive / Mobile-friendly
* **Javascript free**
* Basic SEO
    * Facebook opengraph integration
    * Twitter card integration

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

### FLEXBOX GRID
Uses minimal sass from Zurb Foundation:

* [grid](http://foundation.zurb.com/sites/docs/flex-grid.html)

### NAVIGATION

* Populated using Jekyll 'data' nav.yml file
* Easily customizable text, link, and background colors using the supplied sass variables

### JAVASCRIPT FREE
The only thing in the theme that uses Javascript is the optional use of google analytics.

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
