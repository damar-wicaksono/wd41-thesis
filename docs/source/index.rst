.. wd41-thesis documentation master file, created by
   sphinx-quickstart on Tue Mar 28 21:42:55 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Bayesian Uncertainty Quantification of Physical Model in Thermal-Hydraulics System Code
=======================================================================================

.. Context and Need

Nuclear thermal-hydraulics (TH) system code use several parametrized physical or empirical models to describe complex two-phase flow phenomena.
The reliability of their predictions is as such primarily affected by the uncertainty associated with the parameters of the models.
Because these model parameters often cannot be measured, nor have inherent physical meanings, their uncertainties are mostly based on expert judgment.

.. Goal

The present doctoral research aims to quantify the uncertainty of physical model parameters implemented in a TH system code based on experimental data.
Specifically, this thesis develops a methodology to use experimental data to inform these uncertainties in a more objective manner.
The methodology is based on a probabilistic framework and consists of three steps adapted from recent developments in applied statistics: global sensitivity analysis (GSA), metamodeling, and Bayesian calibration.

.. Introducing FEBA

The methodology is applied to reflood experiments from the FEBA separate effect test facility (SETF), which are modeled with the TH system code TRACE.
Reflood is chosen as a relevant phenomenon for the safety analysis of light water reactors (LWRs) and three typical time-dependent outputs are investigated: cladding temperature, pressure drops and liquid carryover.

.. First Step - Global Sensitivity Analysis

In the first step, GSA allows screening out input parameters that have a low impact on the reflood transient.
Functional data analysis (FDA) is then used to reduce the dimensionality of the time-dependent code outputs, while preserving their interpretability.
The resulting quantities can be used once more with \gls[hyper=false]{th} to investigate, quantitatively, the effect of the input parameters on the overall time-dependent outputs.

.. Second Step - Metamodeling

In the second step, a Gaussian process (GP) metamodel is developed and validated as a surrogate for the TRACE model.
The average prediction error of the metamodel is sufficient to predict all considered outputs, and its computational cost is less than :math:`5\,[s]` as compared to :math:`6-15\,[min]` per TRACE run.

.. Third Step - Calibration

In the final step, the a posteriori model parameter uncertainties are quantified by calibration on a selected test from the FEBA experiments.
Several posteriors probability density functions (PDFs) corresponding to different calibration schemes -- with and without model bias term and for different types of output -- are formulated and directly sampled using a Markov Chain Monte Carlo (MCMC) ensemble sampler and the GP metamodel.
The posterior samples are then propagated in a set of FEBA experiments to check the validity of the posterior model parameter values and uncertainties.

.. Final Step - Verification

The calibration is performed on different types of output to inform model parameters that would have otherwise remained non-identifiable.
The calibration scheme with model bias term is able to constrain the prior uncertainties of the model parameters while keeping the nominal TRACE parameters values within the posterior uncertainty interval.
That is in contrast with the results of the calibration without model bias term, in which the posterior uncertainties are concentrated on either sides of the prior range, and at times do not include the nominal TRACE parameters values.
Finally, except for a few outputs – the cladding temperature output at the top assembly and the liquid carryover – the relative performance of all posterior uncertainties is insensitive to boundary conditions of the different FEBA tests.

.. Conclusion and Outlook

The proposed methodology was shown to successfully inform the uncertainty of the model parameters involved in a reflood transient.
In the future the methodology can be applied to model parameters involved in other TH phenomena using data from SETFs and, hopefully, contributes to achieve the goal of quantifying uncertainties for transients considered in the safety assessment of LWRs.

**Keywords**:

 - system thermal-hydraulics (TH)
 - reflood
 - TRAC/RELAP Computational Engine (TRACE) code
 - uncertainty quantification (UQ)
 - global sensitivity analysis (GSA)
 - Gaussian process (GP) metamodel
 - Bayesian calibration

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   Uncertainty Quantification in Nuclear Engineering Thermal-Hydraulics <1_introduction/index.rst>
   2_trace_reflood/index.rst
   3_gsa/index.rst
   4_gp_regression/index.rst
   5_bayesian_calibration/index.rst
   zbibliography.rst
   glossary.rst
