function init(){

    # Test if the user provides no argument or if they ask for the help
    if [ $# -eq 0 ] || [ $1 = "help" ]; then
        init_help;
    fi

    local error_message='';

    while [ $# -gt 0 ]; do
        error_message="Error: a value is needed for $1"
        case $1 in
            -o | --origin)
                __origin=${2:?$error_message}
                shift 2;
            ;;

            -d | --destination)
                __destination=${2:?$error_message}
                shift 2;
            ;;

            *)
                echo "Error: Unknown option $1"
                exit 0;
            ;;
        esac
    done

    # Test if both values are set
    if [ -z $__destination ]; then
        # Make the output readable by python programm
        echo "Error: must specify a destination directory"
        exit 0;
    fi

    if [ -z $__origin ]; then
        echo "Error: must specify an origin directory"
        exit 0;
    fi

    # Test if both values are directories
    for d in $__origin $__destination; do
        if [ ! -d $d ]; then
            echo "Error: $d is not a directory"
            exit 0;
        fi
    done

    # Test if the user set the same directories (the sed removes the ./ in front of and the / at the end)
    if [ $(echo $__origin | sed 's/^\.\///; s/\/$//') = $(echo $__destination | sed 's/^\.\///; s/\/$//') ]; then
        echo "Error: must specify two different directories"
        exit 0;
    fi

    # Test if the synchro file is created, if not, it creates the file
    if [ ! -f $SYNCHRO_FILE ]; then
        echo "File $SYNCHRO_FILE does not exist. Creating one."
        touch $SYNCHRO_FILE
    fi

    # Store data into the synchro file
    echo "$(echo $__origin | sed 's/^\.\///; s/\/$//') $(echo $__destination | sed 's/^\.\///; s/\/$//') $(date | sed 's/ /-/g')" > $SYNCHRO_FILE

    # Copy the directory
    cp -rp $__origin/* $__destination
    cp -rp $__destination/* $__origin
    echo "The two directories have been initilaized and synced."

    exit 0;
}

function init_help(){
    
    echo
    echo " init -o [directory] -d [directory]"
    echo 
    echo " Initialize the link between two directories and make a first synchronization by copying the content"
    echo " of the origin directory into the destination directory. If two files in the origin directory and the"
    echo " destination directory have the same name, the one in the origin will overwrite the other one."
    echo
    echo " available options :"
    echo " -o | --origin                 set the origin directory fo the first synchronization"
    echo " -d | --destination            set the destination directory for the first synchronization"
    echo

    exit 0;
}