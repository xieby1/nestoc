#import "../../lib.typ": nestoc
#let nestoc_fn(
  heading_offset: 0,
) = (
title: "父模块的题目",
author: "xieby1",
chapter-pagebreak: false,
body: [
父模块被嵌套到了总文档中，以二级标题为基础。
即各级标题偏移+2。
其各级标题映射关系如下：

#table(
  columns: 2,
  [*父模块*], [*总文档*],
  [题目]    , [二级标题],
  [一级标题], [三级标题],
  [..]      , [..]      ,
)

= 父模块的一级标题

父模块的一级标题下方的的内容

#{
  import "./child/main.typ": nestoc_fn
  nestoc(nestoc_fn, heading_offset: heading_offset+1)
}
])
#nestoc(nestoc_fn)
