#!/bin/bash

####################################################
#update the .config repo before doing anything else#
####################################################

pushd ~/.config > /dev/null

#Inform the user of any unstaged/published changes
err=0
git update-index -q --ignore-submodules --refresh
git rev-parse --verify HEAD >/dev/null || exit 1

if ! git diff-files --quiet --ignore-submodules
    then
        echo >&2 "You have unstaged changes in ~/.config"
        err=1
    fi

if ! git diff-index --cached --quiet --ignore-submodules HEAD --
    then
        if [ $err = 0 ]
        then
            echo >&2 "Your have uncommitted changes in ~/.config"
        else
            echo >&2 "Additionally, your index contains uncommitted changes"
        fi
        err=1
    fi

if [ $(git rev-list HEAD@{upstream}..HEAD | wc -l) != "0" ]
	then
        if [ $err = 0 ]
        then
            echo >&2 "Your have unpublished changes in ~/.config"
        else
            echo >&2 "Additionally, your index contains unpublished changes"
        fi
        err=1
    fi

if [ $err -ne 0 ]
	then
		echo 
	fi

ping -q -w1 -c1 google.com &>/dev/null && git pull || echo -e >&2 "No network, couldn't update .config from github\n"

popd > /dev/null