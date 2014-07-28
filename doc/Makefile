PANDOC = pandoc --mathml=https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=MML_HTMLorMML

html: index.html INSTALL.html README.html reference.html CHANGES.html

%.html: %.mdwn pandoc.html
	$(PANDOC) --template=pandoc.html --css=pandoc.css --toc --toc-depth=2 -o $@ $<

index.html: index.mdwn pandoc.html
	$(PANDOC) --template=pandoc.html --css=pandoc.css -V pagetitle= -o $@ $<

CHANGES.html: CHANGES.mdwn pandoc.html
	$(PANDOC) --template=pandoc.html --css=pandoc.css -o $@ $<

pandoc.html: contents.mdwn pandoc.html.in
	$(PANDOC) --template=pandoc.html.in -o $@ $<

%.png: %.ps
	convert -resize 128x128 -strip $< $@
	optipng $@

%.svg: %.pdf
	pdftocairo -svg $< $@

%.pdf: %.tex
	latexmk -xelatex $*
	latexmk -c $*

clean:
	$(RM) *.html

.INTERMEDIATE: pandoc.html
