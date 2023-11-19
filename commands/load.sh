function load(){

    if [ $# -eq 0 ] || [ $1 = "help" ]; then
        load_help;
    fi

    # Test if the synchro file exists
    # If not, ask for the user to init two directories, only way to create a synchro file
    if [ ! -f $SYNCHRO_FILE ]; then 
        echo "Error: synchro file can't be found. Please initialize your directories before pushing."
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
                echo "Error: Unknown option $1"
                exit 0;
            ;;
        esac
    done

    # Test if the user used -v option
    if [ -z $__version ]; then
        echo "Error: must secify a version"
        exit 0;
    fi

    # Test if the user used -d option
    if [ -z $__destination ]; then
        echo "Error: must specify a destination directory"
        exit 0;
    fi

    # Test if destination is in the synchro file
    if [[ $(echo $__destination | sed 's/^\.\///; s/\/$//') != $(awk '{print $1}' $SYNCHRO_FILE) ]] && [[ $(echo $__destination | sed 's/^\.\///; s/\/$//') != $(awk '{print $2}' $SYNCHRO_FILE) ]]; then
        echo "Error: $__destination is not in the synchro file"
        exit 0;
    fi

    # Test if the version is an existing version
    if [ ! -d $BACKUP_DIRECTORY/$__version ]; then
        read -p "Error: no backup has the version $__version. Do you want to see available versions ? [y/n] " __see_versions;
        
        case $__see_versions in
            y | Y | yes | Yes | YES)
                echo $(ls $BACKUP_DIRECTORY)
            ;;
        esac

        exit 0;
    fi

    # Test if the user has recent modifications
    # if so, ask if the user really want to overwrite everything
    # If yes, do the copy, if no, cancel
    # If there is no modification, just copy the content of the 
    local __reference_date=$(date -d "$(awk '{print $3}' $SYNCHRO_FILE | sed 's/-/ /g')");
    if [[ "$(date -r $__destination)" > "$__reference_date" ]]; then

        read -p "You have unsaved modifications in $__destination. Do you want to load the backup anyway ? [y/n] " __load_anyway

        case $__load_anyway in
            y | Y | yes | Yes | YES)
                copy $BACKUP_DIRECTORY/$__version $__destination
                echo "Successfully loaded the version $__version !"
            ;;

            *)
                echo "Load canceled !"
            ;;
        esac

    else

        copy $BACKUP_DIRECTORY/$__version $__destination
        echo "Successfully loaded the version $__version !"

    fi

    exit 0;   

}

function load_help(){
    
    echo
    echo " load -v [version] -d [destination]"
    echo 
    echo " Load a backup with a specified version. The destination directory have to be already initialized"
    echo " (present into the synchronisation file) or the load won't be made. If recent modifications are made"
    echo " into the destincation directory, the programm will ask the user if they want to overwrite the directory"
    echo " anyway."
    echo
    echo " available options :"
    echo " -v | --version                select the version of the backup the user wants to load"
    echo " -d | --destination            set the destination directory of the loaded backup"
    echo

    exit 0;
}