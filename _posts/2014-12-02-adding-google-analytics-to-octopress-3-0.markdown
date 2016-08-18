---
layout: post
title: "Adding Google Analytics to Octopress 3.0"
date: 2014-12-02T19:38:10-08:00
---

### Create the analytics code
* Create a file called `google_analytics.html` in your `_includes` directory and paste the following code into it:

```
{% raw %}
    {% if site.google_universal_analytics %}
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

      ga('create', '{{ site.google_universal_analytics }}', '{{ site.google_universal_analytics_cookiedomain }}');
      ga('send', 'pageview');
    </script>
    {% endif %}
{% endraw %}
```
* Add the following code to your `_includes/head.html` file just before `</head>`:

```
{% raw %}
{% include google_analytics.html %}
{% endraw %}
```

* Add this code to your _config.yml

```
google_universal_analytics: YOUR-TRACKING-ID
google_universal_analytics_cookiedomain: auto
```
* Replace `YOUR-TRACKING-ID` with your actual tracking ID.