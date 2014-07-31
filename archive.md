---
layout: page
title: Archive
permalink: /archive/
---

<ul style="list-style: none">
  {% for post in site.posts %}
    <li>{{ post.date | date: "%Y-%m-%d" }} &raquo; <a class="nav-link" href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>


