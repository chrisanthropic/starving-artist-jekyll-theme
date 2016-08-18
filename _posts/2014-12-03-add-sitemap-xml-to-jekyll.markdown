---
layout: post
title: "Add sitemap.xml to Jekyll"
date: 2014-12-03T10:40:40-08:00
sitemap:
  lastmod: 2014-12-03T10:40:40-08:00
  priority: 0.5
  changefreq: monthly
  exclude: 'no'
---

I don't like using plugins unless absolutely necessarry so I was happy to find a simple way to create a sitemap without one. The instructions are taken from this site: [http://davidensinger.com/2013/11/building-a-better-sitemap-xml-with-jekyll/](http://davidensinger.com/2013/11/building-a-better-sitemap-xml-with-jekyll/)

* Create a `sitemap.xml` file with the following content:

```
{% raw %}
---
layout: null
sitemap:
  exclude: 'yes'
---
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  {% for post in site.posts %}
    {% unless post.published == false %}
    <url>
      <loc>{{ site.url }}{{ post.url }}</loc>
      {% if post.sitemap.lastmod %}
        <lastmod>{{ post.sitemap.lastmod | date: "%Y-%m-%d" }}</lastmod>
      {% elsif post.date %}
        <lastmod>{{ post.date | date_to_xmlschema }}</lastmod>
      {% else %}
        <lastmod>{{ site.time | date_to_xmlschema }}</lastmod>
      {% endif %}
      {% if post.sitemap.changefreq %}
        <changefreq>{{ post.sitemap.changefreq }}</changefreq>
      {% else %}
        <changefreq>monthly</changefreq>
      {% endif %}
      {% if post.sitemap.priority %}
        <priority>{{ post.sitemap.priority }}</priority>
      {% else %}
        <priority>0.5</priority>
      {% endif %}
    </url>
    {% endunless %}
  {% endfor %}
  {% for page in site.pages %}
    {% unless page.sitemap.exclude == "yes" %}
    <url>
      <loc>{{ site.url }}{{ page.url | remove: "index.html" }}</loc>
      {% if page.sitemap.lastmod %}
        <lastmod>{{ page.sitemap.lastmod | date: "%Y-%m-%d" }}</lastmod>
      {% elsif page.date %}
        <lastmod>{{ page.date | date_to_xmlschema }}</lastmod>
      {% else %}
        <lastmod>{{ site.time | date_to_xmlschema }}</lastmod>
      {% endif %}
      {% if page.sitemap.changefreq %}
        <changefreq>{{ page.sitemap.changefreq }}</changefreq>
      {% else %}
        <changefreq>monthly</changefreq>
      {% endif %}
      {% if page.sitemap.priority %}
        <priority>{{ page.sitemap.priority }}</priority>
      {% else %}
        <priority>0.3</priority>
      {% endif %}
    </url>
    {% endunless %}
  {% endfor %}
</urlset>
{% endraw %}
```

* Add the following configurable settings to your templates:

```
sitemap:
  lastmod: {{ date }}
  priority: 0.5
  changefreq: monthly
  exclude: 'no'
```

* More info on the settings can be found at [sitemaps.org](http://www.sitemaps.org/protocol.html) but basically
  * **lastmod** - lists the last time the page/post was modified
  * **priority** - tells web crawlers how *you* prioritize the page/post on a scale of 0.0 -1.0. 0.5 is default.
  * **changefreq** - a guideline for the webcrawler about how often the page/post likely changes (always, hourly, daily, weekly, monthly, yearly, never)
  * **exclude** - yes/no wether you want the page/post included in the sitemap.

* Sitemaps.org is very clear that web crawlers use the data as *hints* rather than commands so keep that in mind. 