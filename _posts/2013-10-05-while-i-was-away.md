---
layout: post
title: While I Was Away
date: 2013-10-05 11:01:00
categories: [blog, blogger]
tags: [data mining, hackathon, Harmony Institute, Natural Language Processing, network analysis, top data science links, treasury.io]
comments: true
---

I've not posted in almost six months, but I was, like, totally busy. Here's what I've been up to:

Way back in February, [I participated in a hackathon](http://harmony-institute.org/therippleeffect/2013/02/13/hi-data-analysts-make-music-at-bicoastal-datafest/) with a few data friends from [CSV Soundsystem](http://csvsoundsystem.com/); we made [a Federal Management Service symphony](http://fms.csvsoundsystem.com/), and it won Best in Show. Rather than let the project die at the end of the hackathon, we applied for —-- [and received!](http://dansinker.com/post/49856260511/opennews-code-sprints-do-some-spring-cleaning-on-data) —-- a Code Sprint grant from the Knight Foundation to build it out. I performed an epic, damn near endless feat of data munging, [and](https://twitter.com/Cezary) [the](https://twitter.com/mhkeller) [other](https://twitter.com/brianabelson) [guys](https://twitter.com/thomaslevine) did everything else. The end result was [treasury.io](http://treasury.io/) (and its companion tweetbot, [@TreasuryIO](https://twitter.com/TreasuryIO)). It provides the first-ever electronically-searchable database of the federal government's daily revenues, spending, and borrowing. It lets you do lots of cool things, like plot public debt against the debt ceiling over time:

<figure>
  <img class="tqw" src="/assets/images/2013-10-05-treasuryio-query-builder.png" alt="2013-10-05-treasuryio-query-builder.png">
</figure>

I've also been working hard at Harmony Institute on (among other things) a massive interactive web app that maps the landscape of films around social issues, positioning them along the issues' conversational zeitgeist, and allowing for deep examination and comparison of films' social impacts. It's called [ImpactSpace](http://harmony-institute.org/work/impactspace/)... until we decide on a name that wasn't recently claimed by [someone else](http://impactspace.org/) --— damn! I've done a great deal of data mining from dozens of sources via web crawls, web scrapes, API access, and structured data dumps; performed still more epic feats of data munging; dived into cutting-edge [NLP research](http://scholar.google.com/scholar?hl=en&q=automatic+text+summarization) and come out with fancy algorithms that I then implemented in Python; and even gotten my feet wet in social and semantic network analysis. Much work remains, but we're making good progress! :)

<figure>
  <img class="tqw" src="/assets/images/2013-10-05-impactspace-wireframe.png" alt="2013-10-05-impactspace-wireframe.png">
</figure>

I've tried to keep up with developments in data science... Some seriously cool code, projects, and papers have come out in the past few months. In case you missed them:

- [Personality, Gender, and Age in the Language of Social Media: The Open-Vocabulary Approach](http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0073791): In a nutshell, the words we use to express ourselves on social media are strongly indicative of our personality, age, and gender. Or, [as Gawker put it](http://gawker.com/science-shows-men-and-women-are-both-awful-stereotypes-1435455229), "science shows men and women are both awful stereotypes on Facebook."
- [prettyplotlib](http://olgabot.github.io/prettyplotlib/): A Python package built on top of the de-facto plotting standard [matplotlib](http://matplotlib.org/) that produces pretty plots by default, saving yourself a great deal of trouble. Inspired by Tufte!
- [TextBlob](https://textblob.readthedocs.org/en/latest/#): A Python package that simplifies [and improves](http://www.stevenloria.com/tutorial-state-of-the-art-part-of-speech-tagging-in-textblob/) a number of basic natural language processing tasks like part-of-speech tagging and noun phrase extraction. It builds upon the already-impressive [NLTK](http://nltk.org/) and [pattern](http://www.clips.ua.ac.be/pattern) packages.
- [bibviz](http://bibviz.com/): An interactive resource for exploring some of the more negative aspects of holy books, such as Bible contradictions, biblical inerrancy, and the Bible as a source of morality. Fun and fascinating.
- [Paperscape](http://paperscape.org/): An interactive tool to visualize [the arXiv](http://arxiv.org/), an open, online repository for scientific research papers, as a network of papers connected by citations.
- [NLP with Deep Learning](http://gigaom.com/2013/08/16/were-on-the-cusp-of-deep-learning-for-the-masses-you-can-thank-google-later): Google went ahead and applied [deep learning](http://en.wikipedia.org/wiki/Deep_learning) techniques to language analysis with pretty spectacular results —-- and they [open-sourced](https://code.google.com/p/word2vec/) it! [Python ports](http://radimrehurek.com/gensim/models/word2vec.html) [appeared quickly](http://nbviewer.ipython.org/urls/raw.github.com/dolaameng/tutorials/master/word2vec-abc/poc/pyword2vec_anatomy.ipynb).

Oh man, there's so much more... but you'll have to search through [my Twitter feed](https://twitter.com/bjdewilde). :)

Where else has the time gone? Well, I went to a handful of weddings, moved into an apartment in Chelsea, spent ten days in Scandinavia with my boyfriend, got 241 out of [242 power stars](http://youtu.be/uy2wzABWMIk) in Super Mario Galaxy 2, and resumed regular gym-going.

<figure>
  <img class="tqw" src="/assets/images/2013-10-05-burns-shulyak-wedding-group.jpg" alt="2013-10-05-burns-shulyak-wedding-group.jpg">
</figure>

Finally, my on-again, off-again data side-project, the creation and analysis of a Thomas L. Friedman corpus, will be the subject of my next few blog posts. And no, it won't be years until my next entry --— I'm no [George R.R. Martin](http://en.wikipedia.org/wiki/A_Song_of_Ice_and_Fire#Bridging_the_timeline_gap_.282000.E2.80.932011.29).
