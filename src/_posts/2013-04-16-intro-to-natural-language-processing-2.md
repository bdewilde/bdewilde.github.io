---
layout: post
title: Intro to Natural Language Processing (2)
date: 2013-04-16 12:24:00
categories: [blog, blogger]
tags: [information extraction, natural language processing, pos-tagging, tokenization, web scraping]
comments: true
---

A couple months ago, I posted [a brief, conceptual overview]({% post_url 2012-12-16-intro-to-natural-language-processing-1 %}) of Natural Language Processing (NLP) as applied to the common task of information extraction (IE) —-- that is, the process of extracting _structured_ data from _unstructured_ data, the majority of which is text. A significant component of my job at [HI](http://harmony-institute.org/) involves scraping text from websites, press articles, social media, and other sources, then analyzing the quantity and especially quality of the discussion as it relates to a film and/or social issue. Although humans are inarguably better than machines at understanding natural language, it's impractical for humans to analyze large numbers of documents for themes, trends, content, sentiment, etc., and to do so consistently throughout. This is where NLP comes in.

In this post, I'll give practical details and example code for basic NLP tasks; in the next post, I'll delve deeper into the standard tokenization-tagging-chunking pipeline; and in subsequent posts, I'll move on to more interesting NLP tasks, including keyterm/keyphrase extraction, topic modeling, document classification, sentiment analysis, and text generation.

The first thing we need to get started is, of course, some sample text. Let's use [this recent op-ed](http://www.nytimes.com/2013/04/07/opinion/sunday/friedman-weve-wasted-our-timeout.html) in the New York Times by [Thomas Friedman](http://topics.nytimes.com/top/opinion/editorialsandoped/oped/columnists/thomaslfriedman/index.html), which is about as close to [lorem ipsum](http://en.wikipedia.org/wiki/Lorem_ipsum) as natural language gets. Although copy-pasting the text works fine for a single article, it quickly becomes a hassle for multiple articles; instead, let's do this programmatically and put [our web scraping skillz]({% post_url 2012-11-26-web-scraping-and-html-parsing-2 %}) to good use. A bare-bones Python script gets the job done:

{% highlight python %}
import bs4
import requests
 
# GET html from NYT server, and parse it
response = requests.get('http://www.nytimes.com/2013/04/07/opinion/sunday/friedman-weve-wasted-our-timeout.html')
soup = bs4.BeautifulSoup(response.text)
 
article = ''
 
# select all tags containing article text, then extract the text from each
paragraphs = soup.find_all('p', itemprop='articleBody')
for paragraph in paragraphs:
    article += paragraph.get_text()
{% endhighlight %}

We have indeed retrieved the text of Friedman's vapid commentary —--

<span style="font-family:courier">YES, it’s true — a crisis is a terrible thing to waste. But a “timeout” is also a terrible thing to waste, and as I look at the world today I wonder if that’s exactly what we’ve just done. We’ve wasted a five-year timeout from geopolitics, and if we don’t wake up and get our act together as a country — and if the Chinese, Russians and Europeans don’t do the same — we’re all really going to regret it. Think about what a relative luxury we’ve enjoyed since the Great Recession hit in 2008...</span>

--— but it's not yet fit for analysis.

The first steps in any NLP analysis are text _cleaning_ and _normalization_. Although the specific steps we should take to clean and normalize our text depend on the analysis we mean to apply to it, a decent, general-purpose cleaning procedure removes any digits, non-[ASCII](http://www.asciitable.com/) characters, URLs, and HTML markup; standardizes white space and line breaks; and converts all text to lowercase. Like so:

{% highlight python %}
def clean_text(text):
    
    from nltk import clean_html
    import re
    
    # strip html markup with handy NLTK function
    text = clean_html(text)        
    # remove digits with regular expression
    text = re.sub(r'\d', ' ', text)
    # remove any patterns matching standard url format
    url_pattern = r'((http|ftp|https):\/\/)?[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?'
    text = re.sub(url_pattern, ' ', text)
    # remove all non-ascii characters
    text = ''.join(character for character in text if ord(character)<128)
    # standardize white space
    text = re.sub(r'\s+', ' ', text)
    # drop capitalization
    text = text.lower()
    
    return text
{% endhighlight %}

After passing the article through `clean_text`, it comes out like this:

<span style="font-family:courier">yes, its true a crisis is a terrible thing to waste. but a timeout is also a terrible thing to waste, and as i look at the world today i wonder if thats exactly what weve just done. weve wasted a five-year timeout from geopolitics, and if we dont wake up and get our act together as a country and if the chinese, russians and europeans dont do the same were all really going to regret it. think about what a relative luxury weve enjoyed since the great recession hit in ...</span>
<!--more-->

It may look worse to your eyes, but machines tend to perform better without the extraneous features. As an additional step on top of cleaning, normalization comes in two varieties: [stemming](http://en.wikipedia.org/wiki/Stemming) and [lemmatization](http://en.wikipedia.org/wiki/Lemmatisation). Stemming strips off word affixes, leaving just the root stem, while lemmatization replaces a word by its root word or _lemma_, as might be found in a dictionary. For example, the word "grieves" is stemmed into "grieve" but lemmatized into "grief." The excellent [NLTK](http://nltk.org/) Python library, with which I do much of my NLP work, provides an easy interface to multiple stemmers (Porter, Lancaster, Snowball) and a standard lemmatizer ([WordNet](http://wordnet.princeton.edu/), which is much more than just a lemmatizer).

Since normalization is applied word-by-word, it is inextricably linked with _tokenization_, the process of splitting text into pieces, i.e. sentences and words. For some analyses, tokenizing a document or a collection of documents (called a _corpus_) directly into words is fine; for others, it's necessary to first tokenize a text into sentences, then tokenize each sentence into words, resulting in nested lists. Although this seems like a straightforward task — words are separated by spaces, duh! — one notable complication arises from punctuation. Should "don't know" be tokenized as ["don't", "know"], ["don", "'t", "know"], or ["don", "'", "t", "know"]? I don't know. ;) It's common, but not always applicable, to filter out high-frequency words with little lexical content like "the," "it," and "so," called [_stop words_](http://en.wikipedia.org/wiki/Stop_words). Of course, there's no universally-accepted list, so you have to use your own judgement! Lastly, it's usually a good idea to put an upper bound on the length of words you'll keep. In English, average word length is about five letters, and [the longest word in Shakespeare's works](http://en.wikipedia.org/wiki/Honorificabilitudinitatibus) is 27 letters; errors in text sources or weird HTML cruft, however, can produce much longer chains of letters. It's a pretty safe bet to filter out words longer than 25 letters long. As you can see below, NLTK and Python make all of this _relatively_ easy:

{% highlight python %}
def tokenize_and_normalize_doc(doc, filter_stopwords=True, normalize='lemma'):
    
    import nltk.corpus
    from nltk.stem import PorterStemmer, WordNetLemmatizer
    from nltk.tokenize import sent_tokenize, word_tokenize, wordpunct_tokenize
    from string import punctuation
    
    # use NLTK's default set of english stop words
    stops_list = nltk.corpus.stopwords.words('english')
    
    if normalize == 'lemma':
        # lemmatize with WordNet
        normalizer = WordNetLemmatizer()
    elif normalize == 'stem':
        # stem with Porter
        normalizer = PorterStemmer()
    
    # tokenize the document into sentences with NLTK default
    sents = sent_tokenize(doc)
    # tokenize each sentence into words with NLTK default
    tokenized_sents = [wordpunct_tokenize(sent) for sent in sents]
    # filter out "bad" words, normalize good ones
    normalized_sents = []
    for tokenized_sent in tokenized_sents:
        good_words = [word for word in tokenized_sent
                      # filter out too-long words
                      if len(word) < 25
                      # filter out bare punctuation
                      if word not in list(punctuation)]
        if filter_stopwords is True:
            good_words = [word for word in good_words
                          # filter out stop words
                          if word not in stops_list]
        if normalize == 'lemma':
            normalized_sents.append([normalizer.lemmatize(word) for word in good_words])
        elif normalize == 'stem':
            normalized_sents.append([normalizer.stem(word) for word in good_words])
        else:
            normalized_sents.append([word for word in good_words])
    
    return normalized_sents
{% endhighlight %}

Running our sample article through the grinder gives us this:

<span style="font-family:courier">['yes', 'true', 'crisis', 'terrible', 'thing', 'waste'], ['timeout', 'also', 'terrible', 'thing', 'waste', 'look', 'world', 'today', 'wonder', 'thats', 'exactly', 'weve', 'done'], ['weve', 'wasted', 'five-year', 'timeout', 'geopolitics', 'dont', 'wake', 'get', 'act', 'together', 'country', 'chinese', 'russian', 'european', 'dont', 'really', 'going', 'regret'], ['think', 'relative', 'luxury', 'weve', 'enjoyed', 'since', 'great', 'recession', 'hit'], ...</span>

Slowly but surely, Friedman's insipid words are taking on a standardized, machine-friendly format.

The next key step in a typical NLP pipeline is [part-of-speech (POS) tagging](http://en.wikipedia.org/wiki/Part-of-speech_tagging): classifying words into their context-appropriate part-of-speech and labeling them as such. Again, this _seems_ like something that ought to be straightforward (kids are taught how to do this at a fairly young age, right?), but in practice it's not so simple. In general, the incredible ambiguity of natural language has a way of confounding NLP algorithms —-- and occasionally humans, too. For instance, think about all the ways "well" can be used in a sentence: noun, verb, adverb, adjective, and interjection (any others?). Plus, there's no "official" POS tagset for English, although the conventional sets, e.g. [Penn Treebank](http://www.ling.upenn.edu/courses/Fall_2003/ling001/penn_treebank_pos.html), have upwards of 50 distinct parts of speech.

The simplest POS tagger out there assigns a default tag to each word; in English, singular nouns ("NN") are probably your best bet, although you'll only be right about 15% of the time! Other simple taggers determine POS from spelling: words ending in "-ment" tend to be nouns, "-ly" adverbs, "-ing" gerunds, and so on. Smarter taggers use the context of surrounding words to assign POS tags to each word. Basically, you calculate the frequency that a tag has occurred in each context based on pre-tagged training data, then for a new word, assign the tag with the highest frequency for the given context. The models can get rather elaborate (more on this in my next post), but this is the gist. NLTK comes pre-loaded with a pretty decent POS tagger trained using a Maximum Entropy classifier on the Penn Treebank corpus (I think). See here:

{% highlight python %}
def pos_tag_sents(tokenized_sents):
    from nltk.tag import pos_tag
    tagged_sents = [pos_tag(sent) for sent in tokenized_sents]
    return tagged_sents
{% endhighlight %}

Each tokenized word is now paired with its assigned part of speech in the form of (word, tag) tuples:

<span style="font-family:courier">[[('yes', 'NNS'), ('its', 'PRP$'), ('true', 'JJ'), ('a', 'DT'), ('crisis', 'NN'), ('is', 'VBZ'), ('a', 'DT'), ('terrible', 'JJ'), ('thing', 'NN'), ('to', 'TO'), ('waste', 'VB')], [('but', 'CC'), ('a', 'DT'), ('timeout', 'NN'), ('is', 'VBZ'), ('also', 'RB'), ('a', 'DT'), ('terrible', 'JJ'), ('thing', 'NN'), ('to', 'TO'), ('waste', 'VB'), ('and', 'CC'), ('as', 'IN'), ('i', 'PRP'), ('look', 'VBP'), ('at', 'IN'), ('the', 'DT'), ('world', 'NN'), ('today', 'NN'), ('i', 'PRP'), ('wonder', 'VBP'), ('if', 'IN'), ('thats', 'NNS'), ('exactly', 'RB'), ('what', 'WP'), ('weve', 'VBP'), ('just', 'RB'), ('done', 'VBN')], ...</span>

Great! The first word is incorrect: "yes" is not a plural noun ("NNS"). But after that, once you exclude weirdness arising from how I dealt with punctuation (by stripping it out, turning "it's" into "its," which was consequently tagged as a possessive pronoun), the tagger did pretty well. Note that I pulled back a bit from our previous text normalization by adding stop words back in and _not_ lemmatizing: as I said, that's not appropriate for every task.

One final, fundamental task in NLP is [_chunking_](http://en.wikipedia.org/wiki/Chunking_(computational_linguistics)): the process of extracting standalone phrases, or "chunks," from a POS-tagged sentence without fully _parsing_ the sentence (on a related note, chunking is also known as partial or shallow parsing). Chunking, for instance, can be used to identify the noun phrases present in a sentence, while full parsing could say which is the subject of the sentence and which the object. So why stop at chunking? Well, full parsing is computationally expensive and not very robust; in contrast, chunking is both fast and reliable, as well as sufficient for many practical uses in information extraction, relation recognition, and so on.

A simple chunker can use patterns in part-of-speech tags to determine the types and extents of chunks. For example, a noun phrase (NP) in English often consists of a determiner, followed by an adjective, followed by a noun: the/DT fierce/JJ queen/NN. A more thorough definition might include a possessive pronoun, any number of adjectives, and more than one (singular/plural, proper) noun: his/PRP$ adorable/JJ fluffy/JJ kitties/NNS. I've implemented one such [regular expression-based chunker](http://nltk.org/api/nltk.chunk.html#regexpchunkparser) in NLTK, which looks for noun, prepositional, and verb phrases, as well as full clauses:

{% highlight python %}
def chunk_tagged_sents(tagged_sents):
    
    from nltk.chunk import regexp
    
    # define a chunk "grammar", i.e. chunking rules
    grammar = r"""
        NP: {<DT|PP\$>?<JJ>*<NN.*>+} # noun phrase
        PP: {<IN><NP>}               # prepositional phrase
        VP: {<MD>?<VB.*><NP|PP>}     # verb phrase
        CLAUSE: {<NP><VP>}           # full clause
    """
    chunker = regexp.RegexpParser(grammar, loop=2)
    chunked_sents = [chunker.parse(tagged_sent) for tagged_sent in tagged_sents]
    
    return chunked_sents
 
def get_chunks(chunked_sents, chunk_type='NP'):
    
    all_chunks = []
    # chunked sentences are in the form of nested trees
    for tree in chunked_sents:
        chunks = []
        # iterate through subtrees / leaves to get individual chunks
        raw_chunks = [subtree.leaves() for subtree in tree.subtrees()
                      if subtree.node == chunk_type]
        for raw_chunk in raw_chunks:
            chunk = []
            for word_tag in raw_chunk:
                # drop POS tags, keep words
                chunk.append(word_tag[0])
            chunks.append(' '.join(chunk))
        all_chunks.append(chunks)
    
    return all_chunks
{% endhighlight %}

I also included a function that iterates through the resulting parse trees and grabs only chunks of a certain type, e.g. noun phrases. Here's how Friedman fares:

<span style="font-family:courier">[['yes', 'a crisis', 'a terrible thing'], ['a timeout', 'a terrible thing', 'the world today', 'thats'], ['weve', 'a five-year timeout', 'geopolitics', 'act', 'a country', 'the chinese russians', 'europeans'], ...</span>

Well, could be worse for a basic run-through! We've grabbed a handful of simple NPs, and since this is Thomas Friedman's writing, I suppose that's all one can reasonably hope for. (There's probably a "garbage in, garbage out" joke to be made here.) You can see that removing punctuation has persisted in causing trouble —-- "weve" is _not_ a noun phrase —-- which underscores how important text cleaning is and how decisions earlier in the pipeline affect results further along. In my next NLP post, I'll discuss how to improve this basic pipeline and thereby improve subsequent, higher-level results.

For more information, check out Natural Language Processing with Python (free [here](http://nltk.org/book/)), a great introduction to NLP and NLTK. Another practical resource is [streamhacker.com](http://streamhacker.com/) and the associated book, [Python Text Processing with NLTK 2.0 Cookbook](http://www.packtpub.com/python-text-processing-nltk-20-cookbook/book). If you want NLP _without_ NLTK, Stanford's [CoreNLP](http://nlp.stanford.edu/software/corenlp.shtml) software is a standalone Java implementation of the basic NLP pipeline that requires minimal code on the user's part (note: I tried it and was not particularly impressed). Or you could just wait for my next post. :)
