---
layout: post
title: "Using _data to Build Jekyll Navigation"
date: 2014-12-09T19:34:33-08:00
sitemap:
  lastmod: 2014-12-09T19:34:33-08:00
  priority: 0.5
  changefreq: monthly
  exclude: 'no'
---

I wanted an easy way to create my navigation menus and I found a great post [here](http://www.tournemille.com/blog/How-to-create-data-driven-navigation-in-Jekyll/) on using the new-ish 'data' feature of Jekyll.

What this allows us to do is centralize our navigation setup (pages and subpages) so any changes are kept out of our actual layout code.

Here's what I did:

* Add a new file called `nav.yml` in your _data directory
  * Create the _data directory if it doesn't already exist
* Paste this template into `_data/nav.yml` and edit it to fit your needs

```
- title: "Home"
  href: "/"

- title: "Blog"
  href: "/blog/"

- title: "Misc"
  subcategories:
    - subtitle: "Example"
      subhref: "#"
    - subtitle: "Example2"
      subhref: "#"
```

* Edit your `_includes/naviation.html` to match the following

```
{% raw %}
<nav class="animenu">	
  <input type="checkbox" id="button">
  <label for="button" onclick>Menu</label> 
  <ul>
    {% for nav in site.data.nav %}
      {% if nav.subcategories != null %}
	<li>
	  <a href="{{ site.url }}{{ nav.url }}">{{ nav.title }} &#x25BC;</a>
	  <ul>
	    {% for subcategory in nav.subcategories %}
	      <li><a href="{{ site.url }}{{ subcategory.subhref }}">{{ subcategory.subtitle }}</a></li>
	    {% endfor %}
	  </ul>
	{% elsif nav.title == page.title %}
	  <li class="active"><a href="{{ nav.url }}">{{ nav.title }}</a></li>
	{% else %} 
	<li>
	  <a href="{{ site.url }}{{ nav.href }}">{{ nav.title }}</a></li>
      {% endif %}
    {% endfor %}
  </ul>
</nav> 
{% endraw %}
```

Now any time you want to update your navigation just edit the `_data/nav.yml` file and rebuild your site.
