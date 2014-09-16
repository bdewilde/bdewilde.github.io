---
layout: post
title: Automatic Keyphrase Extraction
date: 2014-09-16 11:16:00
categories: [blog]
tags: [feature design, frequency statistics, keyphrase extraction, graph-based ranking, NLP, task reformulation]
comments: true
preview_pic: 
---

In my work, I most often apply natural language processing for purposes of automatically extracting structured information from unstructured (text) datasets. One such task is the extraction of important topical words and phrases from documents, commonly known as [terminology extraction](http://en.wikipedia.org/wiki/Terminology_extraction) or __automatic keyphrase extraction__. Keyphrases provide a concise description of a document's content; they are useful for document categorization, clustering, indexing, search, and summarization; quantifying semantic similarity with other documents; as well as conceptualizing particular knowledge domains.

Despite wide applicability and much research, keyphrase extraction suffers from poor performance relative to many other core NLP tasks, partly because there's no objectively "correct" set of keyphrases for a given document. While human-labeled keyphrases are generally considered to be the gold standard, humans disagree about what that standard is! As a general rule of thumb, keyphrases should be relevant to one or more of a document's major topics, and the set of keyphrases describing a document should provide good coverage of all major topics. (They should also be understandable and grammatical, of course.) The fundamental difficulty lies in determining which keyphrases are the _most_ relevant and provide the _best_ coverage. As described in [Automatic Keyphrase Extraction: A Survey of the State of the Art](http://www.hlt.utdallas.edu/~saidul/acl14.pdf), several factors contribute to this difficulty, including document length, structural inconsistency, changes in topic, and (a lack of) correlations between topics.

### Methodology

Automatic keyphrase extraction is typically a two-step process.

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

Looks like a small, decent set of candidates, right? As document length increases, though, the number of candidates can still get quite large. Selecting the best keyphrase candidates is the objective of step 2.

#### 2. Keyphrase Selection

Researchers have devised a plethora of methods for distinguishing between good and bad (or _better_ and _worse_) keyphrase candidates. The simplest rely solely on __frequency statistics__, such as [TF-IDF](http://en.wikipedia.org/wiki/Tf%E2%80%93idf) or [BM25](http://en.wikipedia.org/wiki/Okapi_BM25), to score candidates, assuming that a document's keyphrases tend to be relatively frequent within the document as compared to an external reference corpus. Unfortunately, their performance is mediocre; researchers have demonstrated that the best keyphrases aren't necessarily the most frequent within a document. (For a statistical analysis of human-generated keyphrases, check out [Descriptive Keyphrases for Text Visualization](http://vis.stanford.edu/papers/keyphrases).) More sophisticated methods apply machine learning to the problem, and fall into two broad categories.

##### Unsupervised

The canonical unsupervised approach to automatic keyphrase extraction uses a __graph-based ranking__ method, in which the importance of a candidate is determined by its relatedness to other candidates, where "relatedness" may be measured by two terms' frequency of co-occurrence or [semantic relatedness](http://en.wikipedia.org/wiki/Semantic_similarity). This method assumes that more important candidates are related to a greater number of other candidates, and that more of those related candidates are _also_ considered important; it does not, however, ensure that selected keyphrases cover all major topics, although multiple variations try to compensate for this weakness.

Essentially, a document is represented as a network whose nodes are candidate keyphrases (typically only key _words_) and whose edges (optionally weighted by the _degree_ of relatedness) connect related candidates. Then, a graph-based ranking algorithm, such as Google's famous [PageRank](http://en.wikipedia.org/wiki/PageRank), is run over the network, and the highest-scoring terms are taken to be the document's keyphrases.

[INSERT IMAGE OF DOCUMENT-AS-NETWORK]

The most famous instantiation of this approach is [TextRank](http://web.eecs.umich.edu/~mihalcea/papers/mihalcea.emnlp04.pdf); a variation that attempts to ensure good topic coverage is [DivRank](http://clair.si.umich.edu/~radev/papers/SIGKDD2010.pdf). For a more extensive breakdown, see [Conundrums in Unsupervised Keyphrase Extraction](http://www.hlt.utdallas.edu/~vince/papers/coling10-keyphrase.pdf), which includes an example of a __topic-based clustering__ method, the other main class of unsupervised keyphrase extraction algorithms.

Unsupervised approaches have at least one notable advantage: No training data required! In an age of massive, unlabled, readily-available datasets, this is a big deal. As for disadvantages, unsupervised methods make assumptions that don't necessarily hold across different domains, and up until recently, their performance has been inferior to supervised methods. Which brings me to the next section.

##### Supervised

The two main components of supervised approaches to automatic keyphrase extraction are __task reformulation__ and __feature design__.

### Results
































