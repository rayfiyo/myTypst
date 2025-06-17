#import "@preview/codelst:2.0.2": sourcecode, sourcefile, lineref, code-frame
#import "@preview/cjk-unbreak:0.1.0": remove-cjk-break-space

#let font_sizes = (h1: 18pt, h2: 16pt, h3: 14pt, h4: 12pt, normal: 11pt, math: 12pt)
#let code_fonts = ("UDEV Gothic 35NF")
#let math_fonts = ("New Computer Modern Math")
#let serif_fonts = ("New Computer Modern", "IPAexMincho", "Noto Serif CJK JP")
#let sans_fonts = ("Noto Sans CJK JP", "IPAexGothic")
#let leading_size = 1.0em
#let spacing_size = 1.2em

#set heading(numbering: "1.")
#set math.equation(supplement: "式", numbering: numbering.with("(1.1)"))
#set text(font: serif_fonts, size: font_sizes.normal)
#set par(
  first-line-indent: 1em, leading: leading_size, spacing: spacing_size, justify: true,
)
#set page(
  paper: "a4", columns: 2, margin: (bottom: 1.75cm, top: 2.5cm, left: 2cm, right: 2cm),
)

#show figure.where(kind: image): set figure(supplement: "図")
#show figure.where(kind: table): set figure(supplement: "表")
#show math.equation: set text(font: math_fonts, size: font_sizes.math)
#show raw: set text(font: code_fonts, size: font_sizes.normal)
#show heading: it => {
  par(text(size: 0pt, "")); v(- spacing_size / 2)
  text(font: serif_fonts, weight: "light")[#it]
  par(text(size: 0pt, "")); v(- spacing_size / 2)
}
#show: remove-cjk-break-space // from @preview/cjk-unbreak

// ヘッダ

#place(
  top + center, scope: "parent", float: true, text(size: font_sizes.h4, weight: "bold")[
    #set par(leading: leading_size * 0.9, spacing: spacing_size * 1.2)

    #line(length: 100%)
    論文のタイトル\
    すげえよな，論文って（あまりにも浅い）
    #line(length: 100%)
  ],
)

#place(top + left, scope: "parent", float: true, text(font: sans_fonts)[
  著者１ #h(1fr) email\@example.com\
  著者２ #h(1fr) email\@example.com\
])

// 概要

#align(center)[ = Abstract ]
#table(stroke: none, columns: (1fr), inset: 10pt)[
  論文の概要を書けます，図形にしていることで一回り小さく表示されます．
]

// 本文

= チートシート

== コードブロック

#sourcecode(numbers-start: 1)[```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```]

== 数式 と 引用

$ A = mat(1, 2;3, 4) $ <eq1>

@eq1 を表示（引用）

== 画像 と 引用

#figure(image("appendix/images/ladder.svg", width: 10%), caption: [
  A step in the molecular testing pipeline of our lab.
]) <img1>

@img1 を表示（引用）

== 表 と 引用

#figure(
  table(
    columns: (7em, auto), align: (left, left), inset: 10pt, // columns: 2, なども可
    [名称], [値], //
    [A], [2], //
    [B], [6], //
  ),
) <tbl1>

@tbl1 を表示（引用）

== URL埋め込み

#link("https://typst.app/docs")[公式ドキュメント]
