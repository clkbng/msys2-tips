# MSYS2を使う
需要がない

## MSYS2とは
https://www.msys2.org/

Windows上で動作するLinux __風__ ターミナル環境。  
同様のプロジェクトで歴史のある[Cygwin](https://www.cygwin.com/)からフォークされ、なんやかんや[^msys1]あって今に至るプロジェクト。

[^msys1]: 2じゃない方のMSYSは前途多難の末、事実上とん挫する形で開発終了したらしい。(知らない)

## Cygwin/MSYS2の特徴
- WSLなどと違い、仮想環境ではない
    - パスは内部でWindowsネイティブに変換される
    - Linuxの基本コマンドやpacman(後述)で入るコマンド・パッケージは全てWin用バイナリ(PEフォーマット)
    - Windowsのディレクトリ空間にはほぼアクセスできる[^drive]

[^drive]: MSYS2内部からは(例えば)Cドライブが/c/にマウントされてるように見える。何故かルートディレクトリでlsしても見えないが、この辺の詳細はCygwinと仕様が異なるらしい。

## Cygwin/MSYS2の利点
- メモリ使用量や起動速度など、 __総じて軽い__
- Cygwin/MSYS2空間内でインストール・ビルドしたバイナリは全てWinネイティブなので、同じくWinネイティブの外部ツールから呼び出すことができる
    - 例えば[Atom](https://atom.io/)のLinterからコンパイラを呼び出したい場合とか[^atom]
- 逆にexe形式のGUIインストーラーとかで普通にインストールしたWinネイティブの外部ツールもターミナルから実行できる(後述)
- cmd.exeなどから呼び出すようなWinネイティブのCUIアプリもだいたい使える
    - 「使おうと思えば」の話
    - 扱う際には若干のコツが必要(後述予定)
- 通常できることの範囲内であれば、基本的にWSLより処理が速い
- MinGWよりもPOSIX互換性が高い
    - 例えばC言語で呼び出すシステムコール(sys/foo.h)はWin32 API等に適切に変換される

[^atom]: 何故か(失礼)VSCodeではWSL内のコンパイラを問題なく呼び出せるらしい。Atomでもbatをゴリゴリ書けば一応できるはずなのだが筆者は断念した。

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
    - Twitter検索とかでも出てくる
    - https://twitter.com/search?vertical=default&q=MSYS2&src=typd
- MinGW互換のターミナルを起動することもできる
    - ~~ほぼ使ったことない~~[^mingw]

[^mingw]: コンパイル後のWin向けバイナリはMSYS2よりも速かったりするらしいが、システムコールでバグったりするので基本的に使うべきでない。

## MSYS2固有の欠点(Cygwinとの比較)
- 総人口としてはWSLやCygwinより遥かにマイナー
- pacmanでインストールできないパッケージをCygwin用オプションでビルドしようとすると死ぬことがある
    - もちろんMSYS2向けのTIPSなんて99.9%書いてない
    - 筆者もTeX LiveインストーラーでやらかしてMSYS2を破壊した経験あり
- たまにMSYS2やMSYS2向けパッケージ(pacmanリポジトリ)固有のバグがある
- pacmanのリポジトリ全てがMSYS2向けに提供されているわけではない
    - 本来はArch Linux向けなので、システム的にコンパイルや動作が不可能なものもある
    - MSYS2チームのビルドが追い付いていないだけの場合もある
        - どうしても使いたい場合は自力でビルドするしかない
- CygwinよりPOSIX互換性が若干落ちるっぽい
    - ほぼ誤差だとは思う

## TeX Liveのインストール
※工事中

## winpty, wincmd
※工事中

## MSYS2でビルドする際のコツ
- とりあえず(あれば)Linux全般向けのオプションを試してみる
- __gccのstdオプションをgnuに変更する__
    - 例)\-std=c++11 → \-std=gnu++11
- 余力があれば\-march=nativeをつける
- どうしてもダメな場合はCygwinやMinGW、Windows(cmd)向けオプションを適当に切り貼りしながら頑張る
- pacmanで依存先ライブラリをインストールする[^package]
- pacmanで依存先ライブラリを更新する
- ビルド後にパスがうまく通ってない場合が多い(※体感)ので、その場合は自分で.bashrcに追記して通す

[^package]: MSYS2に限らないが、ライブラリのビルトに必要なライブラリをビルドするのはマジで地獄なので極力避けた方が良い。

## 外部GUIアプリの呼び出し
```shell
$ /c/PROGRA~1/path/to/app.exe arg1 arg2 &
```
のように実行すれば普通に実行できる。  
ただし、/c/以下ではなくMSYS2内部のパスで実行するとアプリの解像度がおかしくなる場合がある。 

以下サクラエディタの例。[^progra]

```bash
user1:~ $ /c/PROGRA~2/sakura/sakura.exe foo.txt &
# OK
user1:~ $ ln -s /c/PROGRA~2/sakura/sakura.exe sakura
user1:~ $ ./sakura foo.txt &
# NG
user1:~ $ unlink sakura
user1:~ $ cd /usr/bin
user1:/usr/bin $ ln -s /c/PROGRA~2/sakura/sakura.exe sakura
user1:/usr/bin $ cd ~
user1:~ $ sakura foo.txt &
# NG 
```

[^progra]: PROGRA~2は"Program Files (x86)"のMS-DOS互換パス名。これ自体はWindowsの元々の機能。同様に先述のPROGRA~1は"Program Files"を指す。


どうしても\$PATHからコマンドで呼び出したい場合、以下のようなファイルを\$PATH内の適当なディレクトリ[^pathdir]に置く。

```bash:sakura
#!/bin/sh
/c/PROGRA~2/sakura/sakura.exe ${*} & 
```

[^pathdir]: 筆者は/usr/local/binにしている。

## 結論
__おとなしくWSLを使った方がいい。__  
しょぼいノートPC使ってる場合とかAtom使ってる場合とかは検討の余地あり。

## お問い合わせ
恐らく他に誰も使ってないので、わからない点があったら著者の[CLK](https://twitter.com/CLK_rhythm)に聞いてください。  
運良く知っていれば答えられます。