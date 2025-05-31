#import "@preview/codelst:2.0.2": sourcecode, sourcefile, lineref, code-frame
#import "@preview/showybox:2.0.4": showybox // 文字の枠
#import "@preview/cjk-unbreak:0.1.0": remove-cjk-break-space
#set text(font: "Noto Serif CJK JP", size: 12pt)
#set figure(supplement: [図])
#set math.equation(supplement: [式], numbering: "(1)")
#show: remove-cjk-break-space // from @preview/cjk-unbreak
#show <b>: set text(fill: blue) // 青字

// = チートシート
//
// - コードブロック
//   #sourcecode(numbers-start: 1)[```c #include <stdio.h> ```]
// - 数式 と 引用
//   $ A = mat(1, 2;3, 4) $ <eq1>
//   @eq1 を表示（引用）
// - 表 と 引用
//   #figure(
//     table(
//       columns: (7em, auto), align: (left, left), inset: 10pt, // columns: 2, なども可
//       [名称], [値], //
//       [A], [2], //
//       [B], [6], //
//     ),
//   ) <tbl1>
//   @tbl1 を表示（引用）
// - URL埋め込み
//   #link("https://typst.app/docs")[公式ドキュメント]
// - 画像 と 引用
//   #figure(image("images/hoge.png", width: 80%), caption: [ 分圧のグラフ ]) <img1>
//   @img1 を表示（引用）
// - *太い赤字*<r>
// #showybox()[文字の枠]
