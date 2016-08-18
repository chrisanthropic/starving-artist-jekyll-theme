---
layout: post
title: "Octopress Blog From a Subdirectory"
date: 2014-11-27T20:46:50-08:00
---

I'm using Jekyll and Octopress 3.0 to manage my entire site here, but I want the 'blog' page to be located at [chrisanthropic.com/blog] so here's what I did.

1. Rename the default `index.html` to 'blog.html' (keeping it in root)
2. Edit `_config.yml` 'permalink' to `permalink: /blog/:year/:title`
  - feel free to edit the permalink however you want, so long as it starts with /blog
3. Create a new `index.html` in root
4. add /blog/ link to navigation by adding the proper yaml front matter to 'blog.html'

```
  ---
  layout: page
  title: Blog
  permalink: /blog/
  ---
```

* build/deploy