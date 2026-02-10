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
  set page(background: rect(width:100%, height:100%, stroke:1em+red))    if n==0
  set page(background: rect(width:100%, height:100%, stroke:1em+orange)) if n==1
  set page(background: rect(width:100%, height:100%, stroke:1em+blue))   if n==2
  set page(background: rect(width:100%, height:100%, stroke:1em+white))  if n==3
  body
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

  // Line numbering for Raw Text / Code: https://github.com/typst/typst/issues/344
  // TODO: how to customize the start line number?
  // TODO: how to customize number for each line?
  show raw.where(block: true): code => {
    show raw.line: line => {
      text(fill: gray)[#line.number]
      h(1em)
      line.body
    }
    code
  }

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
    appendix: (enabled: glossary-enable, body: glossary(), title: "术语索引"),
    {
      set par(justify: false)
      body
    }
  )
}
