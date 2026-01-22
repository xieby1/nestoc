#import "../lib.typ": nestoc
#let nestoc_fn(
  heading_offset: 0,
) = (
title: "Nestoc 文档",
author: "xieby1",
abstract: [一个模块+嵌套的Typst文档模板。],
body: [
= Nestoc 简介

🪆Nestoc📑 的名称来源于 Nest（嵌套🪆）与 Doc（文档📑）的组合，亦可理解为 Nest + ToC（Table of Contents 目录）。
Nestoc 旨在构建一个支持文档嵌套（或称"模块化"）的 Typst 模板。

设想一个包含多个章节的大型文档项目，
需要由多位协作者分*模块*完成各章节内容，
最终将这些模块*嵌套*整合为统一的完整文档。

- / 模块: 每个章节均为独立、可编辑、可编译、可阅读的自包含文档。
- / 嵌套: 所有章节组合时，标题、编号等元素将自动调整，形成协调一致的最终文档。

*注*：目前 Nestoc 的外观基于 #link("https://github.com/talal/ilm")[ilm] 模板。

#{
  // Can move `import` expression to `nestoc` function?
  // No: typsts throw error: "cannot import from user-defined functions".
  import "./capabilities/main.typ": nestoc_fn
  nestoc(nestoc_fn, heading_offset: heading_offset+2)
}

== 使用方法

= API 文档

])
#nestoc(nestoc_fn)
