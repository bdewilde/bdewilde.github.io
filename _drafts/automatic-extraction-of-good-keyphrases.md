---
layout: post
title: Automatic Keyphrase Extraction
date: 2014-09-16 11:16:00
categories: [blog]
tags: [feature design, frequency statistics, keyphrase extraction, graph-based ranking, NLP, task reformulation]
comments: true
preview_pic: /assets/images/document_as_network.png
---

I often apply natural language processing for purposes of automatically extracting structured information from unstructured (text) datasets. One such task is the extraction of important topical words and phrases from documents, commonly known as [terminology extraction](http://en.wikipedia.org/wiki/Terminology_extraction) or __automatic keyphrase extraction__. Keyphrases provide a concise description of a document's content; they are useful for document categorization, clustering, indexing, search, and summarization; quantifying semantic similarity with other documents; as well as conceptualizing particular knowledge domains.

<figure>
  <img class="halfw" src="/assets/images/keyphrase_extraction.png" alt="keyphrase_extraction.png">
</figure>

Despite wide applicability and much research, keyphrase extraction suffers from poor performance relative to many other core NLP tasks, partly because there's no objectively "correct" set of keyphrases for a given document. While human-labeled keyphrases are generally considered to be the gold standard, humans disagree about what that standard is! As a general rule of thumb, keyphrases should be relevant to one or more of a document's major topics, and the set of keyphrases describing a document should provide good coverage of all major topics. (They should also be understandable and grammatical, of course.) The fundamental difficulty lies in determining which keyphrases are the _most_ relevant and provide the _best_ coverage. As described in [Automatic Keyphrase Extraction: A Survey of the State of the Art](http://www.hlt.utdallas.edu/~saidul/acl14.pdf), several factors contribute to this difficulty, including document length, structural inconsistency, changes in topic, and (a lack of) correlations between topics.

### Methodology

Automatic keyphrase extraction is typically a two-step process: first, a set of words and phrases that could convey the topical content of a document are identified, then these candidates are scored/ranked and the "best" are selected as a document's keyphrases.

#### 1. Candidate Identification

A brute-force method might consider _all_ words and/or phrases in a document as candidate keyphrases. However, given computational costs and the fact that not all words and phrases in a document are equally likely to convey its content, heuristics are typically used to identify a smaller subset of better candidates. Common heuristics include removing [stop words](http://en.wikipedia.org/wiki/Stop_words) and punctuation; filtering for words with certain parts of speech or, for multi-word phrases, certain POS patterns; and using external knowledge bases like [WordNet](http://wordnet.princeton.edu/) or Wikipedia as a reference source of good/bad keyphrases.

For example, rather than taking all of the [_n_-grams](http://en.wikipedia.org/wiki/N-gram) (where 1 ≤ _n_ ≤ 5) in this post's first two paragraphs as candidates, we might limit ourselves to only noun phrases matching the POS pattern `{(<JJ>* <NN.*>+ <IN>)? <JJ>* <NN.*>+}` (a regular expression written in a simplified format used by [NLTK](http://www.nltk.org/)'s `RegexpParser()`). This matches any number of adjectives followed by at least one noun that may be joined by a preposition to one other adjective(s)+noun(s) sequence, and results in the following candidates:

```
['art', automatic keyphrase extraction', 'changes in topic', 'concise description',
'content', 'coverage', 'difficulty', 'document', 'document categorization',
'document length', 'extraction of important topical words', 'fundamental difficulty',
'general rule of thumb', 'gold standard', 'good coverage', 'human-labeled keyphrases',
'humans', 'indexing', 'keyphrases', 'major topics', 'many other core nlp tasks',
'much research', 'natural language processing for purposes', 'particular knowledge domains',
'phrases from documents', 'search', 'semantic similarity with other documents',
'set of keyphrases', 'several factors', 'state', 'structural inconsistency',
'summarization', 'survey', 'terminology extraction', 'topics', 'wide applicability', 'work']
```

Compared to the brute force result, which gives 1100+ candidate _n_-grams, most of which are almost certainly not keyphrases (e.g. "task", "relative to", "and the set", "survey of the state", ...), this seems like a much smaller and more likely set of candidates, right? As document length increases, though, even the number of _likely_ candidates can get quite large. Selecting the best keyphrase candidates is the objective of step 2.

#### 2. Keyphrase Selection

Researchers have devised a plethora of methods for distinguishing between good and bad (or _better_ and _worse_) keyphrase candidates. The simplest rely solely on __frequency statistics__, such as [TF*IDF](http://en.wikipedia.org/wiki/Tf%E2%80%93idf) or [BM25](http://en.wikipedia.org/wiki/Okapi_BM25), to score candidates, assuming that a document's keyphrases tend to be relatively frequent within the document as compared to an external reference corpus. Unfortunately, their performance is mediocre; researchers have demonstrated that the best keyphrases aren't necessarily the most frequent within a document. (For a statistical analysis of human-generated keyphrases, check out [Descriptive Keyphrases for Text Visualization](http://vis.stanford.edu/papers/keyphrases).) A next attempt might score candidates using multiple statistical features combined in an ad hoc or heuristic manner, but this approach only goes so far. More sophisticated methods apply machine learning to the problem. They fall into two broad categories.

##### Unsupervised

Unsupervised machine learning methods attempt to discover the underlying structure of a dataset without the assistance of already-labeled examples ("training data"). The canonical unsupervised approach to automatic keyphrase extraction uses a __graph-based ranking__ method, in which the importance of a candidate is determined by its relatedness to other candidates, where "relatedness" may be measured by two terms' frequency of co-occurrence or [semantic relatedness](http://en.wikipedia.org/wiki/Semantic_similarity). This method assumes that more important candidates are related to a greater number of other candidates, and that more of those related candidates are _also_ considered important; it does not, however, ensure that selected keyphrases cover all major topics, although multiple variations try to compensate for this weakness.

Essentially, a document is represented as a network whose nodes are candidate keyphrases (typically only key _words_) and whose edges (optionally weighted by the _degree_ of relatedness) connect related candidates. Then, a [graph-based ranking algorithm](http://networkx.github.io/documentation/networkx-1.9/reference/algorithms.centrality.html), such as Google's famous [PageRank](http://en.wikipedia.org/wiki/PageRank), is run over the network, and the highest-scoring terms are taken to be the document's keyphrases.

<figure>
  <img class="tqw" src="/assets/images/document_as_network.png" alt="document_as_network.png">
</figure>

The most famous instantiation of this approach is [TextRank](http://web.eecs.umich.edu/~mihalcea/papers/mihalcea.emnlp04.pdf); a variation that attempts to ensure good topic coverage is [DivRank](http://clair.si.umich.edu/~radev/papers/SIGKDD2010.pdf). For a more extensive breakdown, see [Conundrums in Unsupervised Keyphrase Extraction](http://www.hlt.utdallas.edu/~vince/papers/coling10-keyphrase.pdf), which includes an example of a __topic-based clustering__ method, the other main class of unsupervised keyphrase extraction algorithms (which I'm not going to delve into).

Unsupervised approaches have at least one notable strength: No training data required! In an age of massive but unlabled datasets, this can be a huge advantage over other approaches. As for disadvantages, unsupervised methods make assumptions that don't necessarily hold across different domains, and up until recently, their performance has been inferior to supervised methods. Which brings me to the next section.

##### Supervised

Supervised machine learning methods use training data to infer a function that maps a set of input variables called features to some desired (and _known_) output value; ideally, this function can correctly predict the (_unknown_) output values of new examples based on their features alone. The two primary developments in supervised approaches to automatic keyphrase extraction deal with __task reformulation__ and __feature design__.

Early implementations recast the problem of extracting keyphrases from a document as a __binary classification__ problem, in which some fraction of candidates are classified as keyphrases and the rest as _non_-keyphrases. This is a well-understood problem, and there are many methods to solve it: [Naive Bayes](http://scikit-learn.org/stable/modules/naive_bayes.html), [decision trees](http://scikit-learn.org/stable/modules/tree.html), and [support vector machines](http://scikit-learn.org/stable/modules/svm.html), among others. However, this reformulation of the task is conceptually problematic; humans don't judge keyphrases independently of one another, instead they judge certain phrases as _more key_ than others in a intrinsically relative sense. As such, more recently the problem has been reformulated as a __ranking__ problem, in which a function is trained to rank candidates pairwise according to degree of "keyness". The best candidates rise to the top, and the top _N_ are taken to be the document's keyphrases.

The second line of research into supervised approaches has explored a wide variety of features used to discriminate between keyphrases and non-keyphrases. The most common are the aforementioned frequency statistics, along with a grab-bag of other __statistical features__: phrase length (number of constituent words), phrase position (normalized position within a document of first and/or last occurrence therein), and "supervised keyphraseness" (number of times a keyphrase appears as such in the training data). Some models take advantage of a document's __structural features__ --- titles, abstracts, intros and conclusions, metadata, and so on --- because a candidate is more likely to be a keyphrase if it appears in notable sections. Others are __external resource-based features__: "Wikipedia-based keyphraseness" assumes that keyphrases are more likely to appear as Wiki article links and/or titles, while phrase commonness compares a candidate's frequency in a document with respect to its frequency in an external corpus. The list of possible features goes on and on.

<figure>
  <img class="fullw" src="/assets/images/keyphrase_extraction_features.png" alt="keyphrase_extraction_features.png">
</figure>

A well-known implementation of the binary classification method, [KEA](http://www.nzdl.org/Kea/) (as published in [Practical Automatic Keyphrase Extraction](http://www.nzdl.org/Kea/Nevill-et-al-1999-DL99-poster.pdf)), used TF*IDF and position of first occurrence (while filtering on phrase length) to identify keyphrases. In [A Ranking Approach to Keyphrase Extraction](http://research.microsoft.com/en-us/people/hangli/jiang-etal-sigir2009-poster.pdf), researchers used a Linear Ranking SVM to rank candidate keyphrases with much success (but failed to give their algorithm a catchy name).

Supervised approaches have generally achieved better performance than unsupervised approaches; however, good training data is hard to find (although here's [a decent place to start](https://github.com/snkim/AutomaticKeyphraseExtraction)), and the danger of training a model that doesn't generalize to unseen examples is something to always guard against (e.g. through [cross-validation](http://en.wikipedia.org/wiki/Cross-validation_(statistics))).

### Results

Okay, now that I've scared/bored away all but the truly interested, let's dig into some code and results! As an example document, I'll use all of the text in this post _up to_ this results section; as a reference corpus, I'll use all other posts on this blog. In principle, a reference corpus isn't necessary for single-document keyphrase extraction, but it's generally helpful to compare a document's candidates against other documents' to characterize its particular content. Consider that _tf*idf_ reduces to just _tf_ (term frequency) in the case of a single document since _idf_ (inverse document frequency) is the same value for every candidate.

As mentioned, there are many ways to extract candidate keyphrases from a document; here's a simplified and compact implementation of the "noun phrases only" heuristic method:

{% highlight python %}
def extract_candidate_chunks(text, grammar=r'KT: {(<JJ>* <NN.*>+ <IN>)? <JJ>* <NN.*>+}'):

    import itertools, nltk

    chunker = nltk.chunk.regexp.RegexpParser(grammar)
    tagged_sents = nltk.pos_tag_sents(nltk.word_tokenize(sent) for sent in nltk.sent_tokenize(text))
    all_chunks = list(itertools.chain.from_iterable(nltk.chunk.tree2conlltags(chunker.parse(tagged_sent))
                                                    for tagged_sent in tagged_sents))
    candidates = [' '.join(word for word, pos, chunk in group).lower()
                  for key, group in itertools.groupby(all_chunks, lambda (word,pos,chunk): chunk != 'O') if key]

    return candidates
{% endhighlight %}

When `text` is assigned to the first two paragraphs of this post, `set(candidates)` is more or less the same as the candidate keyphrases listed in <a href="#candidate-identification">1. Candidate Identification</a>. (Additional cleaning and filtering code improves the list a bit and helps to makes up for tokenizing/tagging/chunking errors.) For comparison, the original TextRank algorithm performs best when extracting all (unigram) nouns and adjectives, like so:

{% highlight python %}
def extract_candidate_words(text, good_tags=set(['JJ','JJR','JJS','NN','NNP','NNS','NNPS'])):
    import itertools, nltk

    tagged_words = itertools.chain.from_iterable(nltk.pos_tag_sents(nltk.word_tokenize(sent)
                                                                    for sent in nltk.sent_tokenize(text)))
    candidates = [word.lower() for word, tag in tagged_words if tag in good_tags]

    return candidates
{% endhighlight %}

In this case, `set(candidates)` is more or less equivalent to the set of words visualized as a network in the <a href="#unsupervised">sub-section on unsupervised methods</a>.

Code for keyphrase selection depends entirely on the approach taken, of course. The simplest, frequency statistic-based approach can be coded easily using [scikit-learn](http://scikit-learn.org/stable/) or [gensim](http://radimrehurek.com/gensim/):



























