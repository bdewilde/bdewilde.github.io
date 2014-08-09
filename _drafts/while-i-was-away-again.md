---
layout: post
title: While I Was Away, Again
categories: [blog]
tags: [jekyll]
comments: true
---

After another lengthy hiatus from blogging, I'm back! Long story short, I got so frustrated with [Blogger](https://www.blogger.com)'s shortcomings and complications, not to mention the general lack of control over my content, that I lost the will to update my old blog. At the same time, I was putting in longer hours at [Harmony Institute](http://harmony-institute.org/) and volunteering on the side for [DataKind](http://www.datakind.org/), so I didn't have much to say outside of official channels. That said, my data life has not gone entirely un-blogged:

- [Measuring Shifts in National Discourse: A Case Study](http://harmony-institute.org/therippleeffect/2013/11/27/measuring-shifts-in-national-discourse-a-case-study/)
- [Building and Analyzing Issue-Focused Social Networks on Twitter](http://harmony-institute.org/therippleeffect/2014/05/22/building-and-analyzing-issue-focused-social-networks-on-twitter/)
- [Big Data, Big Impact](http://www.datakind.org/blog/big-data-big-impact/)
- [Highlights from Project Accelerator Night](http://www.datakind.org/blog/highlights-from-project-accelerator-night/)

Recently, life slowed down a bit, so I started exploring my options for building a custom blog / personal website. [Wordpress](http://wordpress.org/) is well-known, actively maintained, and extensively customizable, but it's slow, bloated, vulnerable to spamming and hacking. Pass. [SquareSpace](http://www.squarespace.com/) is a slick, drag-and-drop website builder with blogging functionality built-in, but it seems geared towards designer-types with image-rich content to present. Not me.

It didn't take long for [Jekyll](http://jekyllrb.com/) to emerge as my preferred option, for a number of reasons.

- __It's simple:__ Jekyll automagically converts a directory of specially marked-up text files into a [static website](http://nilclass.com/courses/what-is-a-static-website/#1). My content lives in files on my local machine rather than a remote database.
- __It's lightweight:__ Since the site is static and generated _before_ deployment to a server, it loads much faster and can handle far more traffic than a dynamic site. Plus, the relatively bare-bones HTML+CSS is easier to understand and customize.
- __It's coder-friendly:__ Jekyll was built by [the folks at GitHub](http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html) for use by readme-writing coders and tech-savvy bloggers --- people like me. Posts are written in [Markdown](http://daringfireball.net/projects/markdown/); lists, links, images, quotes, code blocks, and more are all seamlessly integrated into text. I can produce new content entirely from the comfort of my terminal and favorite text editor.
- __It's free:__ GitHub provides free hosting (!) for Jekyll blogs in the form of [GitHub Pages](https://pages.github.com/). My site is just a GitHub repository; version control is intrinsic.

I found a few "helpers" for building out Jekyll sites --- [Octopress](http://octopress.org/), [poole](https://github.com/poole/poole), [JekyllBootstrap](http://jekyllbootstrap.com/) --- that provide ready-made templates, themes, and plugins to get you going faster and easier, but I opted to build and customize everything myself because I'm a stubborn workaholic control freak. After reading through much of the documentation, I set up a default site on my computer and began filling it with content from my old blog. Jekyll has [a package for migrating](http://import.jekyllrb.com/docs/home/) from other blogging systems, but I transcribed my old posts into Markdown manually (see: stubborn, workaholic, control freak). In the process, I learned some new tricks in both Markdown and HTML+CSS, so it wasn't entirely pointless.





























