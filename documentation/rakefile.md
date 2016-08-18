---
layout: page
title: "rakefile"
permalink: /documentation/rakefile.html
--- 
Includes the following custom tasks:

* *minify_html* - uses HTML_compressor to minify HTML
* *notify* - pings google and bing to notify them about changes to the site/sitemap

These 3 tasks have been bundled into custom build and deploy tasks

* *build* - runs `jekyll build` followed by `minify_html`
* *deploy* - runs `s3_website push` and then `notify`