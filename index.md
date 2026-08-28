---
layout: home
title: Home
---

## Pages

{% assign site_pages = site.pages | sort: "date" | reverse %}
{% for item in site_pages %}
- [{{ item.title }}]({{ item.url | relative_url }})
{% endfor %}

