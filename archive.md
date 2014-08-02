---
layout: page
title: Archive
permalink: /archive/
---

<ul style="list-style: none">
  {% for post in site.posts %}
    <li style="padding-bottom:10px">
      <span style="vertical-align=bottom color=#818181 margin-right=5px">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a class="nav-link post-title" style="font-size:26px" href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>


