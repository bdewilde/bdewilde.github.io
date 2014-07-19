---
layout: post
title: Friedman Corpus (2) — Data Quality and Corpus Stats
date: 2013-10-20 20:05:00
categories: [blog, blogger]
tags: [corpus linguistics, data quality, domain expertise, metadata, pie chart, Thomas Friedman]
---

With a full-text Friedman corpus finally in hand (see [Background and Creation]({% post_url 2013-10-15-friedman-corpus-1-background-and-creation %}) post), my first task was to verify data quality. Given "[Garbage In, Garbage Out](http://en.wikipedia.org/wiki/Garbage_in,_garbage_out)", the fun stuff (analysis! plots! [Friedman_ebooks](https://twitter.com/Horse_ebooks)?!) had to wait. Yes, it's a pain in the ass, but this step is _really_ important.

### Data Quality

Since v2 of [the NYT Article Search API](http://developer.nytimes.com/docs/read/article_search_api_v2) was unfamiliar to me (they changed enough from v1 that my old code no longer ran), I used a bare-bones search query: "Thomas L. Friedman" --— without filtering. This was a mistake. As I should have caught beforehand, I actually retrieved all articles mentioning Friedman anywhere in the headline, byline, or body text, instead of only those articles _written_ by Friedman. So I got many results like this:

> By MAUREEN DOWD; <span style="background-color: #FFFF00">Thomas L. Friedman</span> is on leave until October, writing a book
> By Fareed Zakaria: In the global economy, says <span style="background-color: #FFFF00">Thomas L. Friedman</span>, intellectual work could be transmitted to intellectual workers anywhere on earth. 
> To the Editor:    <span style="background-color: #FFFF00">Thomas L. Friedman</span> (column, Jan. 5) says he has ''no problem with a war for oil,'' granting certain provisions.    No problem with killing or maiming innocent civilians for oil?

Although I'm _quite_ curious about the many Letters to the Editor taking Friedman to task, such text doesn't belong in a Friedman-only corpus, nor does Maureen Dowd's tart wordplay or Fareed Zakaria's whatever-it-is-that-he-writes. I also noticed that I wasn't able to get the article text for ~1300 results on account of missing/broken URLs in the API response and weird/broken HTML at the given URL (no parser is perfect), rendering them effectively useless in a collection of Friedman text. As it turned out, almost all of those without full-text were neither news nor op-ed articles:

```
>>> df['type_of_material'][df['full_text'].isnull()].value_counts()
Summary                441
Letter                 348
Blog                   186
List                   168
Op-Ed                   99
News                    85
Editors' Note            7
Schedule                 5
Obituary; Biography      2
Editorial                2
Article                  1
Interview                1
Review                   1
Obituary                 1
```

Wait a sec, why is an _obituary_ in here? Friedman is (physically, if not intellectually) alive and well! [See for yourself](http://query.nytimes.com/mem/archive/pdf?res=980DE4DB1538EE3ABC4952DFB3668383629EDE) —-- this was definitely cruft, as were many of the other results. And they shouldn't be in there. So, I filtered for articles actually written by Thomas L. Friedman for which I had managed to scrape the full text. After imposing this important requirement, the `type_of_material` breakdown looked much better:

```
>>> df['type_of_material'].value_counts()
News                              1757
Op-Ed                             1640
An Analysis; News Analysis          96
An Analysis                         53
Series                              11
Biography                           10
Special Report                       3
Interview                            3
An Analysis; Economic Analysis       2
Editorial                            2
Review                               2
Chronology                           1
Op-Ed; Series                        1
Biography; Series                    1
Special Report; Chronology           1
```

Roughly half news, half op-eds, with a smattering of analyses and such over the years. Sounds like Friedman! As a final sanity check, though, I wanted to see how the above breakdown was distributed over time. So, I grouped results by year of publication and type of material, then plotted them together using [matplotlib](http://matplotlib.org/) (Python's de facto standard plotting library) and, just for kicks, [prettyplotlib](http://olgabot.github.io/prettyplotlib/) (a recently-released package that makes plots pretty). Here's what I got:

<figure>
  <img class="fullw" src="/assets/images/2013-10-20-article-counts-by-type-over-time.png" alt="2013-10-20-article-counts-by-type-over-time.png">
</figure>

It is indeed pretty, but does it make _sense_? Yes, if you know a bit about Friedman's career at The New York Times. [Insert comment about how domain expertise matters in data science, à la [Drew Conway's venn diagram](http://drewconway.com/zia/2013/3/26/the-data-science-venn-diagram)...] Friedman was hired in 1981 and sent to Beirut to cover [the Lebanese Civil War](http://en.wikipedia.org/wiki/Lebanese_Civil_War); he won a Pulitzer prize for his war-time coverage in 1983. The following year he was transferred to Jerusalem, where he served as Bureau Chief until 1988. In that year, he won another Pulitzer for his reporting on international affairs —-- and wrote a book about it. Friedman moved on to American foreign policy, George Bush's Secretary of State, and then the White House itself. In 1995 he became a foreign affairs columnist writing in the Op-Eds section. In 2002 he won yet _another_ Pulitzer, this one for his commentary on the global threat posed by terrorism. And he's been yammering away ever since.

The big change from News to Op-Ed is evident in the plot, but what's with the lack of articles in 1988? I saw nothing amiss in the data, so it may be that Friedman was simply too busy receiving Pulitzers and writing his first book to report the news that year. \*shrug\* I also wondered about the overall number of articles, so I did a back-of-the-envelope calculation: Given that he's a twice-weekly columnist (and accounting for holidays/vacations), we'd expect upwards of 100 op-eds per year. Indeed, that is roughly what we see. He was especially productive in 2012, probably owing to a presidential election _shitstorm_, but seems on track for an average year in 2013.

Reasonably confident that I'd covered most of Friedman's work at the NYT and that all my documents were what I thought they were, I started to dig deeper.

### Corpus Stats

Before diving into natural language processing of the text, I wanted to explore the data at a corpus-wide scale. I already checked the number of articles by type and by year to verify data quality, but what else was there?

As I mentioned in Pt. 1, the NYT API includes lots of metadata with articles. The `keywords` field is a list of subjects and entities (locations, people, organizations) included in a given article; aggregating counts from all such lists would probably give a good idea of what Friedman has been writing about for all these years, right? To accomplish this, I used a convenient datatype in Python's [collections](http://docs.python.org/2/library/collections.html) module:

{% highlight python %}
from collections import Counter
 
glocations = []; persons = []; subjects = []; organizations = []
for doc in friedman_docs:
    if not doc.get('keywords'):
        continue
    for keyword in doc['keywords']:
        if keyword['name'] == 'glocations':
            glocations.append(keyword.get('value'))
        elif keyword['name'] == 'persons':
            persons.append(keyword.get('value'))
        elif keyword['name'] == 'subject':
            subjects.append(keyword.get('value'))
        elif keyword['name'] == 'organizations':
            organizations.append(keyword.get('value'))
glocations_counter = Counter(glocations)
persons_counter = Counter(persons)
subjects_counter = Counter(subjects)
organizations_counter = Counter(organizations)
{% endhighlight %}

For example, here are Friedman's top ten _subjects_, given as NAME (count):

```
UNITED STATES INTERNATIONAL RELATIONS (1396)
INTERNATIONAL RELATIONS (605)
PALESTINIANS (591)
UNITED STATES ARMAMENT AND DEFENSE (496)
POLITICS AND GOVERNMENT (425)
ARMAMENT, DEFENSE AND MILITARY FORCES (420)
TERRORISM (333)
ECONOMIC CONDITIONS AND TRENDS (286)
INTERNATIONAL TRADE AND WORLD MARKET (226)
CIVIL WAR AND GUERRILLA WARFARE (174)
```

Considering his bio, this looks totally reasonable, if a bit depressing. If you're curious, his top _locations_ were the Middle East, Israel, and Lebanon (which is not at all surprising), and his top _organizations_ were the U.N., NATO, and the Palestine Liberation Organization, followed distantly by the Republican and Democratic Parties. On a lark, I made a pie chart of the equivalent _persons_ keywords, where the percentages equal the number of times Friedman has mentioned a given person divided by the total number of people-mentions (multiplied by 100):

<figure>
  <img class="tqw" src="/assets/images/2013-10-20-person-counts-pie-chart.png" alt="2013-10-20-person-counts-pie-chart.png">
</figure>

In the top ten you see the usual subjects --— current and former presidents, George Bush's Secretary of State ([Mr. Baker](http://en.wikipedia.org/wiki/James_Baker)), Middle Eastern heads of state, _Gorbachev_ --— which together comprise almost 50% of all mentions. The other half —-- "EVERYONE ELSE" —-- is a multitude whose 920 wedges can't be visualized like this. So much for pie charts!

Last but not least, here are some super simple stats for the Friedman corpus text:

- number of articles: 3,584
- number of sentences: 115k
- number of words: 2.96M
- number of unique words: 71.9k
- average sentence length: 24.9 words
- average word length: 4.81 letters
- average Flesh-Kincaid grade level: 11.8

Next time, I (finally!) get to what I consider the fundamental measures of corpus linguistics: word occurrence, word co-occurrence, and word dispersion. And more.
