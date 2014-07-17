---
layout: post
title: Friedman Corpus (1) — Background and Creation
date: 2013-10-15 08:33:00
categories: [blog, blogger]
tags: [APIs, corpus linguistics, Natural Language Processing, New York Times, NLTK, Thomas Friedman, web scraping]
---

Much work in Natural Language Processing (NLP) begins with a large collection of text documents, called a _corpus_, that represents a written sample of language in a particular domain of study. Corpora come in a variety of flavors: mono- or multi-lingual; category-specific or a representative sampling from a variety of categories, e.g. genres, authors, time periods; simply “plain” text or annotated with additional linguistic information, e.g. part-of-speech tags, full parse trees; and so on. They allow for hypothesis testing and statistical analysis of natural language, but one must be very cautious about applying results derived from a given corpus to other domains.

Many notable corpora have been created over the years, including the following:

- [Brown corpus](http://en.wikipedia.org/wiki/Brown_Corpus): the first 1-million-word electronic corpus of English, consisting of 500 texts spread across 15 genres in proportion to their amount published in America, ca. 1961
- [Gutenberg corpus](http://www.gutenberg.org/): the first and largest single collection of electronic books (approximately 50k), spanning [a wide range](http://www.gutenberg.org/wiki/Category:Bookshelf) of genres and authors
- [British National Corpus (BNC)](http://www.natcorp.ox.ac.uk/): a 100M-word, general-purpose corpus of written and spoken British English representing late 20th-century usage
- [Corpus of Contemporary American English (COCA)](http://corpus.byu.edu/coca/): the largest (and freely-searchable!) corpus of American English currently available, containing 450M words published since 1990 in fiction, newspapers, magazines, academic journals, and spoken word
- [Google Books](http://books.google.com/): a mind-blowing 300+ billion words from millions of books published since 1500 in multiple languages (mostly English), with [an n-gram searching interface](http://books.google.com/ngrams) for longitudinal comparisons of language use

For downloading and standardized interfacing with a variety of small-ish corpora, check out NLTK’s [corpus module](http://nltk.org/api/nltk.corpus.html). Brigham Young University has [a web portal](http://corpus.byu.edu/) with fancy search functionality for several corpora, although their interface is clunky. Others can be hunted down via Google or a list [like this](http://www-nlp.stanford.edu/links/statnlp.html#Corpora).

But _what if_ you wanted to study a particular subject, author, language, etc. for which a corpus hasn’t already been made available? What if, for example, you’re really interested in [Thomas L. Friedman](http://topics.nytimes.com/top/opinion/editorialsandoped/oped/columnists/thomaslfriedman/index.html) of the New York Times? He’s been writing consistently for the past 30+ years, in a couple of different genres, about a wide range of contemporary issues, and all of these writings are available online and already annotated with metadata. Sounds totally compelling, right? Well, if you were _me_, you would build your own corpus. A Friedman corpus.

### Corpus Creation

Unlike most newspapers, the NYT has [an excellent set of APIs](http://developer.nytimes.com/page) for accessing their data, integrating it into new applications, and otherwise applying it to novel purposes. Specifically, I used [the Article Search API v2](http://developer.nytimes.com/docs/read/article_search_api_v2) to find all of Thomas Friedman’s articles over the years. [An API Request Tool](http://prototype.nytimes.com/gst/apitool/index.html) can be used to test out queries quickly, although a word of warning: since upgrading to v2 of Article Search, documentation and tool stability has been lacking...

```python
from pprint import pprint
import requests
 
# fill in your api key here...
my_api_key = ####
 
# parameters specifying what data is to be returned
fields = ['web_url', 'snippet', 'lead_paragraph', 'abstract',
          'print_page', 'blog', 'source', 'multimedia', 'headline',
          'keywords', 'pub_date', 'document_type', 'news_desk',
          'byline', 'type_of_material', '_id', 'word_count']
facet_fields = ['source', 'section_name', 'document_type',
                'type_of_material', 'day_of_week']
 
# get request the server
resp = requests.get('http://api.nytimes.com/svc/search/v2/articlesearch.json',
                    params={'q': 'Thomas L. Friedman',
                            'page': 0,
                            'sort': 'newest',
                            'fl': ','.join(fields),
                            'facet_field': ','.join(facet_fields),
                            'facet_filter': 'true',
                            'api-key': my_api_key},
                    )
 
# check out all teh dataz
pprint(resp.json())
```

The API provides additional content, depending on the parameters passed to it; a particularly useful one is the <span style="font-family:courier">facets</span> field, which lets you explore NYT-specific categories and subsets of the data returned by your keyword-based search query. Using Python's built-in `str.format()` [method](http://docs.python.org/2/library/stdtypes.html#str.format), I printed out a nice display of the facets for this query:

<span style="font-family:courier">
facet                           count 
-------------------------------------
type_of_material..............   6847
   News.......................   1977
   Op-Ed......................   1912
   Letter.....................   1089
   Summary....................   1073
   List.......................    304
source........................   6847
   The New York Times.........   6841
   ...........................      3
   International Herald Tribu*      2
   CNBC.......................      1
document_type.................   6853
   article....................   6651
   blogpost...................    187
   multimedia.................     15
section_name..................   6838
   Opinion....................   3119
   New York and Region........   1097
   World......................    553
   World; Washington..........    483
   Arts; Books................    361
day_of_week...................   6853
   Sunday.....................   1755
   Wednesday..................   1559
   Friday.....................   1049
   Tuesday....................    833
   Thursday...................    748
</span>

Hm. It looks like the dataset is mostly news and op-eds —-- makes sense —-- published as New York Times articles --— also makes sense —-- in the Opinion and NY/World sections of the paper --— again, makes sense. I don't know enough to assess the distribution over days of the week or whether the other material types are appropriate for Friedman (__Spoiler Alert:__ I should've checked!), but this seems plausible enough.

Downloading from the API is, by design, meant to be straightforward; it's mostly just looping over the <span style="font-family:courier">page</span> parameter passed through the URL and aggregating the results. Here's a snippet of a single document returned by the API as JSON:

<span style="font-family:courier">
{u'_id': u'5254b0a738f0d8198974116f',
 u'abstract': u'Thomas L Friedman Op-Ed column contends that mainstream Republicans have a greater interest than Democrats in Pres Obama prevailing over Tea Party Republicans in the government shutdown showdown; holds that a Tea Party victory would serve to marginalize mainstream Republicans, and would make the party incapable of winning presidential elections.',
 u'blog': [],
 u'byline': {u'contributor': u'',
             u'original': u'By THOMAS L. FRIEDMAN',
             u'person': [{u'firstname': u'Thomas',
                          u'lastname': u'FRIEDMAN',
                          u'middlename': u'L.',
                          u'organization': u'',
                          u'rank': 1,
                          u'role': u'reported'}]},
 u'document_type': u'article',
 u'headline': {u'kicker': u'Op-Ed Columnist',
               u'main': u'U.S. Fringe Festival',
               u'print_headline': u'U.S. Fringe Festival'},
 u'keywords': [{u'is_major': u'N',
                u'name': u'subject',
                u'rank': u'5',
                u'value': u'Shutdowns (Institutional)'},
               {u'is_major': u'Y',
                u'name': u'subject',
                u'rank': u'9',
                u'value': u'Federal Budget (US)'},
               {u'is_major': u'N',
                u'name': u'persons',
                u'rank': u'7',
                u'value': u'Obama, Barack'},
               ... snip ...
               {u'is_major': u'N',
                u'name': u'organizations',
                u'rank': u'4',
                u'value': u'House of Representatives'}],
 u'lead_paragraph': u'What if Ted Cruz & Co. were to succeed in the shutdown showdown?',
 u'multimedia': [{u'height': 75,
                  u'legacy': {u'thumbnail': u'images/2010/09/16/opinion/Friedman_New/Friedman_New-thumbStandard.jpg',
                              u'thumbnailheight': u'75',
                              u'thumbnailwidth': u'75'},
                  u'subtype': u'thumbnail',
                  u'type': u'image',
                  u'url': u'images/2010/09/16/opinion/Friedman_New/Friedman_New-thumbStandard.jpg',
                  u'width': 75}],
 u'news_desk': u'Editorial',
 u'print_page': u'29',
 u'pub_date': u'2013-10-09T00:00:00Z',
 u'snippet': u'What if Ted Cruz & Co. were to succeed in the shutdown showdown?',
 u'source': u'The New York Times',
 u'type_of_material': u'Op-Ed',
 u'web_url': u'http://www.nytimes.com/2013/10/09/opinion/friedman-us-fringe-festival.html',
 u'word_count': u'900'}
</span>

As you can see, the Times adds _lots_ of metadata to each post! There are human-annotated entities (e.g. Barack Obama) and subjects (e.g. Shutdown), the publication date, word count, a link to Thomas Friedman's [new portrait](http://nytimes.com/images/2010/09/16/opinion/Friedman_New/Friedman_New-thumbStandard.jpg), the URL for the digital article, as well as an abstract and the lead paragraph. Excellent! Except... Well, shit. Where's the full article text?!

Unfortunately, the New York Times doesn't want you to read its journalistic output without actually visiting the web site or buying the paper (think: advertising revenue), so they exclude that data from their API results. Irritating, yes, but there is hope: the URL for each article is included in the metadata. Getting Friedman's full text is just a matter of web scraping! Except... that's easier said than done. As I said, they want people to actually visit their site --— _robots_ don't count. On my first attempt at a straightforward scrape, the site's web admin blocked me within a hundred calls or so. Probably should've seen that coming. I won't get into the full details of how I managed to scrape about 6500 Friedman articles from the NYT website, but I will share some general guidelines for how to scrape a web site without getting caught.

- Send a proper User Agent ([spoofing!](http://en.wikipedia.org/wiki/User_agent#User_agent_spoofing)) and full header information along with the URL, including a language and charset. At least _pretend_ to be a real web browser.
- Randomize the time interval between calls to the server. Sending a request exactly ten times per second is a great way to get classified as non-human. In Python, try something like `time.sleep(random.random())` --— the longer you wait, the less noticeable you'll be.
- Randomize the order in which you access content. Requesting all of Thomas L. Friedman's articles since 1981 in chronological order, one after the other, is also a great way to identify yourself as a bot.
- Randomize your _identity_, i.e. your IP address. There are a number of ways to do this, including [proxies](http://www.proxyrack.com/) and [Tor](https://www.torproject.org/). This may be non-trivial to set up, though, so find a good tutorial and follow along!

Eventually, through somewhat nefarious means, I managed to scrape together a complete Friedman corpus. Huzzah. In my next post, I examine the data and do some basic summary statistics and sanity checks.
