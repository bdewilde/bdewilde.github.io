---
layout: post
title: Classification of Hand-written Digits (1)
date: 2012-10-14 13:09:00
categories: [blog, blogger]
tags: [classification, hand-written digits, iris dataset, Kaggle, MINST, spam email filtering, supervised learning]
comments: true
preview_pic: /assets/images/2012-10-14-digit-to-pixels.png
---

In the last few posts, I've attempted to lay a basic foundation explaining what data science is generally about; in the next few posts, I'd like to delve deeper into a specific example.

### Classification

A common and important task in machine learning is [classification](http://en.wikipedia.org/wiki/Statistical_classification): given a new observation, determine the category to which it belongs by comparing it to known examples of those categories. A familiar case is spam email filtering, where a new email is classified as spam or non-spam based on its contents. Specifically, an email that has words such as "male enhancement" or "fast cash," a subject line in all caps, web links with shady domain names, a high ratio of images to text, etc. will likely be classified as spam.

<figure>
  <img class="tqw" src="/assets/images/2012-10-14-spam-email.png" alt="2012-10-14-spam-email.png">
  <figcaption>Example email from my inbox, correctly classified as spam.</figcaption>
</figure>

Another classic example is Fisher's [iris data set](http://en.wikipedia.org/wiki/Iris_flower_data_set), in which three species of iris — _setosa_, _versicolor_, and _virginica_ — are characterized by the length and width in centimeters of their [petals and sepals](http://en.wikipedia.org/wiki/File:Petal-sepal.jpg). (Note: This data set comes with R, just type `iris` at the prompt!) Upon finding an unknown iris, a botanist might like to classify it as a member of the appropriate species based on measurements of its petals and sepals. Well, as it turns out, only one of the species (setosa, in orange below) is simply distinguishable from the other two (versicolor in cyan and virginica in violet), resulting in a non-trivial challenge for classification algorithms.

<figure>
  <img class="tqw" src="/assets/images/2012-10-14-iris-dataset.png" alt="2012-10-14-iris-dataset.png">
  <figcaption>Pair-wise scatter plots of the four attributes distinguishing three iris species.</figcaption>
</figure>

In the terminology of machine learning, such discriminating attributes are called _features_, and an algorithm that implements classification (such as the spam filter) is called a _classifier_. Classification itself is an example of [supervised learning](http://en.wikipedia.org/wiki/Supervised_learning), in which new observations (e.g. incoming emails) are compared to an existing set of already-classified observations called a _training set_. In general, each observation is characterized by a set of features and, for those belonging to the training set, the class to which it belongs. The end goal of the classifier, then, is to take a _feature vector_ as input and produce an accurate prediction for the corresponding class as output.

To accomplish this, the classifier creates an internal representation of the relationship between features and classes — a statistical _model_. When exposed to training examples for which the actual classes are known, the classifier modifies its model such that its prediction accuracy is maximized; up to a point, more training examples makes for more accurate predictions. After training, the classifier's predictive ability should generalize to new observations for which the class is not known. This process of learning by example is the essence of supervised learning; I'll explore some of the learning algorithms used to train a model in upcoming posts.

[For context: [Regression](http://en.wikipedia.org/wiki/Regression_analysis) is a closely related supervised learning task in which the outputs are _continuous/quantitative_ rather than _discrete/qualitative_; [clustering](http://en.wikipedia.org/wiki/Data_clustering) is the _un_supervised version of this task, in which sets of new observations are split into like groups without guidance from already-known classes.]
<!--more-->

### Hand-written digits

Another classic classification problem is identifying digits from images of individual hand-written digits. According to legend, the United States Postal Service first tackled this problem in order to automagically sort mail by zip code, saving much time and money; nowadays, this heavily-studied problem serves as a "Getting Started" [competition on Kaggle](http://www.kaggle.com/c/digit-recognizer), so the data have been nicely prepared for us. :)

The data come from the Modified National Institute of Standards and Technology (MNIST) [database](http://yann.lecun.com/exdb/mnist/index.html). Each instance is a square gray-scale image, 28 x 28 pixels in size (for a total of 784 pixels), of a single, centered, hand-written digit in the range 0 to 9. Like this:

<figure>
  <img class="tqw" src="/assets/images/2012-10-14-digit-to-pixels.png" alt="2012-10-14-digit-to-pixels.png">
  <figcaption>Left: Example image of a hand-written "6." Right: Numbering of pixels in the image.</figcaption>
</figure>

Each pixel has an integer value associated with it indicating brightness, from 0 (white) to 255 (black). For convenience, each digit is stored as one row in a table, with 784 columns corresponding to the pixels in the image; in the training set, an additional first column indicates the actual value of the digit (its class). Like this:

<figure>
  <img class="fullw" src="/assets/images/2012-10-14-digit-feature-vector.png" alt="2012-10-14-digit-feature-vector.png">
  <figcaption>Training example of a hand-written "6," represented as a single row in a table.</figcaption>
</figure>

The training data set contains 42,000 digits — it's a table of 42,000 x 785 elements. In the next few posts, I'll explain the basics of some different learning algorithms, implement and train them, then show how well they perform at classifying unknown hand-written digits.
