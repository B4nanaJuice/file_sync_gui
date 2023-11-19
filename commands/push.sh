function push(){

    # Test if the user asks for the help
    if [ $# -ne 0 ] && [ $1 = "help" ]; then
        push_help;
    fi

    # Test if the synchro file is created, if not, ask the user to init the two directories
    if [ ! -f $SYNCHRO_FILE ]; then 
        echo "Error: synchro file can't be found. Please initialize your directories before pushing."
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

    # If the origin dir has not been specified
    if [ -z $__origin ]; then 
        # Get the date from the synchro file
        __reference_date=$(date -d "$(awk '{print $3}' $SYNCHRO_FILE | sed 's/-/ /g')")

        # Test which one has recent modifications
        # If the first dir has recent modifications
        if [[ "$(date -r $__temp_a)" > "$__reference_date" ]]; then 

            # If the second dir has also recent modifications -> conflict
            if [[ "$(date -r $__temp_b)" > "$__reference_date" ]]; then 
                echo "Error: there is a conflict"
                conflict $__temp_a $__temp_b
                exit 0;
            else
                __origin=$__temp_a;
                __destination=$__temp_b;
            fi

        # If there is the second dir with recent modifications
        elif [[ "$(date -r $__temp_b)" > "$__reference_date" ]]; then 

            __origin=$__temp_b;
            __destination=$__temp_a;

        # If there is no recent modification in both of the directories
        else
            echo "The two directories are up to date. Nothing to change."
            exit 0;
        fi

    else
        if [ ! -d $__origin ]; then 
            echo "Error: $__origin is not a directory"
            exit 0;
        fi

        # Test if the argument is one of the two directories

        if [ $(echo $__origin | sed 's/^\.\///; s/\/$//') = $__temp_a ]; then
            __destination=$__temp_b
        elif [ $(echo $__origin | sed 's/^\.\///; s/\/$//') = $__temp_b ]; then
            __destination=$__temp_a
        else
            echo "Error: $__origin is not in the synchro configuration"
            exit 0;
        fi

    fi

    copy $__origin $__destination

    echo "$__origin $__destination $(date | sed 's/ /-/g')" > $SYNCHRO_FILE

    exit 0;
    
}

function push_help(){
    
    echo
    echo " push [-f [directory]]"
    echo 
    echo " Synchronize the content of two directories registered into a synchronization file. The copy will be"
    echo " made only if one of the two directories has recent modifications. If both of the two directories have"
    echo " recent modifications, there is a conflict and for each different file, the user will have to choose the"
    echo " file they want to keep."
    echo
    echo " available options :"
    echo " -f | --force-origin           force the sync by copying the content of the origin directory into the"
    echo "    |                          other one without knowing the existence of conflict"
    echo

    exit 0;
}
