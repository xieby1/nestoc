#import "/lib.typ": nestoc, nestemp
#let nestoc_fn(heading_offset: 0) = (
title: "测试title-label",
title-label: <parent_title>,
author: "xieby1",
body: [
  @parent_title 提出了...

  #{import "child/main.typ":nestoc_fn; nestoc(heading_offset:heading_offset+1, nestoc_fn)}
]); #nestoc(nestoc_fn)
