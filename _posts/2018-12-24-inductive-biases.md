---
layout: post
<!-- date: 2018-12-24 -->
comments: true
title: "Inductive biases"
published: false
---

## Note: This is still work in progress!

Deep Learning (DL) movement still heavily relies on statistical learning theory, which uses the principle of [Empirical Risk Minimization](https://en.wikipedia.org/wiki/Empirical_risk_minimization) with Maximimum Likelihood as an objective (in layman terms - opt for a model that better fits the data), and as a consequence we have powerful pattern recognizers!

https://sites.google.com/view/nips2018causallearning/home

<div style="text-align:center">
    <img src ="{{site.url}}/assets/inductive-biases/dexter-judea-pearl.jpg" width="50%" height="50%" />
    <figcaption>Dr. Judea Pearl - Prof. at UCLA, a known advocate of Causality theory and author of "The Book of Why". </figcaption>
</div>

<br>
Most of the Deep Learning (DL) movement is geared towards engineering **_inductive biases_** that capture statistical structure present in data to get better towards the objective.

**_What are inductive biases?_**

An inductive bias allows a learning algorithm to prioritize one solution (or interpretation) over another, independent of the observed data [1]


<div style="text-align:center">
    <img src ="{{site.url}}/assets/inductive-biases/inductive-bias-1.png" />
</div>

<br>
Since AutoML (or genetic evolution) are not there to help us given our short life span, encoding inductive biases forms an inevitable part of the job of the peeps working in today's ML environment -- which is equally empowering and sad at the same time :|

<div style="text-align:center">
    <img src ="{{site.url}}/assets/inductive-biases/man-god-1.png" />
</div>

While reading papers and keeping myself up-to-date with the recent advancements in DL, I usually come across different forms of “tricks” encoded in architecture, objective function, optimization algorithm - that just works and sometimes **_is_** the answer to research becoming successful.


But wait - is there a guide to such biases?

I believe in democratization of DL stack is on its right track with frameworks such as PyTorch, Keras, TF; but can we democratise the know-how of inductive biases in general?

I come from a Computer Vision background and will summarise some of the biases that just took off either
- To kill a dataset
- To make something work

### Ideas

- CNN:

<div style="text-align:center">
    <img src ="{{site.url}}/assets/inductive-biases/cnn-1.png" />
</div>

- My own experience regarding temporal footprint in video classification architectures!
- Graph Neural Networks - relational nets, attention nets, 
- FiLM
- VAE reparameterization trick, GANs loss manifold
- World models - multiple modes Gaussian for Future
- Dialog - Memory Nets?
- Object detection - anchor boxes 
- Uber's CoordConv
- Interpretable Intuitive Physics Model trick to get Physics vector?

- Data engineering:
  - Balancing in VQA?

## References
[1] Battaglia, Peter W., et al. "Relational inductive biases, deep learning, and graph networks." arXiv preprint arXiv:1806.01261 (2018).

{% include disqus.html %}