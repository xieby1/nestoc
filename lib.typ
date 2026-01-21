#let mytemplate(xdoc) = {
  import "@preview/ilm:1.4.1"
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"))
  show: ilm.ilm(
    title: xdoc.title,
    author: xdoc.author,
    xdoc.content()
  )
}
