#import "../../lib.typ" as nestemp
#show: nestemp.template0.with(
  title: "Test Bibliography",
  author: "xieby1",
)
#nestemp.init-bib(read: path=>read(path))
#nestemp.add-bib("./main1.bib")
#nestemp.add-bib("./main2.bib")

Miao: @bib:ref1,
@bib:ref2
wang!
