---
layout: page
title: navigation
permalink: "/documentation/navigation/"
---   
# Navigation
Navigation is set using Jekyll's [Data Files](https://jekyllrb.com/docs/datafiles/) feature.     
You can add the following link types to your navigation menu:
- [Internal Page](#adding-an-internal-page)
- [External Page](#adding-an-external-page)
- [Nested Internal Page](#adding-a-nested-internal-page)
- [Nested External Page](#adding-a-nested-external-page)

_A Note on :active_    
By default the active/current page is highlighted on the menu. In order for this function to work you must make sure that anytime you enter a `title` below that it exactly matches (spelling, case, punctuation, etc) the `title` that you enter for that specific page's yaml frontmatter.

## Create Your Navigation File
To set your navigation links:
- Create a new file called `_data/nav.yml`
  - create the directory `_data` if it doesn't exist.

---------
## Adding an Internal Page
You can add a link to an internal page (any page on your website) by adding the following code to your `_data/nav.yml` file:
```
- title: "TITLE"
  href: "/PAGE-NAME/"
```

**Example**
```
- title: "blog"
  external: "/blog/"
```

---------
## Adding an External Page
You can add a link to an external page (any page NOT on your website) by adding the following code to your `_data/nav.yml` file:
```
- title: "TITLE"
  external: "EXTERNAL-URL"
```

**Example**
```
- title: "Jekyll"
  external: "http://www.jekyllrb.com"
```

---------
## Adding a Nested Internal Page
You can add a nested menu (up to two level only) by adding the following code to your `_data/nav.yml` file:

```
- title: "TITLE"
  subcategories:
    - subtitle: "SUBTITLE"
      subhref: "PAGE"
    - subtitle: "SUBTITLE"
      subhref: "PAGE"
```

**Example**
```
- title: "documentation"
  subcategories:
    - subtitle: "layouts"
      subhref: "/documentation/layouts/"
    - subtitle: "navigation"
      subhref: "/documentation/navigation/"
```

---------
## Adding a Nested External Page
You can add a nested menu (up to two level only) by adding the following code to your `_data/nav.yml` file:
```
- title: "TITLE"
  external-subcategories:
    - subtitle: "SUBTITLE"
      subhref: "PAGE"
    - subtitle: "SUBTITLE"
      subhref: "PAGE"
```

**Example**
```
- title: "Misc"
  external-subcategories:
    - subtitle: "Jekyll forums"
      subhref: "https://talk.jekyllrb.com/"
    - subtitle: "Source Code"
      subhref: "https://github.com/chrisanthropic/starving-artist-jekyll-theme"
```
