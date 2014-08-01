---
layout: post
title: Friedman Corpus (3) — Occurrence and Dispersion
date: 2013-11-03 20:05:00
categories: [blog, blogger]
tags: [co-occurrence, corpus linguistics, dispersion, natural language processing, occurrence, Thomas Friedman, tokenization]
comments: true
preview_pic: /assets/images/2013-11-03-top-words-by-count-and-freq.png
---

Thus far, I've pseudo-justified why a collection of [NYT articles by Thomas Friedman](http://topics.nytimes.com/top/opinion/editorialsandoped/oped/columnists/thomaslfriedman/index.html) would be interesting to study, actually compiled/scraped the text and metadata (see [Background and Creation]({% post_url 2013-10-15-friedman-corpus-1-background-and-creation %}) post), improved/verified the quality of the data, and computed a handful of simple, corpus-level statistics (see [Data Quality and Corpus Stats]({% post_url 2013-10-20-friedman-corpus-2-data-quality-and-corpus-stats %}) post). Now, onward to actual natural language analysis!

### Occurrence

I would argue that the _frequency of occurrence_ of words and other linguistic elements is the fundamental measure on which much NLP is based. In essence, we want to answer "How many times did something occur?" in both absolute and relative terms. Since words are probably the most familiar "linguistic elements" of a language, I focused on _word_ occurrence; however, other elements may also merit counting, including [morphemes](http://en.wikipedia.org/wiki/Morpheme) ("bits of words") and parts-of-speech (nouns, verbs, ...).

__Note:__ In the past I've been confused by the terminology used for absolute and relative frequencies —-- pretty sure it's used inconsistently in the literature. I use _count_ to refer to absolute frequencies (whole, positive numbers: 1, 2, 3, ...) and _frequency_ to refer to relative frequencies (rational numbers between 0.0 and 1.0). These definitions sweep certain complications under the rug, but I don't want to get into it right now...

Anyway, in order to count individual words, I had to split the corpus text into a list of its component words. [I've discussed tokenization before]({% post_url 2012-12-16-intro-to-natural-language-processing-1 %}), so I won't go into details. Given that I scraped this text from the web, though, I should note that I cleaned it up a bit before tokenizing: namely, I decoded any HTML entities; removed all HTML markup, URLs, and non-ASCII characters; and normalized white-space. Perhaps controversially, I also unpacked contractions (e.g., "don't" => "do not") in an effort to avoid weird tokens that creep in around apostrophes (e.g., "don"+"'"+"t" or "don"+"'t"). Since any mistakes in tokenization propagate to results downstream, it's probably best to use a "standard" tokenizer rather than something homemade; I've found NLTK's defaults to be good enough (usually). Here's some sample code:

{% highlight python %}
from itertools import chain
from nltk import clean_html, sent_tokenize, word_tokenize
 
# combine all articles into single block of text
all_text = ' '.join([doc['full_text'] for doc in docs])
# partial cleaning as example: this uses nltk to strip residual HTML markup
cleaned_text = clean_html(all_text)
# tokenize text into sentences, sentences into words
tokenized_text = [word_tokenize(sent) for sent in sent_tokenize(cleaned_text)]
# flatten list of lists into a single words list
all_words = list(chain(*tokenized_text))
{% endhighlight %}

Now I had one last set of decisions to make: _Which_ words do I want to count? Depends on what you want to do, of course! For example, [this article](http://phenomena.nationalgeographic.com/2013/07/19/how-forensic-linguistics-outed-j-k-rowling-not-to-mention-james-madison-barack-obama-and-the-rest-of-us/) explains how filtering for and studying certain words helped computational linguists identify J.K. Rowling as the person behind the author Robert Galbraith. In _my_ case, I just wanted to get a general feeling for the meaningful words Friedman has used the most. So, I filtered out [stop words](http://en.wikipedia.org/wiki/Stop_words) and bare punctuation tokens, and I lowercased all letters, but I did not stem or lemmatize the words; the total number of words dropped from 2.96M to 1.43M. I then used NLTK's handy `FreqDist()` class to get counts by word. Here are both counts and frequencies for the top 30 "good" words in my Friedman corpus:

<figure>
  <img class="fullw" src="/assets/images/2013-11-03-top-words-by-count-and-freq.png" alt="2013-11-03-top-words-by-count-and-freq.png">
</figure>

You can see that the distributions are identical, except for the _y_-axis values: as discussed above, counts are the absolute number of occurrences for each word, while frequencies are those counts divided by the total number of words in the corpus. It's interesting but not particularly surprising that Friedman's top two meaningful words are _mr._ and _said_ --— he's a journalist, after all, and he's quoted a lot of people. (Perhaps [he met them on the way](http://www.nytimes.com/2006/11/01/opinion/01friedman.html) to/from a foreign airport...) Given what we know about Friedman's career (as discussed in [(1)]({% post_url 2013-10-15-friedman-corpus-1-background-and-creation %})), most of the other top words also sound about right: Israel/Israeli, president, American, people, world, _Bush_, ...

On a lark, I compared word counts for the five presidents that have held office during Friedman's NYT career: Ronald Reagan, George H.W. Bush, Bill Clinton, George W. Bush, and Barack Obama:

- "reagan": 761
- "bush": 3582
- "clinton": 2741
- "obama": 964

Yes, the two Bush's got combined, and Hillary is definitely contaminating Bill's counts (I didn't feel like doing reference disambiguation on this, sorry!). I find it more interesting to plot _conditional_ frequency distributions, i.e. a set of frequency distributions, one for each value of some condition. So, taking the article's year of publication as the condition, I produced this plot of presidential mentions by year:

<figure>
  <img class="fullw" src="/assets/images/2013-11-03-presidents-by-frequency-over-time.png" alt="2013-11-03-presidents-by-frequency-over-time.png">
</figure>

Nice! You can clearly see frequencies peaking during a given president's term(s), which makes sense. Plus, they show Friedman's change in focus over time: early on, he covered Middle Eastern conflict, not the American presidency; in 1994, a year in which Clinton was mentioned particularly frequently, Friedman was specifically covering the White House. I'm tempted to read further into the data, such as the long decline of W. Bush mentions throughout —-- and beyond --— his second term possibly indicating his slide into irrelevance, but I shouldn't without first inspecting context. Some other time, perhaps.

I made a few other conditional frequency distributions using NLTK's `ConditionalFreqDist()` class, just for kicks. Here are two, presented without comment (only hints of a raised eyebrow on the author's part):

<figure>
  <img class="fullw" src="/assets/images/2013-11-03-countries-by-frequency-over-time.png" alt="2013-11-03-countries-by-frequency-over-time.png">
</figure>

<figure>
  <img class="fullw" src="/assets/images/2013-11-03-war-peace-by-frequency-over-time.png" alt="2013-11-03-war-peace-by-frequency-over-time.png">
</figure>

These plots-over-time lead naturally into the concept of dispersion.
<!--more-->

### Dispersion

Although frequencies of (co-)occurrence are fundamental and ubiquitous in corpus linguistics, they are potentially misleading unless one also gives a measure of [_dispersion_](http://en.wikipedia.org/wiki/Statistical_dispersion), i.e. the spread or variability of a distribution of values. It's Statistics 101: You shouldn't report a mean value without an associated dispersion!

Counts/frequencies of words or other linguistic elements are often used to indicate importance in a corpus or language, but consider a corpus in which two words have the same counts, only the first word occurs in 99% of corpus documents, while the second word is concentrated in just 5%. Which word is "more important"? And how should we interpret subsequent statistics based on these frequencies if the second word's high value is unrepresentative of most of the corpus?

In the case of my Friedman corpus, the conditional frequency distributions over time (above) visualize, to a certain extent, those terms' dispersions. But we can do more. As it turns out, NLTK includes [a small module](http://nltk.org/api/nltk.draw.html#module-nltk.draw.dispersion) to plot dispersion; like so:

{% highlight python %}
from nltk.draw import dispersion_plot
dispersion_plot(all_words,
                ['reagan', 'bush', 'clinton', 'obama'],
                ignore_case=True)
{% endhighlight %}

<figure>
  <img class="fullw" src="/assets/images/2013-11-03-presidential-mention-dispersion.png" alt="2013-11-03-presidential-mention-dispersion.png">
</figure>

To be honest, I'm not even sure how to interpret this plot --— for starters, why does Obama appear at what I think is the beginning of the corpus?! Clearly, it would be nice to quantify dispersion as, like, a single, scalar value. Many dispersion measures have been proposed over the years (see [1] for a nice overview), but in the context of linguistic elements, most are poorly known, little studied, and suffer from a variety of statistical shortcomings. Also in [1], the author proposes an alternative, conceptually simple measure of dispersion called _DP_, for deviation of proportions, whose derivation he gives as follows:

- Determine the sizes _s_ of each of the _n_ corpus parts (documents), which are normalized against the overall corpus size and correspond to expected percentages which take differently-sized corpus parts into consideration.
- Determine the frequencies _v_ with which word _a_ occurs in the _n_ corpus parts, which are normalized against the overall number of occurrences of _a_ and correspond to an observed percentage.
- Compute all _n_ pairwise absolute differences of observed and expected percentages, sum them up, and divide the result by two. The result is _DP_, which can theoretically range from approximately 0 to 1, where values close to 0 indicate that _a_ is distributed across the _n_ corpus parts as one would expect given the sizes of the _n_ corpus parts. By contrast, values close to 1 indicate that _a_ is distributed across the _n_ corpus parts exactly the opposite way one would expect given the sizes of the _n_ corpus parts.

Sounds reasonable to me! (Read the cited paper if you disagree, I found it very convincing.) Using this definition, I calculated _DP_ values for all words in the Friedman corpus and plotted those values against their corresponding counts:

<figure>
  <img class="tqw" src="/assets/images/2013-11-03-counts-vs-dispersion.png" alt="2013-11-03-counts-vs-dispersion.png">
</figure>

As expected, the most frequent words tend to have lower _DP_ values (be more evenly distributed in the corpus), and vice-versa; however, note the wide spread in _DP_ for a fixed count, particularly in the middle range. Many words are _definitely_ distributed unevenly in the Friedman corpus!

A common —-- but not entirely ideal --— way to account for dispersion in corpus linguistics is to compute the _adjusted frequency_ of words, which is often just frequency multiplied by dispersion. (Other definitions exist, but I won't get into it.) Such adjusted frequencies are by definition some fraction of the raw frequency, and words with low dispersion are penalized more than those with high dispersion. Here, I plotted the frequencies and adjusted frequencies of Friedman's top 30 words from before:

<figure>
  <img class="fullw" src="/assets/images/2013-11-03-top-words-by-adjusted-frequency.png" alt="2013-11-03-top-words-by-adjusted-frequency.png">
</figure>

You can see that the rankings would change if I used adjusted frequency to order the words! This difference can be quantified with, say, [a Spearman correlation coefficient](http://en.wikipedia.org/wiki/Spearman's_rank_correlation_coefficient), for which a value of 1.0 indicates identical rankings and -1.0 indicates exactly opposite rankings. I calculated a value of 0.89 for frequency-ranks vs adjusted frequency-ranks: similar, but not the same! It's clear that the effect of (under-)dispersion should not be ignored in corpus linguistics. My big issue with adjusted frequencies is that they are more difficult to interpret: What, exactly, does frequency\*dispersion actually mean? What units go with those values? Maybe smarter people than I will come up with a better measure.

Well, I'd meant to include word co-occurrence in this post, but it's already too long. Congratulations for making it all the way through! :) Next time, then, I'll get into bigrams/trigrams/_n_-grams and association measures. And after that, I get to the fun stuff!

[1] Gries, Stefan Th. "Dispersions and adjusted frequencies in corpora." International journal of corpus linguistics 13.4 (2008): 403-437.
