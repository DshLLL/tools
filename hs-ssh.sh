#!/bin/bash

function Help {
    echo "Usage:"
    echo "--add <key_name>"
    echo "    Create a new rsa key <key_name> in ~/.ssh"
    echo "--submit <key_name>"
    echo "    Submit the created key ~/.ssh/key_name to your github account"
    echo "--verify"
    echo "    Verify ssh connection to github"
    echo "--remove <key_name>"
    echo "    Remove the created key in ~/.ssh/key_name"
}

function Add {
    MPATH=~/.ssh/${1}
    echo $1
    if [ -a $MPATH ]; then
        echo "Key ${MPATH} has already been created."
    else
        ssh-keygen -t rsa -b 4096 -C "$1" -f ~/.ssh/$1
        #eval `ssh-agent -s`
        pushd ~/.ssh > /dev/null
        ssh-add $1
        popd > /dev/null
        #ssh-add -l
        echo "All files in ~/.ssh:"
        ls ~/.ssh
    fi
}

function Submit {
    MPATH=~/.ssh/$1
    if [ -a $MPATH ]; then
        echo "Username:"
        read VUSERNAME
        echo "Password:"
        read -s VPASSWORD
        local VTITLE="$1 $(hostname)"
        PUBPATH=~/".ssh/${1}.pub"
        local VKEY=$(<${PUBPATH})
        curl -u "${VUSERNAME}:${VPASSWORD}" --data '{"title":"'"${VTITLE}"'","key":"'"${VKEY}"'"}' https://api.github.com/user/keys
    else
        echo "Key $1 does not exist."
    fi
}

function Verify {
    if [ -z "$1" ]; then 
        ssh -T git@github.com
    else
        ssh -T $1
    fi
}

function Remove {
    MPATH=~/.ssh/${1}
    if [ -a $MPATH ]; then
        pushd ~/.ssh > /dev/null
        ssh-add -d $1
        popd > /dev/null
        PUBPATH=~/".ssh/${1}.pub"
        rm $MPATH
        rm $PUBPATH
        ls ~/.ssh
    else
        echo "Key (${MPATH}) does not exist."
    fi
}

case $1 in
    --help)
    Help
    ;;

    --add)
    Add "$2"
    ;;

    --submit)
    Submit "$2"
    ;;

    --verify)
    Verify "$2"
    ;;

    --remove)
    Remove "$2"
    ;;

    *)
    echo "Use --help for more information."
    ;;
esac

