#import "../lib.typ" as nestemp
#show: nestemp.init-glossary.with((
  UCAS: "University of Chinese Academy of Sciences"
))
#show: nestemp.template0.with(
  title: "Nestemp",
  author: "xieby1",
  abstract: [The default template for Nestoc],
)

= 总测试

== 空格测试

多行
不会
出现
空格

中间 也不要有 空格

 交 替 空 格 也 不 要 有

 强制~~空~格~可以使用\~

== 智能引用

"不要搞智能引用"

“我自己知道切换中文引号”

“I know what I am doing”

"So don't be over smart"

== 代码块

=== 自动编号

```c
// 🐱
int main(void) {
  return 0;
}
```

== Glossary @UCAS:short

@UCAS

@UCAS
