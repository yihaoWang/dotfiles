#!/usr/bin/env bash

DIFF=`which diff`
CURL=`which curl`
ABSPATH=$(cd ${0%/*} && echo `pwd`/${0##*/})
CWD=`dirname "$ABSPATH"`

function backup {
	unset count
	while true; do
		if [ -z $count ]; then
			backupfile="$1.bak"
				count=0
		else
			backupfile="$1.bak.$count"
		fi
		if [ -r $backupfile ]; then
			echo "$backupfile exists"
		else
			echo "rename to $backupfile for backup."
			mv $1 $backupfile
			break
		fi
		count=$(expr $count + 1)
	done
}

function link {
	srcfile="$CWD/$1"
	destfile="$HOME/${1/_/.}"
	echo $destfile;
	if [ -e $destfile ]; then
		if [ -n "$($DIFF $srcfile $destfile)" ]; then
			backup $destfile
		fi
	fi

	ln -sfnv $srcfile $destfile
}

#setup zsh
$CURL -L https://raw.github.com/yihaoWang/oh-my-zsh/my_config/tools/install.sh | sh

for file in _*; do
	link $file
done
