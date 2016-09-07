---
layout: page
title: layouts
permalink: "/documentation/layouts/"
---  
# Custom Layouts:
You can use the following custom layouts with this theme:
- [Compress](#compress)
- [About](#about-page)
- [Blog](#blog-page)
- [Contact](#contact-page)
- [Gallery](#gallery-page)

---------
## Compress
This layout automatically compresses the html output of all pages.      
Thanks to [https://github.com/penibelst/jekyll-compress-html](html_minify)

---------
## About Page
This page is meant to show a logo or image of the creator along with a bio or description.

- Create a new page with the following frontmatter.
```
layout: about
title: about
permalink: "/about/"
logo: "/path/to/author/image"
```
- Set an optional logo/author image.
- Write your content as normal.

---------
## Blog Page
This page will automatically show your blog posts.
- Create a new page with the following frontmatter.
```
layout: blog
title: blog
permalink: "/blog/"
```

---------
## Contact Page
This contact form is meant to be used with a FREE formspree.io account.
- Create a free [formspree.io](https://formspree.io/) account
- Add your formspree info to your _config.yml
  - `contct_form: https://formspree.io/example@email.com`
- You can also set the contact form per page by adding the following to the Yaml frontmatter for that page:
  - `contact_form: https://formspree.io/example@email.com`

- Create a new page with the following frontmatter.
```
layout: contact
title: contact
permalink: "/contact/"
contact_form: https://formspree.io/example@email.com
```

---------
## Gallery Page
This layout will automatically generate gallery pages for any gallery collections you define.

### Set Up Collections
- Create an empty directory called `_galleries`
  - `mkdir _galleries`

- Add it to your _config.yml:

```
collections:
  - galleries
```

### Add Images
A gallery needs images so add some images to your site.

### Create a Gallery
We're going to create an example gallery called 'illustration'.

- Create a new page with the following frontmatter.
```
layout: gallery
title: illustration
permalink: "/illustration/"
```

- Create a new file called `illustration.yml` in the `_galleries` directory with the following content:

```
---
name: "illustration"
arts:
- image: "images/path/to/your/images.jpg"
  order: "1"
  title: ""
  artist: ""
  description: ""
```

- Modify the yaml as needed:
  - image: list the path to your test image.
  - order: whole numbers starting at 1. This is the order images will be shown when navigating through them.
  - title: the title of your image
  - artist: optional
  - description: optional

- Now navigate to `http://YOUR-URL/illustration/` and see your image!

### Adding More Images to an Existing Gallery
To add more images simply open `_galleries/illustration.yml` and add more data (image, order, title, artist, description):

**Example**
```
---
name: "illustration"
arts:
- image: "images/path/to/your/images.jpg"
  order: "1"
  title: ""
  artist: ""
  description: ""
- image: "images/path/to/your/images2.jpg"
  order: "2"
  title: ""
  artist: ""
  description: ""
- image: "images/path/to/your/images3.jpg"
  order: "3"
  title: ""
  artist: ""
  description: ""
```

### Adding Multiple Galleries
To add multiple galleries:
- Copy `_galleries/illustration.yml` to `_galleries/OTHERNAME.yml`
- Change the `name:` field in `_galleries/OTHERNAME.yml`
- Modify the image information as needed (image, order, title, artist, description)

**Example**

To create a second gallery called "doodles" create a file called `_galleries/doodles.yml` with the following:
```
---
name: "doodles"
arts:
- image: "images/path/to/your/images.jpg"
  order: "1"
  title: ""
  artist: ""
  description: ""
- image: "images/path/to/your/images2.jpg"
  order: "2"
  title: ""
  artist: ""
  description: ""
- image: "images/path/to/your/images3.jpg"
  order: "3"
  title: ""
  artist: ""
  description: ""
```
- Now navigate to `http://YOUR-URL/doodles/` and see your image!
