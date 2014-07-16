---
layout: post
title: "How to Learn Data Science (2)"
date: 2012-10-03 16:56:00
categories: [blog, blogger]
tags: [books, data science, free data, Kaggle, practice, R, SciPy, tutorials]
---

Given the newness and breadth of the field, it can be tough to make sense of and get going in data science. This plus the [previous post]({% post_url 2012-10-01-how-to-learn-data-science-1 %}) is my attempt to organize and summarize the effective learning resources I've found thus far. So. After __MOOCs__ and __Blogs__, we get to more intense forms of self-learning...

### Books & Tutorials

Learning highly technical skills (e.g. programming languages, advanced statistics) directly from a book requires a lot of self-discipline and time, not to mention coffee. Books also tend to cost money, though you might be surprised by the amount of free, legal content available online. Personally, I prefer to use books in conjunction with courses as supplemental references; the instructor provides a stable framework for understanding, and the book helps to fill in the gaps. Here are a few that I've found useful:

- [The Visual Display of Quantitative Information](http://www.edwardtufte.com/tufte/books_vdqi) by Edward Tufte: Considered by many (myself included) to be a sacred text on the topic of data visualization. Tufte is an expert, and his advice — conveniently summarized at the end of each chapter — should be taken to heart! I used to read it before going to sleep, resulting in very elegant dream graphics.
- [Data Manipulation with R](http://books.google.com/books?id=grfuq1twFe4C&printsec=frontcover#v=onepage&q&f=false) by Phil Spector: A very handy (and freely available) reference for computing in R. Let's be honest, R is a somewhat funky language, so it's nice to have a formal source of information beyond [StackOverflow](http://stackoverflow.com/).
- [Introduction to Programming in Java](http://introcs.cs.princeton.edu/java/home/) by Robert Sedgewick and Kevin Wayne: Good summary of a book on Java and programming in general (full version available for purchase). Lots of questions and exercises are included, though some sections are very much works in progress. As a bonus, the same authors wrote a [book](http://algs4.cs.princeton.edu/home/) and teach an excellent [MOOC](https://www.coursera.org/course/algs4partI) on algorithms.
- [Data Science e-book](http://www.analyticbridge.com/group/data-science/forum/topics/data-science-e-book-first-draft-available-for-download) by Vincent Granville: A free (registration required) compendium of data science references, recipes, and discussions. I've only just started poking through this, but so far it seems like a useful, albeit ramshackle, reference.
- [Data Science Starter Kit](http://shop.oreilly.com/category/get/data-science-kit.do) via O'Reilly Media: If you're looking for a one-stop shop and have money to burn... I can't personally vouch for these books (free resources have sustained me so far), but I'd bet that they're high-quality.

If you're interested in learning very specific topics, dedicated tutorials might be a better bet. They provide step-by-step instructions on how to accomplish a task, saving you the trouble of making a slew of mistakes along the way. Some useful resources include:

- [SciPy Cookbook](http://www.scipy.org/Cookbook): Provides a list of "recipes" for doing interesting things in SciPy, which is a powerful extension to the basic Python programming language that allows for hardcore data analysis. If you already know Python, this is a nice way to get started before jumping into R.
- [Up and Running with Python](http://blog.kaggle.com/2012/07/02/up-and-running-with-python-my-first-kaggle-entry/) by Chris Clark: This tutorial describes how to use SciPy with a machine learning library called [Scikit-Learn](http://scikit-learn.org/stable/index.html) to perform a basic analysis on real data and submit it to [Kaggle](https://www.kaggle.com/) (more on this in the next section). Highly recommended!
- Tutorials at [Burns Statistics](http://www.burns-stat.com/): Click on the "tutorials" button for a smattering of useful tutorials. Definitely check out "[The R Inferno](http://www.burns-stat.com/pages/Tutor/R_inferno.pdf)" by a modern-day Dante.
- [R Tutorial Series](http://rtutorialseries.blogspot.com/) by John Quick: User-friendly guides to doing specific things in R. Use the "topics" sidebar to find what you're looking for.

Not surprisingly, this only scratches the surface of what's available online. As with most things that aren't privacy-related, Google is your friend.

### Practice

Last but certainly not least! One of the best ways to learn how to do data science is, well, to do it. "Experiential learning," as [they'd say](http://www.kzoo.edu/academics/?p=exed) at my alma mater. Once you have the basic tools and skills at your disposal, it's time to apply them to _actual_ projects — that is, get yourself some data and run with it!

- [R Datasets package](http://stat.ethz.ch/R-manual/R-patched/library/datasets/html/00Index.html): For this very reason, R comes with built-in datasets. They aren't particularly large or complicated, but they're a great way to get started. Since this package is loaded automatically every time you start R, simply type `data()` at the prompt to get a list of your options.
- [U.S. Census Bureau](http://www.census.gov/main/www/access.html): An amazing, comprehensive collection of American demographic data. I've had issues with the formatting of their data files, but data cleanup is a major part of any data scientist's job. Deal with it.
- [Data.gov](http://data.gov/): The Executive Branch of the U.S. Government accumulates a lot of data; happily, they've decided to share some of it with the public.
- [Public Data Sets](http://aws.amazon.com/datasets) via Amazon: I've not done much with this, but I know some people do.
- [Reddit](http://www.reddit.com/r/datasets): Believe it or not, you can find some very interesting datasets in the Internet's gutter.
- [Kaggle](https://www.kaggle.com/): Hands down, this is one of my favorite places on the Internet. Kaggle connects people looking to analyze data with people looking to have their data analyzed - _great idea, right?_ - by hosting data science competitions with reputation and monetary rewards for the winners. The datasets are large and interesting, and a couple of them are explicitly for beginners. Kaggle also has an [excellent blog](http://blog.kaggle.com/) that didn't get mentioned in the previous post. If you feel comfortable playing in the Big Leagues, this is a great place to do it.

Whew! That's a lot of resources. I hope you find them as useful and fun as I have. As always, if anybody out there has any suggestions or links for me, say so in the comments. I'm all ears!
