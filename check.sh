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

check003() {
    local SHA1
    SHA1="ae8d4eb1f95026da9916eec542d3fb09ec363c5f"
    local R
    echo "問題3 確認中"
    if [ -f 003/fuga ]; then
        echo "fugaが残っています、移動されていません"
        return 1
    fi
    if [ ! -f 003/dest/fuga ]; then
        echo "destディレクトリに移動していません"
        return 1
    fi

    R=$(sha1sum < 003/dest/fuga | awk '{print $1}')
    if [ ! "${R}" = "${SHA1}" ]; then
        echo "移動したファイルが元のものと異なっております"
        return 1
    fi
    return 0
}

R=NG
check001 && R=OK
echo "問題1 ${R}"

R=NG
check002 && R=OK
echo "問題2 ${R}"

R=NG
check003 && R=OK
echo "問題3 ${R}"
