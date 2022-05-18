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

check004() {
    local R1 R2
    R1=$(cd 004/dest; find . -name "[a-z]*" -type f | sort | xargs -n1 cat)
    R2=$(find 004 -maxdepth 1 -name "[a-z]*" -type f | sort | xargs -n1 cat)
    if [ ! "${R1}" = "${R2}" ]; then
        echo "ディレクトリ内のファイルが元と一致していません"
        return 1
    fi
    return 0

}

check005() {
    if [ ! -d 005/a/b/c/d/e ]; then
        echo "ディレクトリa/b/c/d/eがありません"
        return 1
    fi
    return 0
}

check006() {
    find 006 -type f -name "BUG" | tee /tmp/r.$$
    rmr() {
        rm -f /tmp/r.$$
    }
    trap rmr 0
    if [ $(wc -l < /tmp/r.$$) -gt 0 ]; then
        echo "BUGはまだ残っています!"
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

R=NG
check004 && R=OK
echo "問題4 ${R}"

R=NG
check005 && R=OK
echo "問題5 ${R}"

R=NG
check006  && R=OK
echo "問題6 ${R}"

check007() {
    test -f 007/hoge.d/fuga
    return $?
}

R=NG
check007  && R=OK
echo "問題7 ${R}"

check008() {
    if [ ! -f 008/yonde.txt ]; then
        echo "問題8: ファイルyonde.txtがありません"
        return 1
    fi

    IN1=$(ls -i 008/README.txt | awk '{print $1}')
    IN2=$(ls -i 008/yonde.txt | awk '{print $1}')

    if [ ${IN1} -eq ${IN2} ]; then
        return 0
    fi
    echo "問題8: yonde.txtがハードリンクではありません"
    return 1
}

R=NG
check008  && R=OK
echo "問題8 ${R}"

check009() {
    local R
    R=0
    if [ $(find 009 -type d | wc -l) -gt 2 ]; then
        echo "ディレクトリの整理がされていません(余計なディレクトリが残っています)"
        return 1
    fi
    for i in 13499 16114 16145 17191 18883 20289 21258 21839 23278 2634 30897 31302 4076 9913; do
        if [ ! -f 009/complicated/$i ]; then
            R=1
            echo "ファイル $i がありません"
            break
        fi
    done
    return $R
}

R=NG
check009 && R=OK
echo "問題9 ${R}"

check010() {
    local R item
    R=0
    for item in /etc/hosts /initrd.img /bin/cp; do
        b=$(basename $item)
        if [ ! -L $b ]; then
            echo "$b がありません、もしくはシンボリックリンクではありません"
            R=1
        else
            local r1 r2
            r1=$(basename $item | awk '{print $1}')
            r2=$(basename $b | awk '{print $1}')
            if [ ! "${r1}" = "${r2}" ]; then
                echo "ファイル $b が 元ファイル $item と一致していません"
                R=1
        fi
    done
    return $R
}
