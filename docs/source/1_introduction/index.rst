.. _introduction:

===============================================================
Quantifying Uncertainty of Computer Model: Forward and Backward
===============================================================

.. Introductory Paragraphs

.. epigraph::

   All models are wrong but some are useful.

   -- George Box

It is perhaps convenient to use the quote by Box -- at least half of it -- as an excuse if a modeling exercise goes awry.
But engineers are constructive bunch, as they are pragmatic, so they often focus on the second part of the statement and try to do better.
Some would argue that to make a model useful is to make a model less wrong, a very difficult task.
Some others would start by making an effort assessing whether the \``wrong\`` model is useful, can ever be useful, or can be made useful without any direct improvement to the model.
The two views are not contradictory, although the latter is arguably more humble.
This thesis is an effort in line with the latter view.

.. Second part of the introductory paragraph

By many measures, TH system codes for simulating system behavior of a nuclear power plant (NPP) are an achievement.
Their development, by the best and the brightest, includes decades of verification and validation activities supported by numerous experimental facilities, small and large scales.
Many of the current understanding of physical phenomena in NPP transient were established during that period.
Yet, their predictions can still be off when compared against experimental data.
The efforts to minimize this difference by developing high-fidelity physical models coupled with high-resolution numerical algorithms are always on-going and are indispensable for moving forward.

.. Third part of the introductory paragraph

At the same time, simulations are being continuously used to make decisions, from optimal system design to safety margin evaluation for reactor licensing.
For robust decision-making, it is important to acknowledge and determine the uncertainties associated with the predictions.
Thus, independently of the efforts to improve the code, uncertainty quantification of the code predictions is an important part of the code development; it is the main topic of this thesis.

.. Overview of the chapter

This opening chapter introduces briefly the importance and challenges of using system codes for simulating the TH behavior of NPP in the context of their safety analysis.
:ref:`intro_computer_simulation` starts with basic definitions of relevant terms used throughout the thesis before moving on to a brief introduction to safety analysis and TH system code.
Uncertainty analysis of TH system codes is first discussed in :ref:`intro_uq_in_ne_th`, outlining the background and the context of the doctoral research.

.. Objectives, Scope, and Statistical Framework

:ref:`intro_objectives_and_scope` then describes the statement of the problem, the objectives, and the scope of the research.
This thesis proposed a methodology comprised of sequential steps to analyze a computer model (i.e., TH system code) with the overall goal of quantifying the uncertainty associated with the model parameters based on experimental data.
It consolidates and adapts recent developments in the applied statistics literature.
In this context, :ref:`intro_statistical_framework` provides a broad, but by no means exhaustive, overview of the research landscape on each proposed steps.
Finally, :ref:`intro_thesis_structure` concludes the chapter by outlining the structure of the thesis.

.. toctree::
   :maxdepth: 2
   :caption: Introduction:
   
   computer_simulation
   uq_in_ne_th
   objectives_and_scope
   statistical_framework
   thesis_structure
