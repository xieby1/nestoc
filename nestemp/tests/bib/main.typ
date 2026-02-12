#import "../../lib.typ" as nestemp
#show: nestemp.template0.with(
  title: "Test Bibliography",
  author: "xieby1",
)
// TODO: Can we use relpath here?
// NOTE: The abspath in typst is the root path of this package
#nestemp.add-bib("/nestemp/tests/bib/main1.bib")
#nestemp.add-bib("/nestemp/tests/bib/main2.bib")


Miao: @ref1,
@ref2
wang!
