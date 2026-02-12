#import "@local/alexandria:0.2.2"
#show: alexandria.alexandria(prefix: "bib:", read: path => read(path))

#alexandria.add-bib("./main1.bib")
#alexandria.add-bib("./main2.bib")

miao @bib:ref_main_2_2 !

wang @bib:ref_main_1_1

zhi @bib:ref_main_1_2, @bib:ref_main_2_1, @bib:ref_main_1_1

#alexandria.load-bibliography(prefix: "bib:")
#context {
  let bib = alexandria.get-bibliography("bib:")
  alexandria.render-bibliography(bib, title: "参考文献")
}
