// TODO: API check
#import "./nestemp/lib.typ" as nestemp
#let nestoc(nestoc_fn, heading_offset: 0, template0: nestemp.template0, templateN: nestemp.templateN) = {
  let nestoc_obj = nestoc_fn(heading_offset: heading_offset)
  let body = nestoc_obj.remove("body")
  if heading_offset == 0 {
    template0(..nestoc_obj, body)
  } else {
    templateN(heading_offset, ..nestoc_obj, body)
  }
}
