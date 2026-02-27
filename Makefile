.SECONDARY:

MAIN_TYPs = $(shell find . -name "*main.typ")
FAIL_TYPs = $(shell find . -name "*fail.typ")
PDFs = $(subst .typ,.pdf,${MAIN_TYPs} ${FAIL_TYPs})

DOCCOM_TYPs = $(shell grep -rl "/\*typ\*//\*" --include="*.typ")
DOCCOM_TYP_TYPs = $(addsuffix .typ, $(addprefix doc/com/,${DOCCOM_TYPs}))

all: test svg

MAIN_SVGs = $(subst .typ,.svg,${MAIN_TYPs})
svg: ${MAIN_SVGs}

#                    find all typ in the same folder
%.pdf: %.typ $(shell find $(<D) -name "*.typ") lib.typ nestemp/lib.typ ${DOCCOM_TYP_TYPs}
	typst compile $< $@

# Extract all doccom from %.rs to doc/com/%.typ
doc/com/%.typ.typ: %.typ
	mkdir -p $(@D)
	perl -0777 -ne 'while (/\/\*typ\w*\*\/\s*\/\*(.*?)\*\//gs) {print $$1}' $< > $@

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
	rm -f ${DOCCOM_TYP_TYPs}
	rm -rf public/
