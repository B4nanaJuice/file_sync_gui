function init(){
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
                echo "{\"type\": \"error\", \"message\": \"Unknown option $1\"}"
                exit 0;
            ;;
        esac
    done

    # Test if both values are set
    if [ -z $__origin ]; then
        echo "{\"type\": \"error\", \"message\": \"You must specify an origin directory\"}"
        exit 0;
    fi

    if [ -z $__destination ]; then
        # Make the output readable by python programm
        echo "{\"type\": \"error\", \"message\": \"You must specify a destination directory\"}"
        exit 0;
    fi

    # Test if both values are directories
    for d in $__origin $__destination; do
        if [ ! -d $d ]; then
            echo "{\"type\": \"error\", \"message\": \"$d is not a directory\"}"
            exit 0;
        fi
    done

    # Test if the user set the same directories (the sed removes the ./ in front of and the / at the end)
    if [ $(echo $__origin | sed 's/^\.\///; s/\/$//') = $(echo $__destination | sed 's/^\.\///; s/\/$//') ]; then
        echo "{\"type\": \"error\", \"message\": \"You must specify two different directories\"}"
        exit 0;
    fi

    # Test if the synchro file is created, if not, it creates the file
    if [ ! -f $SYNCHRO_FILE ]; then
        # echo "File $SYNCHRO_FILE does not exist. Creating one."
        touch $SYNCHRO_FILE
    fi

    # Store data into the synchro file
    echo "$(echo $__origin | sed 's/^\.\///; s/\/$//') $(echo $__destination | sed 's/^\.\///; s/\/$//') $(date | sed 's/ /-/g')" > $SYNCHRO_FILE

    # Copy the directory
    cp -rp $__origin/* $__destination
    cp -rp $__destination/* $__origin
    echo "{\"type\": \"success\", \"message\": \"The two directories have been linked and synced !\"}"

    exit 0;
}