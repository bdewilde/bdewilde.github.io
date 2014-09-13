---
layout: post
title: Automatic Extraction of Good Keyphrases
date: 2014-09-13 11:16:00
categories: [blog]
tags: [keyphrase extraction]
comments: true
preview_pic: 
---

- Background/Context
    + definition
    + difficulty
    + methodology overview
- Example approaches
    + unsupervised
        * graph-based (TextRank, ...)
    + supervised
        * classification
        * ranking
- Results
    + this blog post
    + Friedman corpus
    + Pitchfork album reviews

In my work, I most often apply natural language processing for purposes of automatically extracting structured information from unstructured (text) datasets. Within this domain, a common but difficult task is the extraction of important topical phrases from one or many documents, most commonly known as [terminology extraction](http://en.wikipedia.org/wiki/Terminology_extraction) or __automatic keyphrase extraction__. Keyphrases give a concise description of a document's contents; they are useful for document categorization, clustering, indexing, search, and summarization; quantifying semantic similarity with other documents; as well as conceptualizing particular knowledge domains.

Despite wide applicability and much research, keyphrase extraction suffers from poor performance relative to many other core NLP tasks, such as POS-tagging, if only because there's no objectively "correct" set of keyphrases for a given document --- different readers may have different but no less valid interpretations. As described in [Automatic Keyphrase Extraction: A Survey of the State of the Art](http://www.hlt.utdallas.edu/~saidul/acl14.pdf), several other factors contribute to the difficulty of keyphrase extraction, including document length, structural inconsistency, changes in topic, and correlations (or lack thereof) between topics.

Keyphrase extraction is usually a two-step process:

1. __candidate identification:__ Not all words and phrases in a document are equally likely to convey its content.
2. __candidate selection:__ Supervised vs unsupervised.


































