// TODO: add secret levels
// TODO: API check
#let default_template(title:"", author:"", abstract:[], body) = {
  // These show rules are applied to body before ilm's show rules being applied
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"), lang: "zh", region: "cn")
  show raw: set text(font: ("Noto Sans Mono CJK SC"))

  // https://guide.typst.dev/FAQ/chinese-remove-space
  let han-or-punct = "[-\p{sc=Hani}。．，、：；！‼？⁇⸺——……⋯⋯～–—·・‧/／「」『』“”‘’（）《》〈〉【】〖〗〔〕［］｛｝＿﹏●•]"
  show regex(han-or-punct + " "): it => it.text.clusters().first()
  show regex(" " + han-or-punct): it => it.text.clusters().last()

  import "@preview/ilm:1.4.2"
  ilm.ilm(
    title: title,
    author: author,
    abstract: abstract,
    chapter-pagebreak: false,
    raw-text: (use-typst-defaults: true),
    figure-index: (enabled: true, title: "图索引"),
    table-index: (enabled: true, title: "表格索引"),
    listing-index: (enabled: true, title: "代码块索引"),
    body
  )
}
#let nestoc(nestoc_fn, heading_offset: 0, template: default_template) = {
  let nestoc_obj = nestoc_fn(heading_offset: heading_offset)
  if heading_offset == 0 {
    let body = nestoc_obj.remove("body")
    template(..nestoc_obj, body)
  } else {
    grid(columns: (1fr, auto),
      // Naturally, it is better to write heading(nestoc_obj.title, depth:0)
      // But depth only support positive integer.
      heading(nestoc_obj.title, level: heading_offset),
      text(fill: gray, nestoc_obj.at("author", default: none))
    )
    nestoc_obj.at("abstract", default: none)
    set heading(offset: heading_offset)
    nestoc_obj.body
  }
}
