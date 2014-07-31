---
layout: post
title: Web Scraping and HTML Parsing (2)
date: 2012-11-26 11:12:00
categories: [blog, blogger]
tags: [BeautifulSoup, HTML parsing, Metacritic, Natural Language Processing, PyCon, Requests, web scraping, Wikipedia, X-Men]
comments: true
---

As I wrote [last time]({% post_url 2012-11-14-web-scraping-and-html-parsing-1 %}), the Internet is chock-full of data, but much of it is "messy" and unstructured and spread throughout an [HTML tree](http://vinaytech.files.wordpress.com/2008/11/domimage.png) — in other words, _not ready_ for analysis. Fortunately, web scraping and HTML parsing allow for the automated extraction of online data and its conversion into a more analysis-friendly form; unfortunately, it can be an awful lot of work. In fact, data scientists often spend more of their time getting and cleaning data than analyzing it!

Web scraping and HTML parsing are readily handled in [Python](http://www.python.org/) by freely-available packages such as [Requests](http://docs.python-requests.org/en/latest/) and [BeautifulSoup](http://www.crummy.com/software/BeautifulSoup/). For details, check out this long but very informative presentation from PyCon 2012:

<iframe width="420" height="315" src="//www.youtube.com/embed/52wxGESwQSA" frameborder="0" allowfullscreen></iframe>

Now, here are a couple examples of my own. :)

### X-Men Abilities from Wikipedia

Let's say you want a list of abilities for all of Marvel's [X-Men](http://marvel.com/universe/X-Men). Rather than reading through the comics and watching the shows/movies --— an entertaining but _inefficient_ way to find this information —-- you instead head to Wikipedia for a consistent, reliable summary. Soon, however, you find yourself searching, scrolling, copy-pasting, and text-formatting the results for each character. It's repetitive, painstaking, and still too inefficient for your tastes. Say it with me: UGH. Happily, a short script can do this for us!

We can get a list of member names and URLs from the side panel on the X-Men's [main Wikipedia page](http://en.wikipedia.org/wiki/X-Men). Right-click and select "Inspect Element" to see where this information resides in the page's HTML tree. (This works in Chrome and Safari, and Firefox with Firebug has similar functionality.)

<figure>
  <img class="tqw" src="/assets/images/2012-11-26-xmen-wikipedia-scrape.png" alt="2012-11-26-xmen-wikipedia-scrape.png">
</figure>

We can easily get this information with a short Python script:

{% highlight python %}
import requests
import bs4
 
# search Wikipedia for a subject or provide its URL, return the parsed HTML
# spoof the user-agent, let's pretend we're Firefox :)
def wikipedia_search(subject, url=False):
    if url is False :
        response = requests.get('http://en.wikipedia.org/w/index.php',
                                params={'search':subject},
                                headers={'User-agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.11 (KHTML, like Gecko)'})
    else :
        response = requests.get(url,
                                headers={'User-agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.11 (KHTML, like Gecko)'})
    soup = bs4.BeautifulSoup(response.text)
    return soup
 
# search Wikipedia for the X-Men
# find list of members in side panel, return dictionary of names and URLs
def get_xmen():
    soup = wikipedia_search('X-men')
    infobox = soup.find('table', class_='infobox')
    members = infobox.find('th', text='Member(s)')
    members = members.next_sibling.next_sibling
    xmen = {}
    for member in members.find_all('a') :
        xmen[member.get_text()] = 'http://en.wikipedia.org'+member.get('href')
    return xmen
{% endhighlight %}

Now, we can loop through the sequence of X-Men members and, in the same way, scrape the list of their abilities from the side panel on their Wikipedia pages. For example, here's [Magneto](http://en.wikipedia.org/wiki/Magneto_(comics)):

<figure>
  <img class="tqw" src="/assets/images/2012-11-26-magneto-wikipedia-page.png" alt="2012-11-26-magneto-wikipedia-page.png">
</figure>

Although the text formatting of the abilities list varies somewhat between pages, at least it's always found in the same _place_. So, let's add another method to our script that takes a parsed HTML Wikipedia page and returns a list of abilities, and put it all together in a `main()` method, like so:

{% highlight python %}
# take parsed HTML for X-man's Wikipedia page
# return list of abilities
def get_xmen_abilities(soup):
    infobox = soup.find('table', class_='infobox')
    if infobox is not None :
        abilities = infobox.find('th', text='Abilities')
        if abilities is not None :
            abilities_list = abilities.next_sibling.next_sibling.find_all(text=True)
            abilities_list = [item.strip("\n") for item in abilities_list if item!='' and item!='\n']
            return abilities_list
    else : return []
 
if __name__ == '__main__':
    xmen = get_xmen()
    xmen_abilities = {}
    for xman in xmen :
        html = wikipedia_search(xman, xmen[xman])
        abilities = get_xmen_abilities(html)
        xmen_abilities[xman] = abilities
        print "\n", xman, "\n", xmen_abilities[xman]
{% endhighlight %}

Let's save this script as scrape_xmen.py. Now, when the script is called from the command line as `$ python scrape_xmen.py`, we see a nice printout in the terminal window of everything we wanted to know:

<span style="font-family:courier">Magneto</span>

<span style="font-family:courier">[u'Magnetism manipulation', u'Magnetic force fields', u'Magnetic flight', u'Genius-level intellect', u'Skilled leader and strategist']</span>

That information can just as easily be saved into a file for reference, should you have further plans for it. Going through all the results, you may notice that the lists of abilities aren't always "perfect": Sometimes individual abilities are split into multiple entries in the list on account of the HTML formatting, sometimes abilities varied over the character's lifetime so there are actually two lists per character, etc. As a result, some degree of manual intervention is required to really clean up the data. So it goes.

Side-note: These Wikipedia pages contain _much_ more information than just a list of abilities, including origin stories, publication history, arch-nemeses, and so on. Might there be some way to read the full text of the page and extract specific information? (The answer is a resounding YES! In an upcoming post I'll get into how this is done —-- namely, [Natural Language Processing](http://en.wikipedia.org/wiki/Natural_language_processing).)
<!--more-->

### Metascores from Metacritic

Let's say you want to collect the [Metascores](http://www.metacritic.com/about-metascores) and defining characteristics of a large sample of movies, shows, games, or albums on Metacritic in order to perform a statistical analysis correlating the latter with the former. Of course, the dataset is split up across thousands of web pages and HTML tags, but we need it in a structured, local format. Doing this by hand would be totally impractical; doing this by code is a bit of work, but _doable_.

We start by looking at the [Advanced Search](http://www.metacritic.com/advanced-search) interface, which shows us our options: We can search for particular keywords or by kind of media along with genre, dates, and score ranges. Considering our goal of scraping a large sample --— and that individual searches return a maximum of 1000 results —-- it makes sense to search by kind of media and genre. When you choose your options and press Search, the resulting URL has a particular format: http://www.metacritic.com/search/[kind of media]/results?genre=[genre]&sort=[sort]&page=[page]&search_type=advanced, where [genre] is something like "action" or "horror"; [sort] is either "relevancy," "score", or "recent," giving the order in which results are returned; and [page] is just the page number of the results, from 0 to 49. As a test case, let's search for horror movies and sort by relevancy, then do "Inspect Elements" as before:

<figure>
  <img class="halfw" src="/assets/images/2012-11-26-metacritic-search.png" alt="2012-11-26-metacritic-search.png">
</figure>

Not surprisingly, the search results are in a nice HTML list format, with _mostly_ standardized formatting for the Metascore, title, URL, summary description, etc. So parsing the HTML should be relatively straightforward, albeit more complicated than the X-Men example. First things first, we ought to get the Metascore belonging to each movie! But what if you want more information than that given in the list of search results? Well, just extract the URL for each movie in the list and then request its individual page, grabbing whatever additional information is there. On the page for our first search result, Prometheus, we can extract the title, release date, distribution of critics' and users' scores, a longer summary description, director, cast, rating, runtime, ...

<figure>
  <img class="halfw" src="/assets/images/2012-11-26-metacritic-prometheus.png" alt="2012-11-26-metacritic-prometheus.png">
</figure>

It's hard to say what if any of this will correlate with the Metascore, so we might as well grab it all! :D Once we write up code to extract this information for _one_ movie, we can then just loop over the full list of horror movies, then all movies in the remaining genres, then all games, shows, and albums, and save all this data in a convenient format. I prefer [CSV](http://en.wikipedia.org/wiki/Comma-separated_values). I should note that many items show up in multiple searches: for example, a movie may be both a "horror" and a "comedy", like, say, [Shaun of the Dead](http://www.metacritic.com/movie/shaun-of-the-dead). So, we should be sure to check for duplicates in the results before saving.

Since this task required quite a bit of code, I won't go into the details. If you're curious to see what I came up with, check it out [on my GitHub account](https://github.com/bdewilde/metascore/blob/master/metacritic_scaper.py), but otherwise realize that it's just an extension of what we did for the X-Men abilities. As a teaser, here's a quick look at the data:

<figure>
  <img class="tqw" src="/assets/images/2012-11-26-metascore-distribution.png" alt="2012-11-26-metascore-distribution.png">
</figure>

Hm, I wonder why the vast majority of music albums fall in a narrow range around a thoroughly mediocre Metascore of 71... I suppose I would have to do an analysis! And thanks to web scraping and HTML parsing, this is now actually possible.
