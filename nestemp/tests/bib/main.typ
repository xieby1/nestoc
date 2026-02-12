#import "../../lib.typ" as nestemp
#show: nestemp.template0.with(
  title: "Test Bibliography",
  author: "xieby1",
)
#nestemp.add-bib(read(encoding:none, "main1.bib"))
#nestemp.add-bib(read(encoding:none, "main2.bib"))


Miao: @ref1,
@ref2
wang!
