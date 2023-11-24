#! /bin/bash

source $HOME/file_sync_gui/utils/data.sh
source $HOME/file_sync_gui/utils/functions.sh

function main(){
    if [ $# -eq 0 ] || [ $1 = "help" ]; then
        main_help;
    fi

    case $1 in
        init | push | save | load)  # Test if it's one of the commands
            source "$HOME/file_sync_gui/commands/$1.sh" # Import the content of the file depending on the given sub command
            $1 "${@:2}"             # Call the function linked to the sub command with arguments
        ;;

        *)
            echo "Error: Invalid subcommand (expected init, push, save or load but got $1)"
            exit 0;
        ;;
    esac
}

function main_help(){
    
    echo
    echo "        :::::::::: ::::::::::: :::        ::::::::::          ::::::::  :::   ::: ::::    :::  :::::::: "
    echo "       :+:            :+:     :+:        :+:                :+:    :+: :+:   :+: :+:+:   :+: :+:    :+: "
    echo "      +:+            +:+     +:+        +:+                +:+         +:+ +:+  :+:+:+  +:+ +:+         "
    echo "     :#::+::#       +#+     +#+        +#++:++#           +#++:++#++   +#++:   +#+ +:+ +#+ +#+          "
    echo "    +#+            +#+     +#+        +#+                       +#+    +#+    +#+  +#+#+# +#+           "
    echo "   #+#            #+#     #+#        #+#                #+#    #+#    #+#    #+#   #+#+# #+#    #+#     "
    echo "  ###        ########### ########## ##########          ########     ###    ###    ####  ########       "
    echo 
    echo " File synchronizer"
    echo
    echo " list of commands :"
    echo " help                         show help menu and commands"
    echo " init                         initialize the sync and link two directories"
    echo " push                         sync the content of two directories"
    echo " save                         create a backup of a current directory"
    echo " load                         load a backup with a given version"
    echo
    echo " To view all available options for each command, use fsync [command] help"
    echo

    exit 0;

}

main "$@";