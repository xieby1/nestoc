MAIN_TYPs = $(shell find . -name "*main.typ")
MAIN_PDFs = $(subst .typ,.pdf,${MAIN_TYPs})

all: ${MAIN_PDFs}

%main.pdf: %main.typ %obj.typ lib.typ
	typst compile $< $@

test: $(addsuffix .test,${MAIN_PDFs})

%main.pdf.test: %main.pdf tests/check_regex_order.py %main.regex
	pdftotext $< - | python3 $(filter-out $<,$^)

clean:
	rm -f ${MAIN_PDFs}
