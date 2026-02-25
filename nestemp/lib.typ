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

#let template0(title:"", author:"", abstract:[], body) = {
  // https://guide.typst.dev/FAQ/chinese-remove-space
  let han-or-punct = "[-\p{sc=Hani}。．，、：；！‼？⁇⸺——……⋯⋯～–—·・‧/／「」『』“”‘’（）《》〈〉【】〖〗〔〕［］｛｝＿﹏●•]"
  show regex(han-or-punct + " "): it => it.text.clusters().first()
  show regex(" " + han-or-punct): it => it.text.clusters().last()
  set smartquote(enabled: false)
  show link: it => underline(text(fill: blue, it))

  show: init-glossary.with(())

  set document(title: title, author: author)
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"), lang: "zh", region: "cn")
  // show raw: set text(font: ("JetBrains Maple Mono"))

  // This template is based on ilm
  // COVER
  page(align(left + horizon, block(width: 90%)[
    #text(3em)[*#title*]
    #v(2em, weak: true)
    #text(1.6em, author)
    #v(2em, weak: true)
    #block(width: 80%, abstract)
  ]))

  // TOC
  context if counter(heading).final().at(0) > 0 {
    outline()
    pagebreak()
  }

  // BODY
  {
    set math.equation(numbering: "(1)")
    set heading(numbering: "1.")
    body
  }

  // APPENDIX
  {
    let has-glossaries() = state("__gloss_entries", (:)).final().len() > 0
    let has-images() = counter(figure.where(kind:image)).get().at(0) > 0
    let has-tables() = counter(figure.where(kind:table)).get().at(0) > 0
    let has-codes() = counter(figure.where(kind:raw)).get().at(0) > 0
    let has-bibs() = bibs.final().len() > 0

    context if has-glossaries() or has-images() or has-tables() or has-codes() or has-bibs() {
      pagebreak()
    }
    context if has-glossaries() {
      heading(numbering:none, "术语索引")
      glossary()
    }
    context {
      show outline: set heading(outlined: true)
      if has-images() { outline(title: "图索引", target: figure.where(kind:image)) }
      if has-tables() { outline(title: "表格索引", target: figure.where(kind:table)) }
      if has-codes()  { outline(title: "代码块索引", target: figure.where(kind:raw)) }
    }
    context if has-bibs() {
      bibliography(bibs.final())
    }
  }
}

#let templateN(heading_offset, title:"", author:"", abstract:[], body) = {
  grid(columns: (1fr, auto),
    // Naturally, it is better to write heading(title, depth:0)
    // But depth only supports positive integer.
    heading(title, level: heading_offset),
    text(fill: gray, author)
  )
  abstract
  set heading(offset: heading_offset)
  body
}
