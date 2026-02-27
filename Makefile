.SECONDARY:

MAIN_TYPs = $(shell find . -name "*main.typ") $(shell find . -name "*fail.typ")
MAIN_PDFs = $(subst .typ,.pdf,${MAIN_TYPs})

all: test

#                    find all typ in the same folder
%.pdf: %.typ $(shell find $(<D) -name "*.typ") lib.typ nestemp/lib.typ
	typst compile $< $@

SH_TESTs = $(shell find . -name "test.sh")
test: $(addsuffix .test,${MAIN_PDFs}) $(addsuffix .run,${SH_TESTs})

%main.pdf.test: %main.pdf doc/check_regex_order.py %main.regex
	pdftotext $< - | python3 $(filter-out $<,$^)
%fail.pdf.test: %fail.pdf doc/check_regex_order.py %fail.regex
	! pdftotext $< - | python3 $(filter-out $<,$^) 2> /dev/null
%test.sh.run: %test.sh
	bash $<

publish: $(addprefix public/,${MAIN_PDFs})
public/%: %
	mkdir -p $(@D)
	cp $< $@

clean:
	rm -f ${MAIN_PDFs}
	rm -rf public/
