#import "@preview/codelst:2.0.2": sourcecode, sourcefile, lineref, code-frame

#let font_sizes = (h1: 18pt, h2: 16pt, h3: 14pt, normal: 11pt, math: 12pt)
#let spacing_size = 1.2em

#set heading(numbering: "1.")
#set math.equation(supplement: [式], numbering: "(1)")
#set text(font: ("Noto Serif CJK JP"), size: font_sizes.normal)
#set par(
  first-line-indent: 1em, leading: 1em, spacing: spacing_size, justify: true,
)
#set page(
  paper: "a4", margin: (bottom: 1.75cm, top: 2.5cm, left: 2cm, right: 2cm),
)

#show heading: it => {
  par(text(size: 0pt, "")); v(- spacing_size / 2); it
  par(text(size: 0pt, "")); v(- spacing_size / 2)
}

// 表紙

#align(center + horizon)[
  #set text(size: font_sizes.at("h1"))

  #text([タイトル], size: 36pt)

  #text([サブタイトル])

  #v(60pt)

  #text([著 者])

  #text(size: 16pt)[
    #datetime.today().year() 年
    #datetime.today().month() 月
    #datetime.today().day() 日
  ]
]

#pagebreak()

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
