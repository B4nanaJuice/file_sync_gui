function load(){

    # Test if the synchro file exists
    # If not, ask for the user to init two directories, only way to create a synchro file
    if [ ! -f $SYNCHRO_FILE ]; then 
        echo "{\"type\": \"error\", \"message\": \"Synchro file can't be found. Please make sure you initialize your two directories before loading a backup\"}"
        exit 0;
    fi

    # Test if the backup directory exists
    # If not, ask for the user to make a first backup so that the directory can be crated
    if [ ! -d $BACKUP_DIRECTORY ]; then 
        echo "Error: backup directory can't be found. Please save a backup before loading one."
        exit 0;
    fi

    local error_message='';

    while [ $# -gt 0 ]; do
        error_message="Error: a value is needed for '$1'"
        case $1 in
            -v | --version )
                __version=${2:?$error_message}
                shift 2;
            ;;

            -d | --destination )
                __destination=${2:?$error_message}
                shift 2;
            ;;

            *)
                echo "{\"type\": \"error\", \"message\": \"Unknown option $1\"}"
                exit 0;
            ;;
        esac
    done

    # Test if the user used -v option
    if [ -z $__version ]; then
        echo "{\"type\": \"error\", \"message\": \"You must specify a version\"}"
        exit 0;
    fi

    # Test if the user used -d option
    if [ -z $__destination ]; then
        echo "{\"type\": \"error\", \"message\": \"You must specify a destination directory\"}"
        exit 0;
    fi

    # Test if destination is in the synchro file
    if [[ $(echo $__destination | sed 's/^\.\///; s/\/$//') != $(awk '{print $1}' $SYNCHRO_FILE) ]] && [[ $(echo $__destination | sed 's/^\.\///; s/\/$//') != $(awk '{print $2}' $SYNCHRO_FILE) ]]; then
        echo "{\"type\": \"error\", \"message\": \"$__destination is not in the synchro file\"}"
        exit 0;
    fi

    # Test if the version is an existing version
    if [ ! -d $BACKUP_DIRECTORY/$__version ]; then
        echo "{\"type\": \"error\", \"message\": \"$__version is an unknown version\"}"
        exit 0;
    fi

    # COpy the version evenif there are modification (re"movged the dialogue with the user)
    copy $BACKUP_DIRECTORY/$__version $__destination
    echo "{\"type\": \"success\", \"message\": \"Successfully loaded the version $__version !\"}"

    exit 0;   

}