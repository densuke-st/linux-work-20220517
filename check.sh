#!/bin/bash

cd $(dirname $0)

# 問題1
check001() {
    test -f 001/foo
    return $?
}
check002() {
    echo "問題2 確認中"
    if [ ! -f 002/bar ]; then
        echo "barがありません"; return 1
    fi
    local foo bar
    foo=$(sha1sum < 002/foo)
    bar=$(sha1sum < 002/bar)
    if [ "${foo}" = "${bar}" ]; then
        return 0
    else
        echo "fooとbarの内容が異なります"
        return 1
    fi
}

R=NG
check001 && R=OK
echo "問題1 ${R}"

R=NG
check002 && R=OK
echo "問題2 ${R}"
