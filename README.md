# myTypst

- typst で色々な書類を書くためのテンプレート
- Template for writing any document with typst

## mystyle_report

- 私の環境でのレポート用

## note

- ノート（メモ）用
- 表紙がない

## report

- レポート用

## test

- 試験的に使うディレクトリ

---

# 参考文献

## GitHub

- [修論用のTypstのテンプレート](https://github.com/yukukotani/typst-coins-thesis)
- [日本語文書向け Typst テンプレート（大学生向け&自己流）](https://github.com/stepney141/my_typst_template)

## article

- https://zenn.dev/monaqa/articles/2023-04-19-typst-introduction
- https://zenn.dev/chantakan/articles/ed80950004d145
- http://www-het.phys.sci.osaka-u.ac.jp/~yamaguch/j/typst.html
- https://qiita.com/gomazarashi/items/ddef3d0db22a9f1e08ba

---

# 補足: font について

## 利用可能なフォントの確認方法

```
typst fonts
```

## フォントの追加方法

このレポジトリにある typst ファイルは `Noto Serif CJK JP` や `Noto Sans CJK JP` を多様している（依存している）．<br>
これらを追加する例をあげてみる．

### 方法１: インストール

Arch Linux では次で可能

```
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
```

### 方法２: ローカルで指定

例えば`mystyle_report/`の構成のように，フォントを格納するディレクトリを作成する（ここでの例は`fonts/`）．<br>
次に，そのディレクトリにフォントファイルを格納する．フォントの種類は次の４つが可能らしい．

`.ttf`，`.ttc`，`.otf`，`.otc`

その後，コンパイル等のたびに`--font-path`オプションを使えば良い．適用できているか確認する方法の例は次．

```
typst fonts --font-path ./fonts/
```

### Windows環境

以下が必要になるかもしれないとの情報を見かけた記憶がある．

```
typst --font-path /System/Library/Fonts watch main.typ
```
