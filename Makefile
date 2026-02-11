.SECONDARY:

MAIN_TYPs = $(shell find . -name "*main.typ") $(shell find . -name "*fail.typ")
MAIN_PDFs = $(subst .typ,.pdf,${MAIN_TYPs})
COMPILE_TYPs = $(shell find . -name "*compile.typ")
COMPILE_PDFs = $(subst .typ,.pdf,${COMPILE_TYPs})

all: test

#                    find all typ in the same folder
%.pdf: %.typ $(shell find $(<D) -name "*.typ") lib.typ nestemp/lib.typ
	typst compile $< $@

SH_TESTs = $(shell find . -name "test.sh")
test: $(addsuffix .test,${MAIN_PDFs}) ${COMPILE_PDFs} \
	$(addsuffix .run,${SH_TESTs})

%main.pdf.test: %main.pdf doc/check_regex_order.py %main.regex
	pdftotext $< - | python3 $(filter-out $<,$^)
%fail.pdf.test: %fail.pdf doc/check_regex_order.py %fail.regex
	! pdftotext $< - | python3 $(filter-out $<,$^) 2> /dev/null
%test.sh.run: %test.sh
	bash $<

clean:
	rm -f ${MAIN_PDFs} ${COMPILE_PDFs}
