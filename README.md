# Bayesian Uncertainty Quantification of Physical Model in Thermal-Hydraulics System Code

This is a repository for thesis entitled *Bayesian Uncertainty Quantification of Physical Model in Thermal-Hydraulics System Code* 
to be submitted to the Doctoral School of Physics as partial requirement to 
obtain a doctoral degree in nuclear engineering from the Swiss Federal Institute of Technology, Lausanne.

The thesis is prepared in `LaTeX`, and (much) later also as a `sphinx-doc` document.
Complete log of changes can be found in [CHANGELOG].

## Project Structures

- `classicthesis-template`: the original template as it was downloaded (2017-04-01)
- `figures`: the folder with figures included across project
- `old-template`: the old template provided, but not required, by EPFL
- `references`: the references and `BibTeX` file of it
- `sphinx-doc`: the thesis prepared in `sphinx-doc`
- `wd41-thesis`: the thesis prepared in LaTeX
- `CHANGELOG.md`: more detailed log of notable changes
- `README.md`: this file
- `.gitignore`: hidden file with list of files to be excluded from git

## System Requirement

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

## Structures and Progress

The thesis is currently splitted into 7 Chapters and 5 Appendices.
Each Chapter is separated into its own folder inside `wd41-thesis/Chapters`.
Within this folder the section is written in separate file as well, 
but all  Chapter folders have a file called `index.tex` 
which contains the chapter introduction and input statement to include files of sections.
Filewise, a section constitutes the smalles unit.

1. Introduction (`wd41-thesis/Chapters/Chapters/1_introduction`)
 - Introduction (`./index.tex`)
 - Computer Simulation (`./computer_simulation.tex`)
 - Computer Experiment (`./computer_experiment.tex`)
 - Uncertainty Quantification (`./uncertainty_quantification.tex`)
 - OECD/NEA PREMIUM Project (`./premium.tex`)
 - Research Objectives (`./research_objectives.tex`)
 - Statistical Framework  (`./statistical_framework.tex`)
 - Thesis Overview (`./thesis_overview.tex`)
2. Reflood Simulation using TRACE Code (`wd41-thesis/Chapters/Chapters/2_trace_reflood`)
 - Thermal-Hydraulics System Code TRACE (`./trace.tex`)
 - Reflood Phenomenological Modeling (`./reflood_phenomenology_modeling.tex`)
 - Initial Selection of Inputs Parameters (`./initial_selection_of_inputs.tex`)
 - FEBA Separate Effect Test Facility (`./feba_setf.tex`)
 - FEBA Model in TRACE (`./feba_trace.tex`)
 - Chapter Summary (`./chapter_summary.tex`)
3. Sensitivity Analysis (`wd41-thesis/Chapters/Chapters/3_gsa`)
 - Introduction (`./index.tex`)
 - Statistical Framework (`./statistical_framework.tex`)
 - Describing Time-Dependent Variation (`./time_dependent_variation.tex`)
 - Parameter Screening (`./parameters_screening.tex`)
 - Variance Decomposition (`./variance_decomposition.tex`)
 - Implementation (`./implementation.tex`)
 - Application to FEBA (`./application_to_feba.tex`)
 - Chapter Summary (`./chapter_summary.tex`)
4. Gaussian Process Metamodeling (`wd41-thesis/Chapters/Chapters/4_gp_regression`)
 - Introduction (`./index.tex`)
 - Statistical Framework (`./statistical_framework.tex`)
 - Gaussian Process Fundamentals (`./fundamentals.tex`)
 - Gaussian Process Metamodeling (`./metamodeling.tex`)
 - Constructing a Gaussian Process Metamodel (`./constructing_metamodel.tex`)
 - Dimension Reduction (`./dimension_reduction.tex`)
 - Application to FEBA (`./application_to_feba.tex`)
 - Chapter Summary (`./chapter_summary.tex`)
5. Bayesian Calibration (`wd41-thesis/Chapters/Chapters/5_bayesian_calibration`)
 - Introduction (`./index.tex`)
 - Statistical Framework (`./statistical_framework.tex`)
 - Model Discrepancy (`./model_discrepancy.tex`)
 - Modular Bayesian Approach (`./modular_bayesian.tex`)
 - Markov Chain Monte Carlo (`./mcmc.tex`)
 - Application to FEBA using Single Model Response (`./application_to_feba_univariate.tex`)
 - Identifiability Issue and its Solution (`./identifiability_issue.tex`)
 - Application to FEBA using Multiple Model Responses (`./application_to_feba_multivariate.tex`)
 - Chapter Summary (`./chapter_summary.tex`)
6. Method Validation (`wd41-thesis/Chapters/Chapters/6_validation`)
 - Introduction (`./index.tex`)
 - XXX Separate Effect Test Facility (`./validate_setf.tex`)
 - FEBA Model of XXX SETF (`./validate_model.tex`)
 - Global Sensitivity Analysis of XXX Model (`./validate_gsa.tex`)
 - Uncertainty Propagation (`./validate_uq.tex`)
 - Chapter Summary (`./chapter_summary.tex`)
7. Conclusions and Future Work
 - Chapterwise Summary (`./chapterwise.tex`)
 - Summary of Contributions (`./contributions.tex`)
 - Recommendations (`./recommendations.tex`)
 - Concluding Remarks (`./concluding_remarks.tex`)
8. Appendices (`wd41-thesis/Appendices`)
 - Design of Computer Experiments (`./design_of_experiment.tex`)
 - `gsa-module` (`./gsa_module.tex`)
- `trace-simexp` (`./trace_simexp.tex`)
 - `DiceKriging` (`./dice_kriging.tex`)
 - Some useful mathematical results and recipes (`./math_results.tex`)
9. Front and Backmatter (`wd41-thesis/FrontBackMatter`)
 - Abstract (`./Abstract.tex`)
 - Acknowledgements (`./Acknowledgments.tex`)
 - Bibliography (`./Bibliography.tex`)
 - List of Glossary (`/Glossary.tex`)

[CHANGELOG]: ./CHANGELOG.md
[MacTeX]: http://www.tug.org/mactex/
[MikTeX]: https://miktex.org
[ClassicThesis]: http://www.ctan.org/tex-archive/macros/latex/contrib/classicthesis/
[A. Miede]: http://www.miede.de
[glossary]: https://www.ctan.org/pkg/glossaries?lang=en
[stackexchange]: http://tex.stackexchange.com/questions/156308/classicthesis-conflicts-with-glossaries