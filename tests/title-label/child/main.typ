#import "/lib.typ": nestoc, nestemp
#let nestoc_fn(heading_offset:0) = (
title: "子测试title-label",
title-label: <child_title>,
author: "xieby1",
body: [
  @child_title 提出了...
]); #nestoc(nestoc_fn)

