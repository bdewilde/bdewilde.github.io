---
layout: post
title: Version Control Is Important!
date: 2012-10-10 00:31:00
categories: [blog, blogger]
tags: [backup, branching, collaboration, Git, Kaggle, rewinding, SVN, version control]
comments: true
---

I recently came across a post on Kaggle's [no free hunch blog](http://blog.kaggle.com/), "[Engineering Practices in Data Science](http://blog.kaggle.com/2012/10/04/engineering-practices-in-data-science/)", in which Chris Clark describes a set of best practices for those who work in the medium of code — specifically, those practices common among software engineers but _not_ among data scientists. I was much chagrined by the first wag of his finger: many data scientists don't use [version control](http://en.wikipedia.org/wiki/Revision_control) (a logical way to manage multiple versions of the same information, e.g. source code), preferring instead to save files with elaborate names and/or back them up dropbox. _Ugh_, I realized, _he's talking about me_.

<figure>
  <img class="tqw" src="/assets/images/2012-10-10-dropbox-code-backup.png" alt="2012-10-10-dropbox-code-backup.png">
  <figcaption>Part of my <code>/code_backup</code> directory in Dropbox. This is bad.</figcaption>
</figure>

To be fair, I used version control with all of my physics analysis code and dissertation files, but I _stopped_ when I switched to writing personal analysis projects. Shameful! Although there are some costs to implementing a version control system (VCS) and integrating it into your workflow, the benefits far outweigh them:

- __Backup:__ Files and directories are quickly, easily, and efficiently backed up to an online repository. Exact duplicates can be distributed across multiple machines. Drive failures and accidents happen often enough, but it would take the act of a truly vengeful god to lose all copies of your version-controlled files.
- __Branching and Rewinding:__ The entire history of your files' many iterations is preserved. Restoring ("rewinding") a local copy to an older version is a piece of cake, in case you make a mistake or prefer an earlier version, as is merging changes from different iterations of the same file. You can also create separate "branches" in your history for experimentation; if you like the end result, merge your changes into the main branch, otherwise just switch back to what you had before.
- __Collaboration:__ For the reasons just given, VCS is essential for projects in which multiple people are working on the same files simultaneously. Updating your local copy is painless; you can see who changed which files, and when, and how; and everybody's work can be merged with relative ease. If you work alone (as I currently do), it's _still_ a good idea, because you'll likely have to work in a team sometime in the future — better to learn sooner rather than later, right?
    - __Plus:__ I've noticed that prospective employers often ask if you have an online repository of your work so they can take a look. _Yeah_, VCS can help you get a job...

Basically, version control gives you a permanent undo button to use in case of error, experiment, or _total disaster_. Do yourself a favor and take advantage of it. :)
<!--more-->

When I worked on [ATLAS](http://atlas.ch/), most people seemed to use [Apache Subversion](http://en.wikipedia.org/wiki/Apache_Subversion) (commonly known as SVN). That said, I get the impression that [Git](http://en.wikipedia.org/wiki/Git_(software)) is more popular among the tech crowd. They follow different models but implement the same basic principles. Happily, both are open source, so you don't have to pay! I'm not going to bother with a How-To, since the Internet has already provided us with many: for Git, see [this](http://www-cs-students.stanford.edu/~blynn/gitmagic/), [this](http://git-scm.com/book), or [this](http://coding.smashingmagazine.com/2011/07/26/modern-version-control-with-git-series/); for SVN, see [this](http://svnbook.red-bean.com/) or [this](http://subversion.apache.org/docs/community-guide/).

<figure>
  <img class="tqw" src="/assets/images/2012-10-10-github-mac-gui.png" alt="2012-10-10-github-mac-gui.png">
  <figcaption>Work, commit, sync. Repeat.</figcaption>
</figure>

As for _me_, I set up an account on [GitHub](https://github.com/) a couple days ago and have been using it problem-free with [my latest project](https://www.kaggle.com/c/digit-recognizer). So. Less tedious updates are on the way!
