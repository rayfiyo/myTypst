#import "@preview/codelst:2.0.2": sourcecode, sourcefile, lineref, code-frame
#import "@preview/obsidius:0.1.0": *
#set text(font: "Noto Serif CJK JP", size: 12pt)
#set figure(supplement: [図])
#set math.equation(supplement: [式], numbering: "(1)")
#show <b>: set text(fill: blue) // 青字
// チートシート: https://github.com/rayfiyo/my-typst/blob/main/note/main.typ

/*
#bibliography("references.yml", title: "参考文献", style: "ieee")

= チートシート

== jneug/typst-codelst

#sourcecode(numbers-start: 1)[```c #include <stdio.h> ```]

== l0drex/obsidius

#show: notes.with("l0drex / obsidius");

// https:github.com/l0drex/obsidius/blob/main/packages/preview/obsidius/0.1.0/sample/sample.typ

/ タイトル: 青色の枠 📖
#quote(attribution: "タイトル")[灰色の枠💬]
#warning[黄色の警告]
#solution[緑の解決策]
#questions[グレーの質問、枠なし]
- 図
  #figure(caption: "これは図だと言われている", table(
    columns: (auto, auto, auto), //
    table.header([Feature], [Default], [This template]), //
    [Modern style], [#emoji.crossmark], [#emoji.checkmark.box], //
    [Colorful boxes], [#emoji.crossmark], [#emoji.checkmark.box], //
  ))
- 数式 と 引用
  $ A = mat(1, 2;3, 4) $ <eq1>
  @eq1 を表示（引用）
  - 表 と 引用
    #figure(
      table(
        columns: (7em, auto), align: (left, left), inset: 10pt, // columns: 2, なども可
        [名称], [値], //
        [A], [2], //
        [B], [6], //
      ),
    ) <tbl1>
    @tbl1 を表示（引用）
  - URL埋め込み
    #link("https://typst.app/docs")[公式ドキュメント]
  - 画像 と 引用// #figure(image("images/hoge.png", width: 80%), caption: [ 分圧のグラフ ]) <img1>
    // @img1 を表示（引用）
  - *太い赤字*<r>
*/
