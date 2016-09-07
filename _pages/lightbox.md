---
layout: page
title: lightbox
permalink: "/documentation/lightbox/"
--- 
# Lightbox
The Javascript-free lightbox is the pop-up that displays a gallery image when it's clicked. _You must create a page that uses the [gallery layout](/documentation/layouts/#gallery-page) if you want to use our lightbox)_.  

The lightbox colors can be configured via the _variables.scss file.   

The lightbox pull information from your `_galleries/$GALLERY.yaml` file. It will display the following:
- A caption beneath the image displaying the `$TITLE by $ARTIST`
- A semi-transparent overlay displaying the `$DESCRIPTION`. Overlay can be closed by clicking on the "X".

Both the caption and the description will simply not show if that information is left blank for a particular image in the gallery.yml file.

![Lightbox Example Screenshot]({{ site.github.url }}/images/posts/lightbox-screenshot.jpg)
