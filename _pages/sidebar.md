---
layout: page
title: sidebar
permalink: "/documentation/sidebar/"
--- 
# Sidebar
The "recent posts" aside is included in this theme. You can add it to any page (or post) by adding the following code to its yaml frontmatter:
```
sidebar: "recent_posts"
```

## Custom Asides
You can create as many sidebars as you like and save them as `_includes/asides/YOUR-ASIDE.html`.    
Then you can add a custom sidebar by any page simply by adding it to the yaml frontmatter.

**Example**
I'm going to copy the "recent posts" sidebar but limit it to the single most recent post and I'll save it as `_includes/asides/newest_post.html`

Now I'll add it to any page by adding the following code to that page's yaml frontmatter:
```
sidebar: "tweets"
```
