# Document to compile
MAIN        = main

# Tex options

TEX_ENGINE := xelatex
BIB_ENGINE := biber

TEX_OPTS   := -synctex=1 -file-line-error -shell-escape
TEX_OPTS   += -interaction=nonstopmode

# GhostScript options

# Should be optional, GhostScript will maintain the papersize selected by LaTeX
# PAPER_SIZE  = letter

GS_OPTS    := -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite
# GS_OPTS  += -sPAPERSIZE=$(PAPER_SIZE)
GS_OPTS    += -dPDFSETTINGS=/printer
GS_OPTS    += -dCompatibilityLevel=1.7 -dMaxSubsetPct=100
GS_OPTS    += -dSubsetFonts=true -dEmbedAllFonts=true

# Compilation rules

.PHONY: all clean clean-objs grammarly

all: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex $(wildcard *.tex) $(wildcard *.bib) $(wildcard figs/*)
	$(TEX_ENGINE) $(TEX_OPTS) $(MAIN)
	$(BIB_ENGINE)             $(MAIN)
	$(TEX_ENGINE) $(TEX_OPTS) $(MAIN)
	$(TEX_ENGINE) $(TEX_OPTS) $(MAIN)
	$(TEX_ENGINE) $(TEX_OPTS) $(MAIN)
	# Following commands ensure that the paper has all Type 1 fonts embedded
	mv $@ $@.tmp
	gs $(GS_OPTS) -sOutputFile=$@ $@.tmp
	rm -f $@.tmp
	pdffonts $@

# Update figures, requires python packages: matplotlib, numpy and pandas
figs/plot-th.pdf figs/plot-th.png: $(wildcard data/th/*) ./data/lineplot-scatter.py
	./data/lineplot-scatter.py


# Update figures, requires python packages: matplotlib, numpy and pandas
figs/plot-rt.pdf figs/plot-rt.png: $(wildcard data/pingpong/*) ./data/boxplot-scatter.py
	./data/boxplot-scatter.py

# Cleanup rule

clean: clean-objs clean-html
	rm -f $(MAIN).pdf $(MAIN).synctex.gz

clean-objs:
	rm -f  *.tdo *.out *.aux *.bbl *.blg *.tmp *~ *.glsdefs

clean-html:
	rm -f html./* *.4ct *.4tc *.css *.dvi *.html *.idv *.lg *.log *.xref

grammarly: $(MAIN).html

$(MAIN).html: $(MAIN).tex $(wildcard *.tex) $(wildcard *.bib) $(wildcard figs/*)
	latex $(TEX_OPTS) $(MAIN)
	bibtex            $(MAIN)
	latex $(TEX_OPTS) $(MAIN)
	latex $(TEX_OPTS) $(MAIN)
	mkdir -p html.
	htlatex $(MAIN) html "xhtml,charset=utf-8,NoFonts,-css" -dhtml "$(TEX_OPTS)"
