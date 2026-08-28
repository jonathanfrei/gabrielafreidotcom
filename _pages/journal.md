---
title: Journal
---

## Pages

{% assign site_pages = site.pages | sort: "date" | reverse %}
{% for item in site_pages %}
- [{{ item.title }}]({{ item.url | relative_url }})
{% endfor %}

<div class="card-grid">
{% for post in site.posts %}<article class="card"><p class="card-meta">{{ post.date | date: "%B %-d, %Y" }}</p><h2><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h2><p>{{ post.excerpt | strip_html | truncatewords: 25 }}</p></article>{% endfor %}
</div>