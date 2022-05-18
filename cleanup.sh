#!/bin/bash

cd $(dirname $0)
rm -fr 001 002 003 004 005 006 007 008 009 010
git reset --hard HEAD

EDIR=$(readlink -f . | sed "s;^${HOME};~;")
cat <<EOM
問題を初期状態に戻しました。
もし問題のディレクトリにいた場合は、以下の操作で入り直して下さい。

$ cd ${EDIR}
$ cd 問題番号のディレクトリ
EOM

