// TODO: add doc
// TODO: add secret levels
// TODO: add heading levels
// TODO: API check
#let template(nestoc_fn) = {
  import "@preview/ilm:1.4.1"
  // These show rules are applied to content before ilm's show rules being applied
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"))
  let nestoc_obj = nestoc_fn()
  ilm.ilm(
    title: nestoc_obj.title,
    author: nestoc_obj.author,
    {
      // These show rules are applied to content after ilm's show rules being applied
      show raw: set text(font: ("Noto Sans Mono CJK SC"))
      set heading(offset: nestoc_obj.heading_offset)
      nestoc_obj.content
    }
  )
}

#let nest(nestoc_fn: none, heading_offset: 0) = {
  let nestoc_obj = nestoc_fn(heading_offset: heading_offset)
  [== #nestoc_obj.title]
  nestoc_obj.content
}
