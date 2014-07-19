---
layout: post
title: Web Scraping and HTML Parsing (1)
date: 2012-11-14 13:18:00
categories: [blog, blogger]
tags: [BeautifulSoup, HTML parsing, HTTP, Python, Scrapy, web scraping]
---

Hi! I haven't posted in a while: I got displaced by [Sandy](http://www.nytimes.com/interactive/2012/10/28/nyregion/hurricane-sandy.html), distracted by [job applications](http://harmony-institute.org/about-us/career-opportunities/), and overrun by [zombies](http://youtu.be/luNueXoAw3I). It happens. But back to business...

One of the biggest tasks facing data scientists — and one that distinguishes them from traditional business analysts — is _fetching_ and _cleaning_ data. Once upon a time (or so I'm told), data was kept in orderly, consolidated databases, there wasn't so much that size was an issue, and analysts could access it in a relatively straightforward manner through, say, a structured query language ([SQL](http://en.wikipedia.org/wiki/SQL)). Then [the Internet happened](http://public.web.cern.ch/public/en/about/web-en.html), and data got Big and messy, and the process of getting it for analysis turned into a chore. Unfortunately, _point-and-click_ doesn't scale.

So what's a data-starved data scientist to do?!? Well, one way to fetch data is through _web scraping_. (I rely on Wikipedia links for details far too much, but it's just so easy: [web scraping](http://en.wikipedia.org/wiki/Web_scraping).) Basically, it is the automated extraction of data from resources served over HTTP and encoded in HTML or JavaScript. It's related to the web _indexing_ that search engines like Google continuously perform in order to keep track of all the content on the web and help people find the information they're searching for, but the focus of web scraping is usually to retrieve unstructured, online data and transform it into a more structured, _local_ form. For this to work, you'll probably have to parse the HTML and separate the information you want from all the markup (it is, after all, a HyperText Markup Language) that goes into making a web page look as it does in a browser.

Let's consider a simple case: You want to know [tomorrow's local weather forecast](http://www.weather.com/weather/tomorrow/USNY0996), but you don't feel like going to the website, typing in the search bar, and dealing with all the advertisements. So, you write a little program that sends an HTTP request to [weather.com](http://www.weather.com/)'s server, which responds with (among other things) the HTML content you asked for, then you parse that HTML to find the string of characters embedded in a deep hierarchy of tags corresponding to the temperature: 48.

<figure>
  <img class="tqw" src="/assets/images/2012-11-14-weather-dot-com-example.png" alt="2012-11-14-weather-dot-com-example.png">
</figure>

This example is kind of ridiculous, I know --— _just bookmark the damn site!_ --— but vastly more complicated web scraping tasks can be built up from this basic procedure: request HTML, parse HTML, extract data (repeat). Maybe you'd like to compile a [list of abilities](http://en.wikipedia.org/wiki/Superman#Powers_and_abilities) of all superheroes on Wikipedia, or get U.S. election results by district from [this guy](http://uselectionatlas.org/) without paying lots of money for his already-structured and -cleaned Excel spreadsheets, or get the [Metacritic scores](http://www.metacritic.com/search/movie/results?genres%5Bhorror%5D=1&date_range_from=11-14-2002&search_type=advanced&sort=score) of all horror films in the past ten years. Sure, given enough time and patience, you could probably do this manually, but it's much _much_ easier to automate through code.

Although you can do limited web scraping tasks directly from a command line (with the `curl`, `grep`, and `awk` commands, among others), it's nicer to work in a full-fledged scripting language. Python, for example, is great for web scraping and HTML parsing! Happily, people have written libraries and even entire frameworks specifically for these purposes:

- [Scrapy](http://scrapy.org/): Free web scraping and crawling framework. You pick a website, specify the kind of data you want to extract and the rules to follow in finding/extracting it, then let Scrapy do its thing. It has built-in support for reading and cleaning the scraped data, and much more.
- [Requests](http://docs.python-requests.org/en/latest/): Free and user-friendly HTTP library. Easily add options to your web query, read and properly encode the web server's response, deal with authentication, etc.
- [BeautifulSoup](http://www.crummy.com/software/BeautifulSoup/): Free HTML parsing library. Provides methods for navigating, searching, and modifying the parse tree, which saves you _a lot_ of time.
- [Mechanize](http://wwwsearch.sourceforge.net/mechanize/): Free library to emulate a web browser in your script. This includes basic functionality like downloads, cookies, form-filling, and history.

This isn't an exhaustive list, by any means. I've mostly used Requests and BeautifulSoup so far, though I'd like to add Mechanize to the mix. I tried Scrapy but didn't care for it; maybe I needed to give it more time, since it seems to be the most full-featured (and complicated) of the bunch. I should also add that nice web browsers let you inspect the HTML of a web page in the browser itself. This can be very handy when you're trying to figure out what, exactly, to automate in your code. The weather example above shows an example of the [developer tools](https://developers.google.com/chrome-developer-tools/docs/overview) bundled in Chrome; if you prefer Firefox, get the Firebug add-on; if you're using [Internet Explorer](https://addons.mozilla.org/en-us/firefox/addon/firebug/), there's probably no hope for you. Just... _stop_.

One last thing: Obviously, web scraping is a powerful tool and can be abused. Definitely don't spam comments on news articles, or [collect information on people](http://online.wsj.com/article/SB10001424052748703358504575544381288117888.html) that should probably not be collected, or overload web servers. In fact, web scraping is against the official Terms of Use for many sites, some of which have countermeasures in place to prevent their use. Do be careful, and DON'T BE EVIL!
