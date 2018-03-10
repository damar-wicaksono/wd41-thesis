.. _gp_fundamentals:

=============================
Gaussian Process Fundamentals
=============================

Multivariate Random Variable
=============================

A collection of finite :math:`D` continuous random variables :math:`\underline{X} = [X_1, X_2, X_3, ..., X_D] \in \xi`

.. math::

    P(\underline{X} \in B)

Furthermore, the joint density function is also required to sum up to 1.0 over the whole domain for it to be a valid probability density function.
In other words, the probability of X belongs to the domain is by definition 1.0, or 

The type of random variables considered in this study is restricted to continuous random variable and the term probability is often used referring to both *probability density* and *probability mass*. 
When the distinction is required, the notations used are :math:`p` and :math:`\mathbb{P}` for density and probability, respectively. 
Additionaly, the density function of random vector X written as :math:`p_X (x)` is shortened simply to as it is often clear from the context.

Multivariate Gaussian (Normal) Random Variable
==============================================

Multivariate Gaussian (Normal) random variable is the most widely studied and applied multivariate random variable. There are several reasons for this. From a practical point of view, the distribution of multivariate Gaussian random variable is tractable and its special properties are well known [47]. From an epistemological point of view, because modelling multivariate data using multivariate Gaussian distribution implies that the mean and covariance fully characterize the data, only these two parameters are of interest. Furthermore any dependence structure within the data can sufficiently be described linearly through the notion of statistical correlation [48]

Gaussian Stochastic Process
===========================

Covariance Kernel Functions
===========================

Multidimensional Kernel Construction
------------------------------------

Process Variance
----------------

Mean Function
=============


