---
layout: page
title: About Gabriela
permalink: /about/
eyebrow: The artist
description: Singer, pianist, composer, and songwriter—sharing music that points toward hope.
---

{% assign bio = site.pages | where: "title", "About Me" | first %}
{{ bio.content }}

