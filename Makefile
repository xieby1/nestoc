test-main.pdf: test-main.typ test-obj.typ lib.typ
	typst compile $< $@
