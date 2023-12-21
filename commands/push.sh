function push(){

    # Test if the synchro file is created, if not, ask the user to init the two directories
    if [ ! -f $SYNCHRO_FILE ]; then 
        echo "{\"type\": \"error\", \"message\": \"Synchro file can't be found, please initialize your directories before syncing them\"}"
        exit 0;
    fi

    local error_message='';
    local __origin="";
    local __destination="";

    while [ $# -gt 0 ]; do
        error_message="Error: a value is needed for '$1'"
        case $1 in
            -f | --force-origin )
                __origin=${2:?$error_message}
                shift 2;
            ;;

            *)
                echo "Error: Unknown option $1"
                exit 0;
            ;;
        esac
    done

    # If the origin is not set, get the directory that is different from the synchro file
    # Get the date of the synchro file, get the last modification date in the directories
    # If both directories have recent modifications, there is conflict (will be treated later)
    # If both of the two directories have no recent modification, then norhting to do.
    # Else, one directory has recent modifications so, copy the content of the origin into the destination directory

    # Get the two directories from the synchro file
    local __temp_a=$(awk '{print $1}' $SYNCHRO_FILE);
    local __temp_b=$(awk '{print $2}' $SYNCHRO_FILE);
    local __reference_date="";
    local __time_a=$(date -d "$(find $__temp_a -type f -exec stat \{} --printf="%y\n" \; | sort -n -r | head -n 1)" +"%y%m%d%H%M%S");
    local __time_b=$(date -d "$(find $__temp_b -type f -exec stat \{} --printf="%y\n" \; | sort -n -r | head -n 1)" +"%y%m%d%H%M%S");

    # If the origin dir has not been specified
    if [ -z $__origin ]; then 
        # Get the date from the synchro file
        __reference_date=$(date -d "$(awk '{print $3}' $SYNCHRO_FILE | sed 's/-/ /g')" +"%y%m%d%H%M%S")

        # Test which one has recent modifications
        # If the first dir has recent modifications (don't check if there is a conflict)
        if [[ "$__time_a" > "$__reference_date" ]]; then 

            __origin=$__temp_a;
            __destination=$__temp_b;

        # If there is the second dir with recent modifications
        elif [[ "$__time_b" > "$__reference_date" ]]; then 

            __origin=$__temp_b;
            __destination=$__temp_a;

        # If there is no recent modification in both of the directories
        else
            echo "{\"type\": \"error\", \"message\": \"The directories are up to date, nothing to change\"}"
            exit 0;
        fi

    else
        if [ ! -d $__origin ]; then 
            echo "{\"type\": \"error\", \"message\": \"$__origin is not a directory\"}"
            exit 0;
        fi

        # Test if the argument is one of the two directories

        if [ $(echo $__origin | sed 's/^\.\///; s/\/$//') = $__temp_a ]; then
            __destination=$__temp_b
        elif [ $(echo $__origin | sed 's/^\.\///; s/\/$//') = $__temp_b ]; then
            __destination=$__temp_a
        else
            echo "{\"type\": \"error\", \"message\": \"$__origin is not in the synchro file configuration\"}"
            exit 0;
        fi

    fi

    copy $__origin $__destination

    echo "$__origin $__destination $(date | sed 's/ /-/g')" > $SYNCHRO_FILE

    echo "{\"type\": \"success\", \"message\": \"The two directories have been synced !\"}"

    exit 0;
    
}