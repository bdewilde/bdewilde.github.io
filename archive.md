---
layout: page
title: Archive
permalink: /archive/
---

<ul style="margin-left: 0px; padding-left: 0px; list-style: none">
  {% for post in site.posts %}
    <li style="padding-bottom:10px">
      <span class="post-meta">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a class="post-link post-title" href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>


