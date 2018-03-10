# Bayesian Uncertainty Quantification of Physical Model in Thermal-Hydraulics System Code

This is a repository for thesis entitled *Bayesian Uncertainty Quantification of Physical Model in Thermal-Hydraulics System Code* submitted to the Doctoral School of Physics as a partial requirement to 
obtain a doctoral degree in nuclear engineering from the Swiss Federal Institute of Technology, Lausanne (EPFL).

The thesis was successfully defended in a closed oral exam session at the EPFL campus on January 19, 2018 in front of jury members and publicly thereafter at the Paul Scherrer Institut on February 23, 2018.

The thesis is prepared in `LaTeX`.
Complete log of changes can be found in [CHANGELOG].

## Document Releases

There are three different versions of the thesis available:

 1. The [EPFL Infoscience] hosts the final official version of the thesis in `PDF` format,
    which was also used in the print version.
    Unfortunately, during pre-processing for printing,
    the table of contents and the hyperlinks for the cross references were all broken.
 2. This [Github project page] hosts the version in `PDF` with the broken links fixed.
    The version also adds nomenclature for alphanumeric and greek symbols
    as well as some fixes to several typos found later on.
 3. [Read the Docs] hosts the thesis generated using the `sphinx` documentation generator.

## Presentations

Two sets of slides related to the defense were presented in two difference occasions:
the [oral exam] (closed session) and [public defense] (open session).
They are both hosted at [Speaker Deck].

## Project Structures

- `classicthesis-template`: the original template as it was downloaded (2017-04-01)
- `figures`: the folder with figures included across project.
  Most are created either in `R` or `ipe`.
- `old-template`: the old template provided, but not required, by EPFL
- `references`: the references and `BibTeX` file of it
- `docs`: the thesis prepared in `sphinx-doc`
- `wd41-cv`: my CV put in the back of the thesis
- `wd41-thesis`: the thesis prepared in LaTeX
- `CHANGELOG.md`: more detailed log of notable changes
- `README.md`: this file
- `.gitignore`: hidden file with list of files to be excluded from git

## Requirement

Please make sure the following software is available in your PC to be able to typeset the document.
- [MikTeX] or [MacTeX]
- Perl (for `makeglossary`)

## Template

The thesis uses the so-called [ClassicThesis] package developed by [A. Miede].
The document can be typeset using MikTeX.

### The `glossary` Package

The [glossary] package for LaTeX is used to make the glossary section of the thesis.
The package does not work out of the box with `classicthesis` due to a conflict in `\renewcommand`.
The workaround is available from the [stackexchange].

### Modification for using the Margin for Figures

The `classicthesis` has a wide margin, thus makes space more or less a premium.
I would like to use the margin for larger figure as well.
Thankfully Benjamin Hopfer came with [a very nice solution] to this problem.
His modification allowed figure to use the margin space.
Furthermore, he also made a modification to have multiple figures (two or three) with their own caption in one line.
The whole figure caption remains.

## Structures of the Thesis

The thesis is splitted into 6 Chapters and 4 Appendices, bookend by front and backmatters.
Each Chapter is separated into its own folder inside `wd41-thesis/Chapters`.
Within this folder the section is written in separate file as well, 
but all  Chapter folders have a file called `index.tex` 
which contains the chapter introduction and input statement to include files of the sections.

1. Introduction (`wd41-thesis/Chapters/Chapters/1_introduction`)
 - Introduction (`index.tex`)
 - Computer Simulation and Safety Analysis of Nuclear Power Plant (`computer_simulation.tex`)
 - Uncertainty Quantification in Nuclear Engineering Thermal-Hydraulics (`uncertainty_quantification.tex`)
 - Objectives and Scope of the Thesis (`research_objectives.tex`)
 - Statistical Framework  (`statistical_framework.tex`)
 - Structure of the Thesis (`thesis_structure.tex`)

2. Reflood Simulation using the TRACE Code (`wd41-thesis/Chapters/Chapters/2_trace_reflood`)
 - The Thermal-Hydraulics System Code TRACE (`trace.tex`)
 - Phenomenology and Modeling of Bottom Reflood (`reflood_phenomenology_modeling.tex`)
 - FEBA Reflood Separate Effect Test Facility (`feba_setf.tex`)
 - FEBA Model in TRACE (`feba_trace.tex`)
 - Initial Selection of Inputs Parameters (`initial_selection_of_inputs.tex`)
 - Propagation of the Prior Uncertainties (`prior_uq.tex`)
 - Chapter Summary (`chapter_summary.tex`)

