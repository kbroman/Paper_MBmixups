R_OPTS=--no-save --no-restore --no-init-file --no-site-file

mb_mixups.pdf: LaTeX/mb_mixups.tex mb_mixups.bib \
			   Figs/fig1.pdf Figs/fig2.pdf Figs/fig3.pdf Figs/fig4.pdf Figs/fig5.pdf \
			   Figs/figS1.pdf Figs/figS2.pdf Figs/figS3.pdf Figs/figS4.pdf
	cd $(<D);pdflatex mb_mixups
	cd $(<D);bibtex mb_mixups
	cd $(<D);pdflatex mb_mixups
	cd $(<D);pdflatex mb_mixups
	mv $(<D)/$(@F) $@

LaTeX/mb_mixups.tex: mb_mixups.Rnw R/single_results.rds R/mixture_results.rds Data/readMapping_mouseGenome_all_uncorrectedNames.tsv
	[ -d LaTeX ] || mkdir LaTeX
	[ -e LaTeX/genetics.bst ] || (cd LaTeX;ln -s ../genetics.bst)
	[ -e LaTeX/mb_mixups.bib ] || (cd LaTeX;ln -s ../mb_mixups.bib)
	[ -e LaTeX/Figs ] || (cd LaTeX;ln -s ../Figs)
	R -e "knitr::knit('$<', '$@')"

Figs/fig%.pdf: R/fig%.R R/single_results.rds R/mixture_results.rds
	[ -d Figs ] || mkdir Figs
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

R/single_results.rds: R/single_results.R Data/sample_results_allchr.rds
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

R/mixture_results.rds: R/mixture_results.R Data/pair_results_allchr.rds
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

clean:
	rm Figs/fig?.pdf LaTeX/mb_mixups.tex LaTeX/mb_mixups.bbl  LaTeX/mb_mixups.aux LaTeX/mb_mixups.out LaTeX/mb_mixups.blg LaTeX/mb_mixups.log
