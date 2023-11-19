function save(){

    if [ $# -eq 0 ] || [ $1 = "help" ]; then
        save_help;
    fi

    if [ ! -f $SYNCHRO_FILE ]; then 
        echo "Error: synchro file can't be found. Please initialize your directories before pushing."
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
                echo "Error: Unknown option $1"
                exit 0;
            ;;
        esac
    done

    # Test if origin directory is set
    if [ -z $__origin ]; then 
        echo "Error: must specify an origin directory"
        exit 0;
    fi

    # Test if origin is in the synchro file
    if [[ $(echo $__origin | sed 's/^\.\///; s/\/$//') != $(awk '{print $1}' $SYNCHRO_FILE) ]] && [[ $(echo $__origin | sed 's/^\.\///; s/\/$//') != $(awk '{print $2}' $SYNCHRO_FILE) ]]; then
        echo "Error: $__origin is not in the synchro file"
        exit 0;
    fi

    # Test if backup directory exists
    if [ ! -d $BACKUP_DIRECTORY ]; then
        echo "Directory $BACKUP_DIRECTORY does not exist. Creating one."
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

        echo "The version of this backup will be $__version"
    else
        if [ -d $BACKUP_DIRECTORY/$__version ]; then
            echo "Error: the version $__version already exists"
            exit 0;
        fi
    fi

    # Create the backup
    # - Create the new directory named with the version
    # - Copy everything from the origin directory to the new directory
    mkdir $BACKUP_DIRECTORY/$__version
    copy $__origin $BACKUP_DIRECTORY/$__version

    echo "The backup has been successfully created !"
    exit 0;
}

function save_help(){
    
    echo
    echo " save -o [directory] [-v [version]]"
    echo 
    echo " Create a backup of a chosen directory. The directory have to be already initialized (present into the"
    echo " synchronisation file) or the save won't be made. The version is optional. If the user doesn't specify"
    echo " it, the version will be like the most recent one but the last digit will be incremented (for example:"
    echo " if the most recent backup is 1.3.2, the new version will be 1.3.3)."
    echo
    echo " available options :"
    echo " -o | --origin                 select the directory the user want to make a backup of"
    echo " -v | --version                set the version of the backup"
    echo

    exit 0;
}