---
layout: page
title: Journal
eyebrow: Stories
description: Music, performances, reflections, and news from Gabriela’s archive.
---

## Pages

{% assign site_pages = site.pages | sort: "date" | reverse %}
{% for item in site_pages %}
- [{{ item.title }}]({{ item.url | relative_url }})
{% endfor %}

## Posts 

{% for post in site.posts %}
<p class="card-meta">{{ post.date | date: "%B %-d, %Y" }}</p>
<h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
<p>{{ post.excerpt | strip_html | truncatewords: 25 }}</p>
{% endfor %}


