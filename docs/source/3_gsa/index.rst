.. _gsa:

=====================================================================================
Sensitivity Analysis: Understanding Model Input/Output Relationship under Uncertainty
=====================================================================================

Describing and understanding properly the impact of model parameters variations on the model prediction are an essential part of model development and assessment. 
Sensitivity analysis (SA) is an important methodological step in that context :cite:`Trucano2006`. 
SA is the process of investigating the role of input parameters in determining the model output :cite:`Iooss2015`. 
It seeks to quantify the importance of each model input parameter on the output.

Various classification esist in the literature to categorize SA techniques (**citation 3,4,5,6,7**).
In the review by Ionescu-Bujor and Cacuci (**citation 4,5**), 
SA techniques are classified with respect to their scope (local vs. global) and to their framework (deterministic vs. statistical).
In the review of SA methods by Iooss and Lemaître (**citation 7**), 
and the work by Saltelli et al. (**citation 6**) and by Santner et al. (**citation 8**), 
the statistical framework is implicitly assumed deriving ideas from design of experiment, 
and the classification is based on the parameter space of interest (local vs. global).

Local analysis is based on calculating the effect on the model output of small perturbations around a nominal parameter value. 
Often the perturbation is done one parameter at a time thus approximating the first-order partial derivative of the model output with respect to the perturbed parameter. 
The derivative can be computed through efficient adjoint formulation (**citation needed 9,10**) capable of handling large number of parameters.

Besides being numerically efficient, 
sensitivity coefficients obtained from local deterministic sensitivity analysis have the advantage of being intuitive in their interpretation, 
irrespective of the method employed (**citation 11**). 
The intuitiveness stems from the aforementioned equivalence to the derivative of the output with respect to each parameter (**citation 4**) around a specifically defined point (i.e., nominal parameter values). 
Thus the coefficients can be readily compared over different modelled systems, independently of the range of parameters variations.

The global analysis, on the other hand, 
seeks to explore the input parameters space across its range of variation 
and then quantify the input parameter importance based on a characterization of the resulting output surface. 
In global deterministic framework (**citation 4,10**), 
the characterization is aimed at the identification of the system’s critical points (e.g., maxima, minima, saddle points, etc.). 
In statistical global methods (**citation 6, 12, 13**), 
the characterization is aimed at measuring the dispersion of the output based on variance (**citation 14,15**), 
correlation (**citation 16**), or elementary effects (**citation 17**).

Due to the different characterizations, 
the global statistical framework can potentially give spurious results not comparable to the results from local method 
as there is no unique definition of sensitivity coefficient provided by different global methods (**citation 11**). 
In some cases, different methods can give different and inconsistent parameters importance ranking (**citation 6,12**). 
Furthermore, the result of the analysis can be highly dependent to the assumed input parameters probability distribution and/or their range of variation (**citation 5,10**).

Yet, despite the aforementioned shortcomings, 
the global statistical framework has three particular attractive features relevant to the present study. 
First, the statistical method for sensitivity analysis is non-intrusive in the sense that minimal or no modification to the original code is required. 
In other words, the code can be taken as a black box and the analysis is focused on the input/output relationship (**citation 6**) of the code. 
This is the case especially in comparison to adjoint-based sensitivity (**citation 18,19**) which is a highly efficient and accurate method applicable to a large number of parameters, 
provided that the code is designed/modified for adjoint analysis. 

Second, no a priori knowledge on the model structure (linearity, additivity, etc.) is required. 
Depending on the model complexity and as the parameter variation range can be large, 
the linearity or additivity assumption might not hold.

Third and finally, 
the choice of a statistical framework for sensitivity analysis fits the Monte Carlo (MC)-based uncertainty propagation method widely adopted in nuclear reactor evaluation models (**citation 20, 21, 22, 23**). 
The method prescribes that the uncertain model input and parameters (modeled as random variables) 
should be simultaneously and randomly perturbed across their range of variations. 
Multiple randomly generated input values are then propagated through the code to quantify the dispersion of the prediction (e.g., peak cladding temperature) 
which serves as a measure of the prediction reliability. 
Statistical global sensitivity analysis thus complements the propagation step 
by addressing the follow-up question on the identification of the most important parameters in driving the prediction uncertainty. 

Saltelli et al. (**citation 13**) emphasized that an analysis using computer simulation 
should be focused on the specific question the simulation is required to answer 
as opposed to the analysis of each and every individual model output. 
This is done through judicious choice of representative quantity of interest (QoI) 
that properly substantiates the problem at hand. 
In particular, computer code output often comes in a form of time series. 
In such case, Saltelli et al. (**citation 6,12**) proposed to derive the relevant QoI from time-dependent output 
using a predefined scalar function such as the maximum, the minimum, the average, etc. that fits the initial question.

However, in some cases, the whole course of a transient is of primary interest 
such as in assessing the ability of a model to reproduce the overall dynamics of the simulated system. 
If the attention is focused on the overall change in shape of the time-dependent output (a shift in the Y-axis, a delay, a distortion, etc.), 
the descriptions provided by the aforementioned scalar functions might be incomplete and overlook important features of the variation. 
To tackle this problem, Campbell et al. (**citation 24**) proposed to represent the functional (time-dependent) output in a certain basis function expansion 
and to carry out the sensitivity analysis on the coefficients of the expansion. 
In accordance to such approach, Functional Data Analysis (FDA) popularized by Ramsay and Silverman (**citation 25**) 
can be useful to reduce the high dimensionality of time-dependent output.

Despite these recent developments, 
there are very few publications on the application of global sensitivity analysis to nuclear thermal-hydraulics evaluation models specifically dealing with time-dependent output.
Notable recent examples related of sensitivity analysis for a time-dependent thermal-hydraulics (TH) problem were the work done by Ionescu-Bujor et al. (**citation 26**) 
for reflooding experiment of degraded fuel rods, utilizing adjoint sensitivity method; 
by Auder et al. (**citation 27**) for pressurized thermal shock analysis, 
utilizing statistical method with emphasis on metamodeling; 
and by Prošek and Leskovar (**citation 28**) for Large Break Loss-of-Coolant-Accident (LBLOCA) analysis, 
utilizing Fast Fourier Transform-Based method (FFTBM) and local sensitivity analysis.

This chapter introduces a methodology for investigating the effect of parameter variatiaon acrrois their range of variation on the time-dependent output.
The method takes into account the overall variation of the time-dependent output. 
It is developed strictly based on global statistical framework to benefit from the aforementioned advantages.

The methodology proposed leverages various developments in global sensitivity analysis and FDA methods. 
The methodology follows three key underlying ideas. 
First is to reduce the dimensionality of the output space utilizing techniques derived from FDA (**citation 25**). 
Second is to reduce the dimensionality of the input parameters space through screening analysis using the Morris method (**citation 17,29**). 
Third and finally is to investigate, quantitatively and in more detail, the effect of parameters variation across their range of variation on the overall time-dependent output variation. 
This was done through variance-based sensitivity analysis using the Sobol’-Saltelli method (**citation 14,30**). 

.. toctree::
   :maxdepth: 2
   :caption: This chapter contains the following Section:
   
   parameters_screening
   variance_decomposition
   time_dependent_variation
   implementation
   application_to_FEBA
   chapter_summary

