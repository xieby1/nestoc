/*typ*//* #import "/lib.typ": nestoc, nestemp; #let nestoc_fn(heading_offset:0) = (
  title: "Nestemp模板", title-label:<chap:nestemp>,
  author: "xieby1",
  abstract: [Nestoc的默认模板。],
  body: [
*/

// TODO: doc
#let numbering(start:1, len:1, code) = {
  show raw.line: line => {
    let str_num = str(line.number + start - 1)
    // padding left
    if str_num.len() < len { str_num = [~]*(len - str_num.len()) + str_num }
    text(fill:gray, str_num); [~]; line.body
  }
  code
}

/*typ*//*
  = 参考文献管理

  ```typ
  #nestemp.add-bib(read(encoding:none, "<xxx.bib>"))
  ```

  TODO
*/
#let bibs = state("__bibs", ())
#let add-bib(path) = bibs.update(old => {
  if old == none { old =   (path,) }
  else           { old.push(path)  }
  old
})

/*typ*//*
  = 秘密等级管理

  ```typ
  #show: nestemp.set-secret-level.with(n:<secret-level>)
  ```

  秘密等级分为4级，由不同颜色的页边标识：

  #let s0 = [红#text(fill:red   )[■]]
  #let s1 = [黄#text(fill:yellow)[■]]
  #let s2 = [绿#text(fill:green )[■]]
  #let s3 = [白#text(fill:white )[■]]
  #let s_ = [无]

  0. #s0：仅项目管理者、核心参与者可见
  1. #s1：仅项目管理者、核心参与者、普通参与者可见
  2. #s2：仅项目管理者、核心参与者、普通参与者、企业内部所有人可见
  3. #s3：所有人可见

  秘密等级的规则：

  - 标记了的秘密等级的文档：
    - `secret-level(父文档) <= secret-level(子文档)`
    - 即父文档的秘密等级 不能弱于 子文档的秘密等级
  - 未标记秘密等级的文档：不受限制

  一些例子：

  #figure(caption: [秘密等级规则的例子], table(columns:3,
    [*父文档*], [*子文档*], [],
    s2, s2, [✅],
    s2, s3, [✅],
    s3, s2, [❌],
    s2, s_, [✅],
    s_, s2, [✅],
  ))
*/
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

/*typ*//*
  = 术语管理

  ```typ
  #show: nestemp.init-glossary.with(<terms>)
  ```

  其中terms的用法参考https://github.com/swaits-typst-packages/glossy。
*/
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

#let template0(title:"", title-label:none, author:"", abstract:[], compact:true, body) = {
  // https://guide.typst.dev/FAQ/chinese-remove-space
  let han-or-punct = "[-\p{sc=Hani}。．，、：；！‼？⁇⸺——……⋯⋯～–—·・‧/／「」『』“”‘’（）《》〈〉【】〖〗〔〕［］｛｝＿﹏●•]"
  show regex(han-or-punct + " "): it => {
    // https://forum.typst.app/t/how-to-define-a-regex-show-rule-that-doesnt-apply-in-raw-blocks/4241/4
    // Noted: the text.font use small case
    if text.font == "jetbrains maple mono" { it }
    else { it.text.clusters().first() }
  }
  show regex(" " + han-or-punct): it => {
    // https://forum.typst.app/t/how-to-define-a-regex-show-rule-that-doesnt-apply-in-raw-blocks/4241/4
    // Noted: the text.font use small case
    if text.font == "jetbrains maple mono" { it }
    else { it.text.clusters().last() }
  }

  set smartquote(enabled: false)
  show link: it => underline(text(fill: blue, it))

  show: init-glossary.with(())

  set document(title: title, author: author)
  set page(numbering: "1")
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"), lang: "zh", region: "cn")
  show raw: set text(font: ("JetBrains Maple Mono"))

  // This template is based on ilm
  // COVER
  let cover(body) = {
    if compact { body }
    else { page(align(left + horizon, block(width: 90%, body))) }
  }

  show ref.where(form:"normal"): it => { if it.target==title-label {"本文"} else {it} }
  cover({
    {
      show figure: set align(start);
      [#figure(kind:"title", supplement:none, text(3em)[*#title*]) #title-label]
    }
    v(2em, weak: true)
    text(1.6em, author)
    v(2em, weak: true)
    block(width: 80%, abstract)
  })

  // TOC
  context if counter(heading).final().at(0) > 0 {
    outline()
    if not compact { pagebreak() }
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
      if not compact { pagebreak() }
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

#let templateN(heading_offset, title:"", title-label:none, author:"", abstract:[], body) = {
  grid(columns: (1fr, auto),
    // Naturally, it is better to write heading(title, depth:0)
    // But depth only supports positive integer.
    [#heading(title, level:heading_offset) #title-label],
    text(fill: gray, author)
  )
  abstract
  set heading(offset: heading_offset)
  body
}

/*typ*//*
]); #nestoc(nestoc_fn)
*/
