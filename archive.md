---
layout: page
title: Archive
permalink: /archive/
---

{% for post in site.posts %}
  - {{ post.date | date: "%Y-%m-%d" }} &raquo; [ {{ post.title }} ]({{ post.url }})
{% endfor %}