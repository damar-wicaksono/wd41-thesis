all: pdf

pdf:
	pdflatex wd41_thesis
	bibtex wd41_thesis
	pdflatex wd41_thesis
	pdflatex wd41_thesis
	pdflatex wd41_thesis

clean:
	rm -f *.aux *.log *.bbl *.blg *.toc *.lof *.lot *.out
	rm -f head/*.aux head/*.log
	rm -f main/*.aux main/*.log
	rm -f tail/*.aux tail/*.log
