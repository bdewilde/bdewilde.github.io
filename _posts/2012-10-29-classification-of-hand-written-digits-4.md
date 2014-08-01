---
layout: post
title: Classification of Hand-written Digits (4)
date: 2012-10-29 18:11:00
categories: [blog, blogger]
tags: [classification, cross-validation, hand-written digits, Kaggle, kNN, R]
comments: true
preview_pic: /assets/images/2012-10-29-knn-performance-vs-kAndKernel-10kSet.png
---

In my previous posts ([Part 1]({% post_url 2012-10-14-classification-of-hand-written-digits-1 %}) \| [Part 2]({% post_url 2012-10-17-classification-of-hand-written-digits-2 %}) \| [Part 3]({% post_url 2012-10-26-classification-of-hand-written-digits-3 %})), I described the _k_-nearest neighbors algorithm, applied a benchmark model to the classification of hand-written digits, then chose an optimal value for _k_ as the one that minimized the model's prediction error on a dedicated validation data set. I also excluded about 2/3 of the features (image pixels) from the model because they had near-zero variance, thereby improving both performance and runtime. Now, I'd like to add one last complication to the kNN model: _weighting_.

Recall that an unlabeled observation is assigned a class by a majority vote of its _k_ nearest neighbors; the most common class among the neighbors wins. In the simplest case, each neighbor's vote counts exactly the same. How democratic! However, what if you wanted to give more weight to the votes of neighbors that are closer to the unlabeled observation than those that are farther away? [Insert commentary on political corruption, lobbyists.] As it turns out, this is easily accomplished by means of a _distance metric_ in a weighted kNN model, where neighbors in the training set are given more or less weight according to their distance from the unlabeled observation.

Up til now, I've used the simple [Euclidean distance](http://en.wikipedia.org/wiki/Euclidean_distance), which is essentially the straight line segment connecting two points, say, $p$ and $q$. Symbolically:

$$\begin{array}{lcl}
1-\text{dim} &=& \sqrt{(p - q)^2} \\
2-\text{dim} &=& \sqrt{(p_1 - q_1)^2 + (p_2 - q_2)^2} \\
n-\text{dim} &=& \sqrt{\sum^{n}_{i=1}(p_i - q_i)^2}
\end{array}$$

The 2-dimensional case should look familiar (think: _Pythagorean theorem_). In the parlance of non-parametric statistics, Euclidean distance corresponds to a uniform (or _rectangular_) [kernel](http://en.wikipedia.org/wiki/Kernel_(statistics)). [Technical note: kNN is a _non-parametric_ learning algorithm, meaning that it makes no assumptions about the underlying distribution of the data. Contrast this with, say, a [generalized linear model](http://en.wikipedia.org/wiki/Generalized_linear_model).] However, this isn't the only option! We can use a _triangular_ kernel, where the weight assigned to a neighbor decreases linearly with the distance from the test observation; Gaussian kernel, where the weighting function follows a Gaussian distribution; or many others. Here's a nice plot from Wikipedia that overlays a variety of kernels:

<figure>
  <img class="halfw" src="/assets/images/2012-10-29-kernels.png" alt="2012-10-29-kernels.png">
</figure>

Okay! Now I would like to optimize a kNN model for both the number of neighbors _and_ the kernel weighting function. To do this, I use a different package in R —-- [kknn](http://cran.r-project.org/web/packages/kknn/index.html) --— since the one I used last time —-- the [FNN](http://cran.r-project.org/web/packages/FNN/index.html) package —-- has a rectangular kernel only. The kknn package implements _leave-one-out_ cross-validation, in which a model is trained on all but one example in the training set, tested on that one validation example, then repeated such that each example acts as the validation example once. Here's the code:

{% highlight r %}
# weighted k-nearest neighbors package
library(kknn)
 
# load the training data set
train <- read.csv("train.csv", header=TRUE)
 
# remove near-zero variance features
library(caret)
badCols <- nearZeroVar(train[, -1])
train <- train[, -(badCols+1)]
 
# optimize knn for k=1:15
# and kernel=triangular, rectangular, or gaussian
model <- train.kknn(as.factor(label) ~ ., train, kmax=15, kernel=c("triangular","rectangular","gaussian"))
 
# print out best parameters and prediction error
print(paste("Best parameters:", "kernel =", model$best.parameters$kernel, ", k =", model$best.parameters$k))
print(model$MISCLASS)
{% endhighlight %}
<!--more-->

And here's the resulting plot:

<figure>
  <img class="tqw" src="/assets/images/2012-10-29-knn-performance-vs-kAndKernel-10kSet.png" alt="2012-10-29-knn-performance-vs-kAndKernel-10kSet.png">
</figure>

Models corresponding to the solid lines use _all_ features in the training data, while those corresponding to the dashed lines use a reduced set _without_ the near-zero variance features. The best models of both sets are marked by a black symbol. What do we see? Models trained on a reduced feature set perform significantly better than those trained on all features. (They also run faster!) Models with a triangular kernel perform better than those with rectangular or gaussian kernels. The _best_ kNN model uses a triangular kernel, excludes near-zero variance features, and has _k_ = 9, which we implement and run over the test data set like so:

{% highlight r %}
# load test datasets
test <- read.csv("test.csv", header=TRUE)
 
# train the optimal kknn model
model <- kknn(as.factor(label) ~ ., train, test, k=9, kernel="triangular")
results <- model$fitted.values
 
# save the class predictions in a column vector
write(as.numeric(levels(results))[results], file="kknn_submission.csv", ncolumns=1)
{% endhighlight %}

As before, [Kaggle](http://www.kaggle.com/) uses prediction error to assess the model's performance — so how does this one do? _Much better!_

<figure>
  <img class="fullw" src="/assets/images/2012-10-29-ranking-best-knn.png" alt="2012-10-29-ranking-best-knn.png">
</figure>

Clearly, optimizing your statistical model pays off!

Although _k_-nearest neighbors is a straightforward and surprisingly powerful machine learning technique, other options out there easily outperform it. I'm going to take a break on the hand-written digits problem for now, but maybe I'll come back to it wielding more powerful statistical tools... :)
