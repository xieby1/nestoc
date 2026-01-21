// TODO: add secret levels
// TODO: API check
#let nestoc(nestoc_fn, heading_offset: 0) = {
  let nestoc_obj = nestoc_fn(heading_offset: heading_offset)
  if heading_offset == 0 {
    import "@preview/ilm:1.4.1"
    // These show rules are applied to content before ilm's show rules being applied
    show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"))
    ilm.ilm(
      title: nestoc_obj.title,
      author: nestoc_obj.author,
      {
        // These show rules are applied to content after ilm's show rules being applied
        show raw: set text(font: ("Noto Sans Mono CJK SC"))
        nestoc_obj.content
      }
    )
  } else {
    heading(nestoc_obj.title, depth: heading_offset)
    nestoc_obj.content
  }
}