3. Sensitivity Analysis (`wd41-thesis/Chapters/Chapters/3_gsa`)
 - Introduction (`index.tex`)
 - Statistical Framework (`statistical_framework.tex`)
 - Describing Variation of Time-Dependent Output (`time_dependent_variation.tex`)
 - Parameter Screening (`parameters_screening.tex`)
 - Variance Decomposition (`variance_decomposition.tex`)
 - Implementation (`implementation.tex`)
 - Application to the TRACE Model of FEBA (`application_to_feba`
    * Introduction (`index.tex`)
    * Simulation Experiment (`simulation_experiment.tex`)
    * Screening Analysis (`screening_analysis.tex`)
    * Sobol' Indices for Conventional QoIs of the Reflood Curve (`conventional_sobol.tex`)
    * Principal Components of the Reflood Curve (`pca_reflood.tex`)
    * Sobol' Indices for QoIs based on Principal Components (`pca_sobol.tex`)
    * Discussion (`discussion.tex`)
 - Chapter Summary (`chapter_summary.tex`)

4. Gaussian Process Metamodeling (`wd41-thesis/Chapters/Chapters/4_gp_regression`)
 - Introduction (`index.tex`)
 - Statistical Framework (`statistical_framework.tex`)
 - Gaussian Process Fundamentals (`fundamentals.tex`)
 - Gaussian Process Metamodeling (`metamodeling.tex`)
 - Constructing a Gaussian Process Metamodel (`constructing_metamodel.tex`)
 - Dimension Reduction (`dimension_reduction.tex`)
 - Application to the TRACE Model of FEBA (`application_to_feba`)
    * Introduction (`index.tex`)
    * Simulation Experiment (`simulation_experiment.tex`)
    * Dimension Reduction by Principal Component Analysis (`gp_feba_pca.tex`)
    * GP PC Metamodel Construction (`gp_feba_pca_metamodel_construction.tex`)
    * PG PC Metamodel Testing (`gp_feba_pca_metamodel_testing.tex`)
    * Discussion (`gp_feba_discussion.tex`)
 - Chapter Summary (`chapter_summary.tex`)

5. Bayesian Calibration (`wd41-thesis/Chapters/Chapters/5_bayesian_calibration`)
 - Introduction (`index.tex`)
 - Statistical Framework (`statistical_framework.tex`)
 - Bayesian Formulation of Calibration Problem (`modular_bayesian.tex`)
 - MCMC Simulation (`mcmc.tex`)
 - Diagnosing MCMC Samples (`mcmc_diagnostic.tex`)
 - Application to the TRACE Model of FEBA (`application_to_feba`)
    * Introduction (`index.tex`)
    * Simulation Experiment (`simulation_experiment.tex`)
    * MCMC Convergence (`mcmc_convergence.tex`)
    * Calibration Results (`calibration_results.tex`)
    * Calibration Evaluation (`calibraiton_evaluation.tex`)
    * Discussion (`discussion.tex`)
 - Chapter Summary (`chapter_summary.tex`)
 
6. Conclusions and Future Work (`wd41-thesis/Chapters/6_conclusions`)
 - Introduction (`index.tex`)
 - Chapter-wise Summary (`chapterwise.tex`)
 - Achievements and Recommendations (`achievements.tex`)

7. Appendices (`wd41-thesis/Appendices`)
 - TRACE Code Governing Equations (`design_of_experiment.tex`)
 - Additional Results (`./tbl_resuts`)
    * Introduction (`index.tex`)
    * Prior Uncertainty Quantification of the FEBA Tests (`feba_uq_prior.tex`)
    * Screening Analysis (27-parameter Model) (`screening.tex`)
    * Convergence of the Sobol' Indices (`sobol_convergence.tex`)
    * Sobol' Indices (12-parameter Model) (`sobol.tex`)
    * Gaussian Process Metamodel Construction (`gp_metamodel.tex`)
    * MCMC Samples from different Calibration Schemes (`mcmc_samples.tex`)
    * Forward Uncertainty Propagation of MCMC Samples (`mcmc_evaluation.tex`)
 - Computational Tools (`comp_tools/index.tex`)
    * `gsa-module` (`gsa_module.tex`)
    * `trace-simexp` (`trace_simexp.tex`)
 - Some useful mathematical results and recipes (`math_results/index.tex`)
    * The Sobol'-Saltelli Method for Estimating Variance-Based Sensitivity Indices (`sobol_saltelli.tex`)
    * Multivariate Random Variable (`probability.tex`)
    * Gaussian Random Vector (`gaussian_vector.tex`)
    * Inverse Transform Sampling (`its.tex`)
    * Generating Samples from a Multivariate Normal Distribution (`sample_mvn.tex`)
    * Landmark Registration and Time-Warping Function (`landmark_registration.tex`)
    * Karhunen-Loéve Theorem (`kl_theorem.tex`)
    * Discrete-state Markov Chain (`markov_chain.tex`)

8. Front and Backmatter (`wd41-thesis/FrontBackMatter`)
 - Page de Garde (`EPFLFrontPage.tex`): make use of scanned EPFL authorization page (`figures/epfl_front_page.pdf`)
 - Dedication (`Dedication.tex`)
 - Acknowledgements (`Acknowledgments.tex`)
 - Abstract/Resume/Intisari (`Abstract.tex`)
 - Contents (`Contents.tex`)
 - Bibliography (`Bibliography.tex`): make use of `BibTeX` file (`references/wd41-thesis.bib`) 
 - List of Glossary (`Glossary.tex`): make use of glossary file (`wd41-thesis/glossary.tex`)
 - Curriculum Vitae (`CV.tex`): make use of CV in pdf (`wd41-cv/wd41_cv.pdf`)
 - Colophon (`Colophon.tex`)

[CHANGELOG]: ./CHANGELOG.md
[MacTeX]: http://www.tug.org/mactex/
[MikTeX]: https://miktex.org
[ClassicThesis]: http://www.ctan.org/tex-archive/macros/latex/contrib/classicthesis/
[A. Miede]: http://www.miede.de
[glossary]: https://www.ctan.org/pkg/glossaries?lang=en
[stackexchange]: http://tex.stackexchange.com/questions/156308/classicthesis-conflicts-with-glossaries
[EPFL Infoscience]: https://infoscience.epfl.ch/record/253113?ln=en
[Github project page]: https://
[Read the Docs]: http://wd41-thesis.readthedocs.io/en/feature-sphinx/
[oral exam]: https://speakerdeck.com/dcwicaksono/bayesian-uncertainty-quantification-of-physical-models-in-thermal-hydraulics-system-codes
[public defense]: https://speakerdeck.com/dcwicaksono/bayesian-uncertainty-quantification-of-physical-models-in-thermal-hydraulics-system-codes-1
[Speaker Deck]: https://speakerdeck.com/dcwicaksono/
[a very nice solution]: http://benjaminhopfer.com/2014/04/16/typesetting-my-masters-thesis-in-latex/