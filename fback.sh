#!/bin/bash

#当日を起点として前日に作成・変更があったファイルのバックアップを取得すスクリプト
tm=`date +%Y%m%d`

bd="$HOME/backup"
if [ ! -d "$bd" ];then
	mkdir "$bd"	
fi

#3・バックアップ対象は一般ファイルのみ。デバイスファイルなど特殊ファイルは含めない
#f=`find ./ -ctime -1 -type f` #相対パスで指定

f=`find "$PWD" -ctime -1 -type f` #絶対パスで指定

#指定したファイルをTar形式でひとつのファイルに纏めて圧縮。対象ファイルは複数指定できる
#tar -czvf "${bd}"/backup-"${tm}".tar.gz $f 
#Verboseオプション無し
tar -czf "${bd}"/backup-"${tm}".tar.gz $f 

