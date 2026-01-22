#import "../../../../lib.typ": nestoc
#let nestoc_fn(
  heading_offset: 0,
) = (
title: [孙模块的题目],
author: "xieby3",
chapter-pagebreak: false,
body: [

孙模块被嵌套到子模块中，当然间接地随着子模块被嵌套到了父模块和总文档中。
其各级标题的映射关系如下：

#table(
  columns: 4,
  [*孙模块*], [*子模块*], [*父模块*], [*总文档*],
  [题目]    , [一级标题], [二级标题], [四级标题],
  [一级标题], [二级标题], [三级标题], [五级标题],
  [..]      , [..]      , [..]      , [..]
)

= 孙模块的一级标题

孙模块的一级标题下方的内容

])
#nestoc(nestoc_fn)
