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
  // https://guide.typst.dev/FAQ/chinese-remove-space
  let han-or-punct = "[-\p{sc=Hani}。．，、：；！‼？⁇⸺——……⋯⋯～–—·・‧/／「」『』“”‘’（）《》〈〉【】〖〗〔〕［］｛｝＿﹏●•]"
  show regex(han-or-punct + " "): it => it.text.clusters().first()
  show regex(" " + han-or-punct): it => it.text.clusters().last()
  set smartquote(enabled: false)
  show link: it => underline(text(fill: blue, it))

  show: init-glossary.with(())

  set document(title: title, author: author)
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"), lang: "zh", region: "cn")
  show raw: set text(font: ("Noto Sans Mono CJK SC"))

  // This template is based on ilm
  // Cover page.
  page(align(left + horizon, block(width: 90%)[
    #let v-space = v(2em, weak: true)
    #text(3em)[*#title*]

    #v-space
    #text(1.6em, author)

    #v-space
    #block(width: 80%, abstract)
  ]))

  outline()

  pagebreak()

  set math.equation(numbering: "(1)")

  // Wrap `body` in curly braces so that it has its own context. This way show/set rules
  // will only apply to body.
  {
    set heading(numbering: "1.")
    body
  }

  pagebreak()

  // TODO: make glossary-enable auto?
  if glossary-enable {
    heading(numbering:none, "术语索引")
    glossary()
  }

  // Display indices of figures, tables, and listings.
  let fig-t(kind) = figure.where(kind: kind)
  let has-fig(kind) = counter(fig-t(kind)).get().at(0) > 0
  context {
    show outline: set heading(outlined: true)
    let imgs = has-fig(image)
    let tbls = has-fig(table)
    let lsts = has-fig(raw)
    if imgs { outline(title: "图索引", target: fig-t(image)) }
    if tbls { outline(title: "表格索引", target: fig-t(table)) }
    if lsts { outline(title: "代码块索引", target: fig-t(raw)) }
  }

  context bibliography(bibs.final())
}
