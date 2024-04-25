# myTypst

- typstでレポート・論文を書くためのテンプレート
- Template for writing report and papers in typst
- 本当は branch を作成したかったが，issue が建てられないようなので（要調査）別レポジトリとした．

# GitHub

- [修論用のTypstのテンプレート](https://github.com/yukukotani/typst-coins-thesis)
- [日本語文書向け Typst テンプレート（大学生向け&自己流）](https://github.com/stepney141/my_typst_template)

# 参考文献

- https://zenn.dev/monaqa/articles/2023-04-19-typst-introduction
- https://zenn.dev/chantakan/articles/ed80950004d145
- http://www-het.phys.sci.osaka-u.ac.jp/~yamaguch/j/typst.html

# 追加

```
typst fonts
```

で，`Noto Serif CJK JP` と `Noto Sans CJK JP` がない場合は，以下が必要かも

```
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
```

また，Windows環境では以下も必要かも

```
typst --font-path /System/Library/Fonts watch hoge.typ
```
