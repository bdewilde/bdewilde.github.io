---
layout: page
title: Archive
permalink: /archive/
---

<!-- - {{ post.date | date: "%Y-%m-%d" }} &raquo; [ {{ post.title }} ]({{ post.url }}) -->

{% for post in site.posts %}
  - {{ post.date | date: "%Y-%m-%d" }} &raquo; <a class="nav-link" href="{{ post.url }}">{{ post.title }}</a>
{% endfor %}