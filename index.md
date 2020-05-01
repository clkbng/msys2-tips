# MSYS2を使う
需要がない

__※MSYS2の紹介のような記事であり、具体的なインストール方法などは載っていません。__

## MSYS2とは
[https://www.msys2.org/](https://www.msys2.org/)

Windows上で動作するLinux __風__ ターミナル環境。  
同様のプロジェクトで歴史のある[Cygwin](https://www.cygwin.com/)からフォークされたMSYSを、さらに大改良しMSYS2として現在も開発が進んでいるプロジェクト。

## Cygwin/MSYS2の特徴
- WSLなどと違い、仮想環境ではない
    - パスは内部でWindowsネイティブに変換される
    - Linuxの基本コマンドやpacman(後述)で入るコマンド・パッケージは全てWin用バイナリ(PEフォーマット)
    - Windowsのディレクトリ空間にはほぼアクセスできる[^drive]

[^drive]: MSYS2内部からは(例えば)Cドライブが/c/にマウントされてるように見える。何故かルートディレクトリでlsしても見えないが、この辺の詳細はCygwinと仕様が異なるらしい。

## Cygwin/MSYS2の利点
- メモリ使用量や起動速度など、 __総じて軽い__
- Cygwin/MSYS2空間内でインストール・ビルドしたバイナリは全てWinネイティブなので、同じくWinネイティブの外部ツールから呼び出すことができる[^msysdll]
    - 例えば[Atom](https://atom.io/)のLinterからコンパイラを呼び出したい場合とか[^atom]
- 逆にexe形式のGUIインストーラーとかで普通にインストールしたWinネイティブの外部ツールもターミナルから実行できる(後述)
- cmd.exeなどから呼び出すようなWinネイティブのCUIアプリもだいたい使える
    - 「使おうと思えば」の話
    - 扱う際には若干のコツが必要(後述予定)
- 通常できることの範囲内であれば、基本的にWSLより処理が速い
- MinGWよりもPOSIX互換性が高い
    - 例えばC言語で呼び出すシステムコール(sys/foo.h)はWin32 API等に適切に変換される

[^msysdll]: ただし実行時にUnix共有ライブラリ群(libfoo.so)をラップしたDLL群(libfoo*.dll)を読み込む必要がある。
[^atom]: 私自身使用したことがないので原理はわからないが、VSCodeではWSL内のコンパイラを問題なく呼び出せるらしい。Atomでもbatをゴリゴリ書けば一応できるはずなのだが筆者は断念した。

## Cygwin/MSYS2の欠点
- __Linux向け実行バイナリは実行できない__
    - Linux向けバイナリを作成したい場合は[クロスコンパイル](https://ja.osdn.net/projects/msys2-crossgcc/howto/install)が必要
- カーネルやデーモンなどに関するLinuxの一部機能は使えない
    - systemctlとかそういうの
    - ~~WSLでもうまく動かないことが多いか~~
- sudoができない
    - MSYS2空間内では基本的に全てroot権限になってしまう
    - Windows空間のシステム部分を弄る際はターミナル自体を管理者権限で実行する必要あり、ただし非推奨かつ完全でない
- Javaの開発は地獄
    - Win上でのJVMのクソofクソ実装によるもの

## MSYS2固有の利点(Cygwinとの比較)

- __[pacman](https://wiki.archlinux.jp/index.php/Pacman)を使用できる__
    - Arch Linux由来の優秀なパッケージマネージャー
    - 各ライブラリやソフト(コマンド)をビルド済みパッケージとしてインストールできる
    - 実はtmuxなんかも使える
- ある程度のLinuxとpacmanの知識があればMSYS2/Cygwin固有の知識はほぼいらない
    - CygwinみたいにGitをwgetする所から始めなくてもいい(\$pacman -S git)
- 何故か日本人にやたら人気があるので日本語のリファレンスはそこそこ
    - [Twitter検索](https://twitter.com/search?vertical=default&q=MSYS2&src=typd)でも妙に日本語ツイートが多い
- MinGW互換のターミナルを起動することもできる
    - ~~ほぼ使ったことない~~[^mingw]

[^mingw]: コンパイル後のWin向けバイナリはMSYS2よりも速かったりするらしいが、システムコールでバグったりするので基本的に使うべきでない。

## MSYS2固有の欠点(Cygwinとの比較)
- 総人口としてはWSLやCygwinより遥かにマイナー
- pacmanでインストールできないパッケージをCygwin用オプションでビルドしようとすると死ぬことがある
    - MSYS2向けのTIPSなんて99.9%書いてない
    - 筆者もTeX LiveインストーラーでやらかしてMSYS2を破壊した経験あり
- たまにMSYS2やMSYS2向けパッケージ(pacmanリポジトリ)固有のバグがある
- pacmanのリポジトリ全てがMSYS2向けに提供されているわけではない
    - 本来はArch Linux向けなので、システム的にコンパイルや動作が不可能なものもある
    - MSYS2チームのビルドが追い付いていない場合もある
        - どうしても使いたい場合は自力でビルドするのも手
- CygwinよりPOSIX互換性が若干落ちるかもしれない
    - ほぼ誤差だとは思う
- 内部ファイル/ディレクトリのパーミッションがおかしくなったりする
    - Permission Deniedが発生したり、逆に緩すぎるせいでgitコマンドで怒られたりする
    - Windowsのパーミッションがカオスなので致し方なし

## TeX Liveのインストール
※工事中

## winpty, wincmd
※工事中

## MSYS2でビルドする際のコツ
- とりあえず(あれば)Linux全般向けのオプションを試してみる
- __gccのstdオプションをgnuに変更する__
    - 例)\-std=c++11 → \-std=gnu++11
- autoconfを使う場合は\-\-build x86\_64\-pc\-msysをつける
    - libtoolのリンクオプションで\-no\-undefinedを指定しないと駄目っぽい
- 余力があれば\-march=nativeをつける
- どうしてもダメな場合はCygwinやMinGW、Windows(cmd)向けオプションを適当に切り貼りしながら頑張る
- pacmanで依存先ライブラリをインストールする[^package]
- pacmanで依存先ライブラリを更新する
- 自動でパスが通るタイプのパッケージの場合、ビルド後にパスがうまく通ってない場合が多い(※体感)ので、その場合は自分で.bashrcに追記して通す

[^package]: MSYS2に限らないが、ライブラリのビルトに必要なライブラリをビルドするのはマジで地獄なので極力避けた方が良い。

## ログインシェルについて
いくつかの方法でデフォルトのBashから変更することもできる。シェル自体はpacmanで入手できる場合が多い。[^shells]  
実際に筆者は2週間ほど[^zsh_use]試験的にZshを使用しており、今のところ目立った不具合などもなく起動は若干早くなったような気がする。ただし.zshrcを若干書かないと使いにくいかも。  
[.zshrc記述例](zshrc)

一方、fish shellはZshと同様にpacmanでインストールできるものの、私の環境では不具合があったので導入を断念した。  
Zshと比べて移行コストが大きいこともあり個人的にはそこまで突き詰めようと思わないが、勇気ある人はチャレンジするのもいいかもしれない。

[^shells]: pacmanで提供されてるだけでも、本文で挙げた以外にDash,tcsh,ksh(mksh)などを確認できる。
[^zsh_use]: この版の執筆時点(2020/05/01)を基準として。

## 外部ターミナルでのログイン
cmd.exeのコマンドライン内部でMSYS2にログインする例

```
C:\Users\user1> C:\msys64\msys2_shell.cmd -no-start -defterm -here
user1@DESKTOP-XXXXXXX:/c/Users/user1$
```

IDE/エディタの内臓ターミナルでもだいたい同様に行けるはず

## 外部GUIアプリの呼び出し
```shell
$ /c/PROGRA~1/path/to/app.exe arg1 arg2 &
```

のように実行すれば普通に実行できる。  
ただし、/c/以下ではなくMSYS2内部のパスで実行するとアプリの拡大率がおかしくなる場合がある。  
MSYS2(というかMintty)の設定が反映されてしまうらしい。 

以下[サクラエディタ](https://sakura-editor.github.io/)の例。[^progra]

[^progra]: PROGRA&tilde;2は&quot;Program Files (x86)&quot;のMS-DOS互換パス名。これ自体はWindowsの元々の機能。同様に先述のPROGRA&tilde;1は&quot;Program Files&quot;を指す。


```bash
user1@DESKTOP-XXXXXXX:~ $ /c/PROGRA~2/sakura/sakura.exe foo.txt &
# OK
user1@DESKTOP-XXXXXXX:~ $ ln -s /c/PROGRA~2/sakura/sakura.exe sakura
user1@DESKTOP-XXXXXXX:~ $ ./sakura foo.txt &
# NG
user1@DESKTOP-XXXXXXX:~ $ unlink sakura
user1@DESKTOP-XXXXXXX:~ $ cd /usr/bin
user1@DESKTOP-XXXXXXX:/usr/bin $ ln -s /c/PROGRA~2/sakura/sakura.exe sakura
user1@DESKTOP-XXXXXXX:/usr/bin $ cd ~
user1@DESKTOP-XXXXXXX:~ $ sakura foo.txt &
# NG 
```

どうしても\$PATHからコマンドで呼び出したい場合、以下のようなシェルスクリプトを設定したい\$PATH内の適当なディレクトリ[^pathdir]に置く。  
または.bashrcにaliasとして設定する。

```bash
#!/bin/sh
/c/PROGRA~2/sakura/sakura.exe ${*} & 
# filename : sakura (command name)
```

[^pathdir]: 筆者は/usr/local/binにしている。

## 結論
~~__おとなしくWSLを使った方がいい。__~~  

- 1KiB,1msecでも軽さや速さを求めたい
- WSLを動かすのが厳しいぐらいPCのスペックが低い
- 物理デバイスとの接続が必要な場合
    - WSLでは厳しいケースがあるらしい
- Docker for Windowsを使うのでWSLとの相性が悪い
- aptに親を殺されたのでどうしてもpacmanを使いたい

以上のいずれか一つでも当てはまる人は使う価値があると思います。  
~~突き詰めるとArch入れた方が速いとか言わない。~~

## お問い合わせ
本記事で不明な点があったら著者の[CLK](https://twitter.com/CLK_rhythm)に聞いてください。  
運良く知っていれば答えられます。  
また内容が間違ってたらご指摘頂けるとありがたいです。

それでは、良い開発 on Windowsライフを。

<a href="https://twitter.com/intent/tweet?text=MSYS2%E3%82%92%E4%BD%BF%E3%81%86%20%7C%20msys2-tips&tw_p=tweetbutton&url=https%3A%2F%2Fclkbng.github.io%2Fmsys2-tips%2F" style="background-color:#55acee;padding:4px 8px;color:#eee;text-decoration:none;margin:3em;margin-left:0em;margin-bottom:1em;display:inline-block" target="_blank">Tweet</a>

---

