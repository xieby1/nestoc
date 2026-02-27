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

== 秘密等级管理

秘密等级分为4级，由不同颜色的页边标识：

#let s0 = [红#text(fill:red   )[■]]
#let s1 = [黄#text(fill:yellow)[■]]
#let s2 = [绿#text(fill:green )[■]]
#let s3 = [白#text(fill:white )[■]]
#let s_ = [无]

0. #s0：仅项目管理者、核心参与者可见
1. #s1：仅项目管理者、核心参与者、普通参与者可见
2. #s2：仅项目管理者、核心参与者、普通参与者、企业内部所有人可见
3. #s3：所有人可见

秘密等级的规则：

- 标记了的秘密等级的文档：
  - `secret-level(父文档) <= secret-level(子文档)`
  - 即父文档的秘密等级 不能弱于 子文档的秘密等级
- 未标记秘密等级的文档：不受限制

一些例子：

#figure(caption: [秘密等级规则的例子], table(columns:3,
  [*父文档*], [*子文档*], [],
  s2, s2, [✅],
  s2, s3, [✅],
  s3, s2, [❌],
  s2, s_, [✅],
  s_, s2, [✅],
))

])
#nestoc(nestoc_fn)
