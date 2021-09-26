# 高専シラバス一括ダウンロード

自分が居た学年とその西暦を入れると、その時に受けた授業のシラバスのPDFを一括ダウンロードします。
国立高専のみ対応しています。

## 使い方

### 0. 依存するパッケージをインストールする。

このプログラムはLinuxかMacでしか動作しません。頑張ってコマンドを入れたらWindowsとかでも動くかもしれませんが、素直にWSLとか使う方が楽だと思います。
依存するコマンドは以下です。

- zsh (シェル)
- pup (HTMLのスクレイピング)
- pdfunite (popplerプロジェクトの一部で、PDFを連結する)

大抵の場合homebrewとかapt-get(apt)とかでインストールできると思います。

#### Mac & Homebrew

```
brew instal zsh pup poppler
```


#### Ubuntu

```
sudo apt install zsh
sudo apt install poppler-utils
```

Ubuntuにはpupパッケージが提供されていないため、GithubのReleaseからシングルバイナリを落としてきてchmod +xしてパスの通った場所に置きましょう。

https://github.com/ericchiang/pup

### 1. 西暦と学年を定義する

main.shの下の部分に、以下のような記述があります。

```
getPDF 2016 1
getPDF 2017 2
getPDF 2019 3
getPDF 2020 4
getPDF 2021 5
joinAllPDF
```

このgetPDFコマンドは、第一引数に西暦、第二引数に学年を取ります。ここを任意の数字に編集してください。
また、留年した場合は同じ学年を複数回書いても構いません。

1年と2年でそれぞれ1回留年した場合の例:
```
getPDF 2016 1
getPDF 2016 2
getPDF 2017 3
getPDF 2016 4
```

### 2. 学校番号を入力する

main.shの最上部に、以下のような記述があります。

```
SCHOOL=14
DEPARTMENT=14
```

これは学校番号と学科番号です。
この数字はシラバスのサイト( https://syllabus.kosen-k.go.jp/Pages/PublicSchools ) から飛べる各校のページのURLから確認できます。
例えば、木更津高専 情報工学学科のURLは https://syllabus.kosen-k.go.jp/Pages/PublicSubjects?school_id=14&department_id=14&year=2021&lang=ja となるため、学校番号が14、学科番号が14だということがわかります。
自分の番号がわかったら編集してください。

### 3. 実行する

ファイルが編集できたら、zshでシェルスクリプトを実行してください。

```
zsh ./main.sh
```

## 出力について

このプログラムは、まずシラバスのPDFを `./pdfs/西暦-学年/` というフォルダにダウンロードします。
その後、それらのPDFを一つにまとめたPDFを `./pdfs/西暦-学年.pdf` という名前で生成します。
最後に、さらにそれらを含めた完全なPDFを `./all.pdf` として生成します。
