---
layout: page
title: Events
eyebrow: Gather
description: Concerts, community events, and opportunities to worship together.
---

{% assign today = site.time | date: "%Y-%m-%d" %}
{% assign sorted_events = site.events | sort: "event_date" %}
<h2>Upcoming</h2>
<div class="event-list">
{% assign upcoming_count = 0 %}
{% for event in sorted_events %}{% assign event_day = event.event_date | date: "%Y-%m-%d" %}{% if event_day >= today %}{% assign upcoming_count = upcoming_count | plus: 1 %}
<article class="event-row"><time class="event-date" datetime="{{ event.event_date | date_to_xmlschema }}">{{ event.event_date | date: "%b" }}<strong>{{ event.event_date | date: "%-d" }}</strong></time><div><h3><a href="{{ event.url | relative_url }}">{{ event.title }}</a></h3><p>{{ event.venue }} · {{ event.location }}</p></div>{% if event.sold_out %}<span class="button button-secondary">Sold out</span>{% elsif event.ticket_url %}<a class="button" href="{{ event.ticket_url }}">{% if event.free_entry %}Details{% else %}Tickets{% endif %}</a>{% endif %}</article>
{% endif %}{% endfor %}
{% if upcoming_count == 0 %}<p>No upcoming dates have been announced. Please check back soon.</p>{% endif %}
</div>

<h2>Past events</h2>
<div class="event-list">
{% for event in sorted_events reversed %}{% assign event_day = event.event_date | date: "%Y-%m-%d" %}{% if event_day < today %}<article class="event-row"><time class="event-date" datetime="{{ event.event_date | date_to_xmlschema }}">{{ event.event_date | date: "%b" }}<strong>{{ event.event_date | date: "%-d" }}</strong></time><div><h3><a href="{{ event.url | relative_url }}">{{ event.title }}</a></h3><p>{{ event.venue }} · {{ event.location }}</p></div></article>{% endif %}{% endfor %}
</div>
