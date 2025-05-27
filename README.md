# my-typst

- typst で色々な書類を書くためのテンプレート
- Template for writing any document with typst

## 特徴

- [KZNS/cjk-unbreak](https://github.com/KZNS/cjk-unbreak) を利用することで、[typst/typst #792](https://github.com/typst/typst/issues/792) の、CJKにおける改行時の空白問題に対処

## dir

- mystyle\_report/: 私の環境でのレポート用
- note/: ノート（メモ）用。表紙がない
- report/: レポート用
- test/: 試験的に使うディレクトリ

---

# 参考文献

## GitHub

- [修論用のTypstのテンプレート](https://github.com/yukukotani/typst-coins-thesis)
- [日本語文書向け Typst テンプレート（大学生向け&自己流）](https://github.com/stepney141/my_typst_template)
- [Typst で日本語論文を書くときのテンプレート](https://github.com/kimushun1101/typst-jp-conf-template)
  - PDF: [https://kimushun1101.github.io/typst-jp-conf-template/typst-jp-conf.pdf](https://kimushun1101.github.io/typst-jp-conf-template/typst-jp-conf.pdf)

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

このレポジトリにある typst ファイルは
`Noto Serif CJK JP` や `Noto Sans CJK JP` を多様している（依存している）．<br>
これらを追加する例をあげてみる．

### 方法１: インストール

Arch Linux では次で可能である．

```
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
```

また，`fontconfig` パッケージを利用することで `fc-list` といった便利なコマンドや，
pacman や aur にない場合でも `/usr/local/share/fonts/`
に配置してインストールなどができる．

先ほどのコマンドで追加が確認できない場合（typst 0.12.0 (737895d7) など）では，
[後述の環境変数に追加](#環境変数に追加)を行う．

#### 環境変数に追加

`TYPST_FONT_PATHS` という環境変数にフォントがあるパスを追加する．
.ttf があるフォルダを直接指定せず，親ディレクトリを指定しても良い（その分遅くなるが）．
私は，`/usr/share/fonts/noto-cjk/` を指定している．

例えば fish shell だと次を設定ファイルに**追記**する．

```
set -gx TYPST_FONT_PATHS /usr/share/fonts/noto-cjk/
```

bash であれば次を**実行**する．

```
export TYPST_FONT_PATHS=/usr/share/fonts/noto-cjk/
```

前述の通り，親ディレクトリの`/usr/share/fonts/` を指定しても正常に動作する（その分遅くなるが）．

### 方法２: ローカルで指定

例えば`mystyle_report/`の構成のように，フォントを格納するディレクトリを作成する（ここでの例は`fonts/`）．<br>
次に，そのディレクトリにフォントファイルを格納する．フォントの種類は次の４つが可能らしい．

`.ttf`，`.ttc`，`.otf`，`.otc`

その後，コンパイル等のたびに`--font-path`オプションを使えば良い．適用できているか確認する方法の例は次．

```
typst fonts --font-path ./fonts/
```

先ほどのコマンドで追加が確認できない場合（typst 0.12.0 (737895d7) など）では，
[後述の環境変数に追加](#環境変数に追加)を行う．

### Windows環境

以下が必要になるかもしれないとの情報を見かけた記憶がある．

```
typst --font-path /System/Library/Fonts watch main.typ
```
