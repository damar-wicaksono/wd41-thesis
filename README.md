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
But, I would like to use the margin for larger figure as well.
Thankfully, [B. Hopfer] came with [a very nice solution] to this problem.
His modification allowed figure to use the margin space.
Furthermore, he also made a modification to have multiple figures (two or three) with their own caption in one line while keeping the whole figure caption in place.


[CHANGELOG]: ./CHANGELOG.md
[MacTeX]: http://www.tug.org/mactex/
[MikTeX]: https://miktex.org
[ClassicThesis]: http://www.ctan.org/tex-archive/macros/latex/contrib/classicthesis/
[A. Miede]: http://www.miede.de
[B. Hopfer]: http://benjaminhopfer.com/
[glossary]: https://www.ctan.org/pkg/glossaries?lang=en
[stackexchange]: http://tex.stackexchange.com/questions/156308/classicthesis-conflicts-with-glossaries
[EPFL Infoscience]: https://infoscience.epfl.ch/record/253113?ln=en
[Github project page]: https://github.com/damar-wicaksono/wd41-thesis/blob/master/wd41-thesis/wd41_thesis.pdf
[Read the Docs]: http://wd41-thesis.readthedocs.io/en/feature-sphinx/
[oral exam]: https://speakerdeck.com/dcwicaksono/bayesian-uncertainty-quantification-of-physical-models-in-thermal-hydraulics-system-codes
[public defense]: https://speakerdeck.com/dcwicaksono/bayesian-uncertainty-quantification-of-physical-models-in-thermal-hydraulics-system-codes-1
[Speaker Deck]: https://speakerdeck.com/dcwicaksono/
[a very nice solution]: http://benjaminhopfer.com/2014/04/16/typesetting-my-masters-thesis-in-latex/