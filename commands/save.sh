function save(){

    if [ ! -f $SYNCHRO_FILE ]; then 
        echo "{\"type\": \"error\", \"message\": \"Synchro file can't be found. Please make sure to initialize your directories before saving a backup\"}"
        exit 0;
    fi

    local error_message='';

    while [ $# -gt 0 ]; do
        error_message="Error: a value is needed for '$1'"
        case $1 in
            -o | --origin)
                __origin=${2:?$error_message}
                shift 2;
            ;;

            -v | --version)
                __version=${2:?$error_message}
                shift 2;
            ;;

            *)
                echo "{\"type\": \"error\", \"message\": \"Unknown option $1\"}"
                exit 0;
            ;;
        esac
    done

    # Test if origin directory is set
    if [ -z $__origin ]; then 
        echo "{\"type\": \"error\", \"message\": \"You must specify an origin directory\"}"
        exit 0;
    fi

    # Test if origin is in the synchro file
    if [[ $(echo $__origin | sed 's/^\.\///; s/\/$//') != $(awk '{print $1}' $SYNCHRO_FILE) ]] && [[ $(echo $__origin | sed 's/^\.\///; s/\/$//') != $(awk '{print $2}' $SYNCHRO_FILE) ]]; then
        echo "{\"type\": \"error\", \"message\": \"$__origin is not in the synchro file\"}"
        exit 0;
    fi

    # Test if backup directory exists
    if [ ! -d $BACKUP_DIRECTORY ]; then
        # echo "Directory $BACKUP_DIRECTORY does not exist. Creating one."
        mkdir $BACKUP_DIRECTORY
    fi

    # Test the version
    # If the version is not set -> take the last directory and add 1 to the last digit
    # If the version is set and the backup already exist -> Cancel 
    # If the version is set and the dir doesn't exist, create and copy everything
    if [ -z $__version ]; then

        # Test if the backup directory is empty or not
        # If it's empty -> the first backup directory will be 0.0.1
        # If it's not -> get the newest backup and add 1 to the last digit of the version
        if [[ $(ls -1q $BACKUP_DIRECTORY | wc -l) -eq 0 ]]; then
            __version="0.0.1"
        else
            # Get the last directory (most recent)
            local __last_directory=$(ls -Art $BACKUP_DIRECTORY | tail -n 1)
            __version=$(echo $__last_directory | awk -F\. 'BEGIN{OFS="."} {$NF+=1; print}')
        fi

        # echo "The version of this backup will be $__version"
    else

        if [[ ! $__version =~ ^[0-9]\.[0-9]\.[0-9]$ ]]; then
            echo "{\"type\": \"error\", \"message\": \"The given version is invalid. Please make sure it follow the format x.x.x\"}"
            exit 0;
        fi

        if [ -d $BACKUP_DIRECTORY/$__version ]; then
            echo "{\"type\": \"error\", \"message\": \"The version $__version already exists\"}"
            exit 0;
        fi
    fi

    # Create the backup
    # - Create the new directory named with the version
    # - Copy everything from the origin directory to the new directory
    mkdir $BACKUP_DIRECTORY/$__version
    copy $__origin $BACKUP_DIRECTORY/$__version

    echo "{\"type\": \"success\", \"message\": \"The backup has been successfully created with the version $__version !\"}"
    exit 0;
}