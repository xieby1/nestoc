#let numbering(start:1, len:1, code) = {
  show raw.line: line => {
    let str_num = str(line.number + start - 1)
    // padding left
    if str_num.len() < len { str_num = [~]*(len - str_num.len()) + str_num }
    text(fill:gray, str_num); [~]; line.body
  }
  code
}

#let bibs = state("__bibs", ())
#let add-bib(path) = bibs.update(old => {
  if old == none { old =   (path,) }
  else           { old.push(path)  }
  old
})

#let secret-level-state = state("secret-level", none)
#let set-secret-level(n: 3, body) = {
  assert(n in (0,1,2,3), message: "Unknown secret-level: " + str(n))
  context {
    if secret-level-state.get() == none { secret-level-state.update(n) }
    else { assert( n >= secret-level-state.get(),
      message: "secret-level violated: the doc's secret-level is "
               + str(secret-level-state.get())
               + ", the new secret-level " + str(n)
    )}
  }
  block(
    stroke: (right: 1pt+(
           if n==0 {red}
      else if n==1 {yellow}
      else if n==2 {green}
      else if n==3 {white}
    )),
    radius: 1em,
    outset: (right: 1em),
    width: 100%,
    body
  )
}

#import "@preview/glossy:0.8.0"
#let init-glossary = glossy.init-glossary.with(
  format-term: (mode, short-form, long-form) => {
    if mode == "short" {short-form}
    else if mode == "long" {long-form}
    else {short-form + " （" + long-form + "）"}
  },
)
#let glossary = glossy.glossary.with(
  // override the theme
  theme: glossy.theme-academic + ( section: (title, body) => { body } )
)

#let template0(title:"", author:"", abstract:[], glossary-enable:true, body) = {
  // These show rules are applied to body before ilm's show rules being applied
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"), lang: "zh", region: "cn")
  show raw: set text(font: ("Noto Sans Mono CJK SC"))

  // https://guide.typst.dev/FAQ/chinese-remove-space
  let han-or-punct = "[-\p{sc=Hani}。．，、：；！‼？⁇⸺——……⋯⋯～–—·・‧/／「」『』“”‘’（）《》〈〉【】〖〗〔〕［］｛｝＿﹏●•]"
  show regex(han-or-punct + " "): it => it.text.clusters().first()
  show regex(" " + han-or-punct): it => it.text.clusters().last()
  set smartquote(enabled: false)
  show link: it => underline(text(fill: blue, it))

  show: init-glossary.with(())

  import "@preview/ilm:1.4.2"
  ilm.ilm(
    title: title,
    author: author,
    abstract: abstract,
    chapter-pagebreak: false,
    external-link-circle: false,
    raw-text: (use-typst-defaults: true),
    figure-index: (enabled: true, title: "图索引"),
    table-index: (enabled: true, title: "表格索引"),
    listing-index: (enabled: true, title: "代码块索引"),
    // TODO: make glossary-enable auto?
    // TODO: remove appendix, place these content under top document,
    //       this may need to rewrite ilm template
    appendix: (enabled: glossary-enable, title: "附录",
      body: [
        #context bibliography(bibs.final())

        #heading(numbering:none, "术语索引")

        #glossary()
      ],
    ),
    {
      set par(justify: false)
      body
    }
  )
}
