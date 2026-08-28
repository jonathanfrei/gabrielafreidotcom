---
layout: page
title: Journal
permalink: /journal/
eyebrow: Stories
description: Music, performances, reflections, and news from Gabriela’s archive.
---

<div class="card-grid">
{% for post in site.posts %}<article class="card"><p class="card-meta">{{ post.date | date: "%B %-d, %Y" }}</p><h2><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h2><p>{{ post.excerpt | strip_html | truncatewords: 25 }}</p></article>{% endfor %}
</div>
