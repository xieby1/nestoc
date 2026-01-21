#let template(nestoc_object) = {
  import "@preview/ilm:1.4.1"
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"))
  show: ilm.ilm(
    title: nestoc_object.title,
    author: nestoc_object.author,
    nestoc_object.content()
  )
}
