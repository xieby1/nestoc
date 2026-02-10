// TODO: add secret levels
// TODO: API check
#import "./nestemp/lib.typ": nestemp
#let nestoc(nestoc_fn, heading_offset: 0, template: nestemp) = {
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
