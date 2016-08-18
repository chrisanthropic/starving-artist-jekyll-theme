---
layout: page
title: "banner"
permalink: /documentation/banner.html
header: yes
header_sm: images/banner-xl2.jpg
header_med: images/banner-xl2.jpg
header_large: images/banner-xl2.jpg
header_xl: images/banner-xl2.jpg
--- 

**Basics**
You can set the banner per page or site-wide. This page has a custom banner (see, it's upside-down).

First it checks a pages yaml frontmatter for the header image, if none is found then it checks for a site-wide default in your config.yml, if none is found then no banner image is displayed.

**srcset**
The banner uses the `srcset` tag to set different sized images for different screens, so we'll need 4 sizes of our banner image: 

* small
* medium
* large
* extra-large

**Sizes**
Since we're using Zurb's grid, we're going to use their breakpoints to determine sizes. The demo site is using the following widths:

* small: 640px
* medium: 1024px
* large: 1440px
* extra-large: 1920px

**Fallback**
We also use `img src` with the extra-large sized image for browsers that don't support srcset.

**Site-Wide Banner**
You can set a site-wide default banner image by adding the following to your _config.yml:

```
header: yes
header_sm: path/to/banner-sm.jpg
header_med: path/to/banner-med.jpg
header_large: path/to/banner-large.jpg
header_xl: path/to/banner-xl.jpg
```

**Per Page Banner**
You can also override it per page by adding the same code to the yaml front matter of any page.


