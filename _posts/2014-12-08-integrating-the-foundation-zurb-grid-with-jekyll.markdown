---
layout: post
title: "Integrating the Foundation Zurb Grid With Jekyll"
date: 2014-12-08T20:24:51-08:00
sitemap:
  lastmod: 2014-12-08T20:24:51-08:00
  priority: 0.5
  changefreq: monthly
  exclude: 'no'
---

I was playing with the idea of using Bourbon Neat to create a semantic grid but when it comes down to it I'm familiar with Zurb and I like how it works.

I make a decent amount of sites for friends and non-profits and the benefits of Zurbs rapid prototyping are worth it for me.

That being said, I use very little of Zurb's stuff so for now I'm just starting with the grid and visibility classes. Here's how I did it.

### With Compass
This is an update to my original post since I've started using Compass. If you don't use Compass you can still follow the instructions in the 'Without Compass' section.

* clone the bower-foundation repo into your _sass directory
  `git clone git@github.com:zurb/bower-foundation.git`
* create a new subdirectory in your _sass directory called `foundation`
* copy the contents of `bower-foundation/scss/foundation` to your new subdirectory
  * this should include `_functions.scss`, `_settings.scss`, and a directory named `components`
* You can now @import any of the zurb scss stuff from your `css/main.scss` file. For now I'm just importing the grid and visibility:

```
@import "foundation/components/grid";
@import "foundation/components/visibility";
```

  * Note - grid will automatically @import `foundation/components/global` which @imports `foundation/components/fuctions

### Without Compass
Here's the first way I did it, before I integrated compass into my Jekyll site.

* Create a folder in your _sass directory called 'foundation'
* Git clone the 'bower_foundation' repo anywhere on your computer
  `git clone git@github.com:zurb/bower-foundation.git`
* Copy the contents of `bower-foundation/scss/foundation/components/` to the `_sass/foundation` directory you created in step 1.
* Copy `bower-foundation/scss/foundation/_functions.scss` to the `_sass/foundation` directory.
* Open `_sass/foundation/global.scss` and edit the `@import ../"functions";` line to read `@import "functions"` since we moved it into the same directory.
* Delete the `bower-foundation` directory, you don't need it anymore.
* You can now @import any of the zurb scss stuff from your `css/main.scss` file. For now I'm just importing the grid and visibility:

```
@import "foundation/grid";
@import "foundation/visibility";
```

  * Note - grid will automatically @import `foundation/global` which @imports `foundation/fuctions`

That's it. Now you have access to Zurb's grid without any of the JS or other crap that you don't need. You can update at any time by replacing the contents of `_sass/foundation` with the newest files from the zurb `bower-foundation` repo.