.. _gp_metamodel:

================================================================================
Gaussian Process Metamodeling: Emulating Code Input/Output for Faster Evaluation
================================================================================

This chapter provides an overview of computer simulation metamodeling based on Gaussian stochastic process,
the main idea behind it and practical aspects of it.
The chapter also seeks to demonstrate the application of such an approach to metamodeling of a reflood facility model in TRACE.
The Gaussian process metamodeling This

Inn :ref:`gp_fundamentals` gives an overview of the fundamental ideas behind and some important properties of Gaussian stochastic process.
This will be done especially through its relation to the more familiar multivariate Gaussian random variable.
In :ref:`gp_metamodeling` metamodeling approach based on Gaussian stochastic process, known as the *Kriging* model is presented.
The practical aspects of constructing a Gaussian process metamodel, namely the design of experiment, model fitting, and its validation strategy are presented in :ref:`gp_construction`.
In :ref:`gp_simple_problem` those aspects are illustrated by constructing a metamodel of a simple problem.
Before moving on to the application to a model in TRACE, some ideas on how to deal with high-dimensional output is presented in :ref:`gp_dimension_reduction`.
Finally metamodeling of a reflood facility model in TRACE is presented in :ref:`gp_trace` and :ref:`gp_summary` summarizes the Chapter.

.. toctree::
   :maxdepth: 2
   :caption: Gaussian Process:
   
   fundamentals
   metamodeling
   constructing_gp_metamodel
   simple_problem
   dimension_reduction
   gp_trace
   chapter_summary
