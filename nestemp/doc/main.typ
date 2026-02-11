#import "../../lib.typ": nestoc, nestemp
#let nestoc_fn(heading_offset:0) = (
title: "Nestemp模板",
author: "xieby1",
abstract: [Nestoc的默认模板。],
body: [
= 使用

= 可选功能

== 术语管理

TODO

#nestemp.set-secret-level(n:0)[
== 秘密等级管理

#nestemp.set-secret-level(n:2)[
TODO

秘密等级分为4级，由不同颜色的页边标识：

- #text(fill:red   )[■]红：仅项目管理者、核心参与者可见
- #text(fill:yellow)[■]黄：仅项目管理者、核心参与者、普通参与者可见
- #text(fill:green )[■]绿：仅项目管理者、核心参与者、普通参与者、企业内部所有人可见
- #text(fill:white )[■]白：所有人可见
]

TODO
]

])
#nestoc(nestoc_fn)
