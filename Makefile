.SECONDARY:

MAIN_TYPs = $(shell find . -name "*main.typ")
FAIL_TYPs = $(shell find . -name "*fail.typ")
PDFs = $(subst .typ,.pdf,${MAIN_TYPs} ${FAIL_TYPs})

all: test svg

MAIN_SVGs = $(subst .typ,.svg,${MAIN_TYPs})
svg: ${MAIN_SVGs}

#                    find all typ in the same folder
%.pdf: %.typ $(shell find $(<D) -name "*.typ") lib.typ nestemp/lib.typ
	typst compile $< $@

%.svg: %.pdf combine_svg.py
	pdf2svg $< $(basename $@)%02d.svg all
	python3 combine_svg.py $(basename $@)*.svg $@

SH_TESTs = $(shell find . -name "test.sh")
test: $(addsuffix .test,${PDFs}) $(addsuffix .run,${SH_TESTs})

%main.pdf.test: %main.pdf doc/check_regex_order.py %main.regex
	pdftotext $< - | python3 $(filter-out $<,$^)
%fail.pdf.test: %fail.pdf doc/check_regex_order.py %fail.regex
	! pdftotext $< - | python3 $(filter-out $<,$^) 2> /dev/null
%test.sh.run: %test.sh
	bash $<

publish: $(addprefix public/,${PDFs} ${MAIN_SVGs})
public/%: %
	mkdir -p $(@D)
	cp $< $@

clean:
	rm -f ${PDFs}
	rm -f ${MAIN_SVGs}
	rm -rf public/
