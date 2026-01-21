MAIN_TYPs = $(shell find . -name "*main.typ")
MAIN_PDFs = $(subst .typ,.pdf,${MAIN_TYPs})

all: ${MAIN_PDFs}

%main.pdf: %main.typ %obj.typ lib.typ
	typst compile $< $@

clean:
	rm -f ${MAIN_PDFs}
