---
layout: page
title: Archive
permalink: /archive/
---

{% assign years = "2014,2013,2012" | split: "," %}
{% for year in years %}
  <h3 style="border-bottom: 1px solid #e0e0e0">{{ year }}</h3>
  <ul style="margin-left: 0px; padding-left: 0px; list-style: none">
    {% for post in site.posts %}
      {% assign post_year = post.date | date: "%Y" %}
      {% if post_year == year %}
        <li style="padding-bottom:10px">
          <span class="post-meta">{{ post.date | date: "%d %b" }}</span>
          <a class="post-link post-title" href="{{ post.url }}">{{ post.title }}</a>
        </li>
      {% endif %}
    {% endfor %}
  </ul>
{% endfor %}

