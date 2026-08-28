---
layout: page
title: Music
eyebrow: Listen
description: Songs shaped by faith, love, and the quiet work of grace.
---

My Music will live here

<div class="card-grid">
{% assign releases = site.discography | sort: "release_year" | reverse %}
{% for release in releases %}
<article class="card">
  {% if release.cover_image %}<img class="card-image" src="{{ release.cover_image }}" alt="{{ release.title }} cover artwork" width="480" height="360" loading="lazy">{% endif %}
  <p class="card-meta">{{ release.release_year }}</p>
  <h2><a href="{{ release.url | relative_url }}">{{ release.title }}</a></h2>
  <p>{{ release.description }}</p>
</article>
{% endfor %}
</div>
