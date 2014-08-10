---
layout: post
title: On Starting Over with Jekyll
date: 2014-08-10 11:45:00
categories: [blog]
tags: [blogging, DataKind, Disqus, Harmony Institute, Jekyll, website design]
comments: true
preview_pic: /assets/images/2014-08-10-site-footer.png
---

After another lengthy hiatus from blogging, I'm back! Long story short, I got so frustrated with [Blogger](https://www.blogger.com)'s shortcomings and complications, not to mention the general lack of control over my content, that I lost the will to update my old blog. At the same time, I was putting in longer hours at [Harmony Institute](http://harmony-institute.org/) and volunteering on the side for [DataKind](http://www.datakind.org/), so I didn't have much to say outside of official channels. That said, my data life has not gone entirely un-blogged:

- [Measuring Shifts in National Discourse: A Case Study](http://harmony-institute.org/therippleeffect/2013/11/27/measuring-shifts-in-national-discourse-a-case-study/)
- [Building and Analyzing Issue-Focused Social Networks on Twitter](http://harmony-institute.org/therippleeffect/2014/05/22/building-and-analyzing-issue-focused-social-networks-on-twitter/)
- [Big Data, Big Impact](http://www.datakind.org/blog/big-data-big-impact/)
- [Highlights from Project Accelerator Night](http://www.datakind.org/blog/highlights-from-project-accelerator-night/)

### Why Jekyll?

Recently, life slowed down a bit, so I started exploring my options for building a custom blog / personal website. [Wordpress](http://wordpress.org/) is well-known, actively maintained, and extensively customizable, but it's slow, bloated, vulnerable to spamming and hacking. Pass. [SquareSpace](http://www.squarespace.com/) is a slick, drag-and-drop website builder with blogging functionality built-in, but it seems geared towards designer-types with image-rich content to present. Not me. On the other end of the spectrum, there's always the start-from-scratch approach, but I'm no web developer, and I'd rather spend my time blogging than _building_ the blogging infrastructure.

It didn't take long for [Jekyll](http://jekyllrb.com/) to emerge as my preferred option, for a number of reasons:

- __It's simple:__ Jekyll automagically converts a directory of specially marked-up text files into a [static website](http://nilclass.com/courses/what-is-a-static-website/#1). My content lives in files on my local machine rather than a remote database.
- __It's lightweight:__ Since the site is static and generated _before_ deployment to a server, it loads much faster and can handle far more traffic than a dynamic site. Plus, the relatively bare-bones HTML+CSS is easier to understand and customize.
- __It's coder-friendly:__ Jekyll was built by [the folks at GitHub](http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html) for use by readme-writing coders and tech-savvy bloggers --- people like me. Posts are written in [Markdown](http://daringfireball.net/projects/markdown/); lists, links, images, quotes, code blocks, and more are all seamlessly integrated into text. I can produce new content entirely from the comfort of my terminal and favorite text editor.
- __It's free:__ GitHub provides free hosting (!) for Jekyll blogs in the form of [GitHub Pages](https://pages.github.com/). My site is just a GitHub repository; version control is intrinsic.

So, I went for it, and before long, I had myself this lovely new website.

### Getting Started

I found a few "helpers" for building out Jekyll sites --- [Octopress](http://octopress.org/), [poole](https://github.com/poole/poole), [JekyllBootstrap](http://jekyllbootstrap.com/) --- that provide ready-made templates, themes, and plugins to get you going faster and easier, but I opted to build and customize everything myself because I'm a stubborn workaholic control freak. After reading through much of the documentation, I set up a default site on my computer with the following directory structure:

{% highlight bash %}
$ ls -1
_config.yml
_includes
_layouts
_posts
about.md
css
feed.xml
index.html
{% endhighlight %}

When you run Jekyll, it parses markdown files; adds tags, categories, and other properties specified in [YAML](http://yaml.org/); and builds pages from layout templates and [Liquid](http://docs.shopify.com/themes/liquid-documentation/basics) code, all of which goes into a `_site` folder. `_config.yml` contains site-wide [configuration settings](http://jekyllrb.com/docs/configuration/) used when Jekyll builds the static HTML. As is convention, `index.html` is the home page of the site, while `about.md` is a Markdown file that builds into a new "about" page on the site. The `_layouts` directory contains boilerplate HTML templates into which content will be inserted, while `_includes` contains small snippets of HTML, such as that for headers and footers. Blog posts go in the `_posts` folder as individual .md files.

Site content comes in the form of additional pages and blog posts. I threw together a quick bio for the [About Me](/about-me/) page then began filling my site with content from my old blog. Jekyll has [a package for migrating](http://import.jekyllrb.com/docs/home/) from other blogging systems, but I transcribed all of my old posts into Markdown manually (see: stubborn, workaholic, control freak). In the process, I learned some new tricks in both Markdown and HTML+CSS, so it wasn't entirely pointless...

### Customization

The default home page layout featured a simple list of all posts in the blog formatted as [date, blog title]. Super boring. After a lot of tinkering, I settled on a more detailed preview of each post, including the title, publication date, post tags, an optional image thumbnail, and a text excerpt which defaults to the first paragraph in the post. I also split the full list of posts into chunks spread over multiple pages via Jekyll's [pagination](http://jekyllrb.com/docs/pagination/) functionality. The code looks something like this:

{% highlight html %}
{% raw %}
<div class="previews">
  {% for post in paginator.posts %}
  <div class="preview">
    <h1><a href="{{ post.url }}">{{ post.title }}</a></h1>
    <div class="post-meta">
      <div class="post-date">{{ post.date | date: '%Y-%m-%d' }}</div>
      <div class="post-tags">
        {% for tag in post.tags %}
          <span>{{tag}}</span>
        {% endfor %}
      </div>
    </div>
    {{ post.excerpt }}
    <a href="{{ post.url }}">Read More &raquo;</a>
    {% if post.preview_pic %}
      <div class="preview-pic">
        <a href="{{ post.url }}"><img src="{{ post.preview_pic }}"></a>
      </div>
    {% endif %}
  </div>
  {% endfor %}
</div>
{% endraw %}
{% endhighlight %}

Lines with special syntax such as {% raw %}`{% for tag in post.tags %}`{% endraw %} come from the Liquid template language, which lets you use programming logic and access site/page/post data to dynamically generate the static site structure with Jekyll. Liquid can be frustrating to use and is pretty limited, but I suppose it's better than nothing.

I also added an [Archive](/archive/) page that reproduced the default index page's full list of blog posts, but included code to emphasize the passage of time by grouping posts by year of publication:

{% highlight html %}
{% raw %}
{% assign years = "2014,2013,2012" | split: "," %}
{% for year in years %}
  <h3>{{ year }}</h3>
  <ul>
    {% for post in site.posts %}
      {% assign post_year = post.date | date: "%Y" %}
      {% if post_year == year %}
        <li>
          <span class="post-meta">{{ post.date | date: "%d %b" }}</span>
          <a href="{{ post.url }}">{{ post.title }}</a>
        </li>
      {% endif %}
    {% endfor %}
  </ul>
{% endfor %}
{% endraw %}
{% endhighlight %}

I knew that I wanted to enable commenting on my blog posts, and the standard option seemed to be [Disqus](https://disqus.com/). Fortunately, they make the setup process very simple, going so far as to provide the complete script needed to add comments to each post. I put this `comments.html` script in my `_includes` folder, then added it to the bottom of the `_layouts/post.html` template:

{% highlight html %}
{% raw %}
{% if page.comments %}
  {% include comments.html %}
{% endif %}
{% endraw %}
{% endhighlight %}

With this, I can turn comments on/off for each individual blog post with a simple configuration flag at the top of the post file.

Lastly, I added [Google Analytics](http://www.google.com/analytics/) to my site --- it seemed like a good idea to track readership data on my data blog. Almost exactly as with Disqus, I registered my site, saved an automatically generated `google_analytics.html` script in the `_includes` folder, then modified the `_layouts/default.html` template with {% raw %}`{% include google_analytics.html %}`{% endraw %}. Piece of cake.

### Design

I could go on and on about how I came to the current design of this site (there were literally dozens of iterations...), but instead I'll focus on a couple overall aspects.

- __Color:__ In general, I prefer <span style="color: #303030">(almost-)black</span>-on-white content, with shades of gray to demarcate special or distinct <span style="background-color:#f0f0f0; border: 1px solid #e0e0e0; padding: 2px">regions</span> or <span style="color: #818181">elements</span>; color is used sparingly, for emphasis. Standard links are a <span style="color: #4292c6">cornflower blue</span>, while special links --- <span class="site-link" style="font-size: 16px">blog titles linking to the full blog content</span>, <span class="site-link" style="font-size: 16px">header links to pages</span>, <span class="site-link" style="font-size: 16px">footer links to my social media accounts</span> --- go from black to <span style="color: #807dba">orchid</span> upon mouseover. The coloring of code blocks was customized to include these two colors, plus a striking <span style="color: #00ab56">green</span> for numbers and <span style="color: #fb6a4a">orange</span> for strings.
- __Typography:__ I went with a sans-serif font-family (Helvetica/Arial) throughout because it feels cleaner and more modern to me, and kept the baseline font size somewhat large for readability. I reduced <span style="font-size: 20px; letter-spacing: -1px">the letter spacing of headlines</span> slightly, to add density and visual weight without relying on __bold font__, which I save for list item pseudo-headers. As is standard, `code blocks` and the like use a monospace font. Lastly, I gave my name / site title <span style="font-family: serifa">Burton DeWilde</span> a special font (Serifa) that has a technical but still classic vibe.
- __Iconography:__ I used the [Font Awesome](http://fortawesome.github.io/Font-Awesome/) toolkit to incorporate customizable vector icons into my site where clarity and/or brevity is needed. In the site footer, I list links out to my web presence in the form of icons rather than words: email as <i class="fa fa-envelope-square"></i>, Twitter as <i class="fa fa-twitter-square"></i>, and so on. I also supplemented the metadata shown below post titles with icons: <i class="fa fa-calendar-o"></i> for publication date and <i class="fa fa-tags"></i> for tags, in case the content's meaning wasn't self-evident.

And that's how I made this new site! I hope you like it, and I sincerely hope the joy of blogging with Jekyll will keep me coming back with updates.

























