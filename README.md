# MTStoMP4_batch

## 背景

.mtsを.mp4に変換する  [http://note.chiebukuro.yahoo.co.jp/detail/n162202](http://note.chiebukuro.yahoo.co.jp/detail/n162202)  
でやってることをバッチ化しました。

## 対象とするMTSファイル

映像がAVC/H.264 High  
音声がDolby AC-3  2.0ch(2/0 L+R)  
なら成功します。

ただバッチの前半で拡張子が.mtsではない時は変換しないように設定してるので、バッチの拡張子判定の部分を消せば、tsMuxeRの対応形式なら問題なくいくと思います。

## 依存するプログラム

- **tsMuxeR**　[[ダウンロード↓]](http://www.videohelp.com/tools/tsMuxeR)  
映像と音声を分離するのに使った。使い方は  
http://freesoft.tvbok.com/movie_encode/h264/mp4-ts-m2ts-demux.html
- **neroAacEnc.exe**　[[ダウンロード↓]](http://ftp6.nero.com/tools/NeroAACCodec-1.5.1.zip)  
音声を.wavから.aac(.m4a)にするのに使用  
http://note.chiebukuro.yahoo.co.jp/detail/n136981
- **MP4Box.exe**　[[ダウンロード↓]](http://sdmr.sblo.jp/)  
映像と音声を合体（結合）させるのに使った。MP4Box (binary | library | DL)から。使い方詳細は  
http://note.chiebukuro.yahoo.co.jp/detail/n155574
- **BeSweet.exe**　[[ダウンロード↓]](https://mega.nz/#!SkEkXLRD!R6M4QABUPCUVzmYw7WoUcFUbUWEq5lW0cYGcBlXo57g)  
MD5：`0b4d96e10c3d9d5752d01eb800e83056`  
SHA-1：`034586025ab49aec4a67b87949eb8901acd9fafb`  
バッチファイル中で.aacを.wavに変換するのに使用。  
**BeLight.exe**も梱包。  
あっちこっち探しても見つからないので、結構貴重かも。  
勝手にアップしてるので作者様から怒られないか心配。

## 使い方
基本的に`.mts`形式の動画をバッチファイルにD&Dすればいい。

初回のみ`.ini`ファイルを作るかと聞いてくるので、yesとかしておいてダイアログに従ってパスを入力していけば、次回からはいちいちパスを入れずに済みます。  
バッチ（`.bat`）と設定ファイル（`.ini`）が同じパスにないと、そして`.ini`で指定しているパスにファイルが無いと失敗します。ご注意ください。

## LICENSE

Boost Software License, Version 1.0.

## memo

tsMuxeR.exeの情報少なすぎ・・・。コマンドラインから使う方法がどこにも書いてないの。全く・・・。  
[http://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q1055090665](http://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q1055090665)  
これを見て、やっと解決策を思いつきました。

demuxにffmpegを使わないのはinputファイルによってコマンドが違うとかでよくわからないから。対応形式を増やすことにあまり意味が見出せない。やりたきゃ勝手にやってくれ。

```
ffmpeg -i [FilePath]\[FileName].mts -vcodec copy -an [FilePath]\[FileName].264
ffmpeg -i [FilePath]\[FileName].mts -acodec copy [FilePath]\[FileName].aac
```

とかすればいいんだとは思うんだけど。めんどい。

## バッチファイル作成中にお世話になったサイト・文献

- バッチファイルの作成がうまくいかない｜Yahoo!知恵袋  
[http://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q11105154031](http://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q11105154031)
- 指定したＵＲＬを開くコマンド｜OKWAVE  
[http://okwave.jp/qa/q1606422.html](http://okwave.jp/qa/q1606422.html)
- set | コマンドプロンプトを使ってみよう  
[http://ykr414.com/dos/dos04.html#25](http://ykr414.com/dos/dos04.html#25)
- バッチファイルの制御用コマンド  
[http://www.fpcu.jp/dosvcmd/batch.htm#if](http://www.fpcu.jp/dosvcmd/batch.htm#if)
- TSファイルに一括変換  
[http://s86ed1.exblog.jp/12438664/](http://s86ed1.exblog.jp/12438664/)
- 地デジTSファイル編集｜eggtoothcrocの日記  
[http://d.hatena.ne.jp/eggtoothcroc/20100514/p1](http://d.hatena.ne.jp/eggtoothcroc/20100514/p1)
- パソコン・ハードディスク入門｜高作義明  
ISBN：4-06-132800-ｘ
