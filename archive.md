---
layout: page
title: Archive
permalink: /archive/
---

{% for post in site.posts %}
  - {{ post.date | date: "%Y-%m-%d" }} &raquo; <a class="nav-link" href="{{ post.url }}">{{ post.title }}</a>
{% endfor %}