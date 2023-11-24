function copy(){
    # If the directory is empty, it's useless to remove the files inside
    if [[ $(ls -1q $2 | wc -l) -ne 0 ]]; then
        rm -r $2/*
    fi

    # Copy the content of the first directory to the second
    cp -rp $1/* $2
    echo "Content of $1 have been successfully copied to $2."
}

function conflict(){

    # Do the loop for files that exist in both of the directories
    for line in $(diff -rq $1 $2 | sed -e '/^Only/d' -e 's/Files .*\/\(.*\) and .* differ$/\1/g'); do
        # Ask the choice of the user
        read -p "Files $line differ, which one you want to keep ? [1 to keep from $1 and 2 to keep from $2]: " $__choice
        
        # Make sure the user inputs a correct value
        # If the value isn't valid, ask again to the user until he gives a valid input 
        while [ -z $__choice ] || ([ "$__choice" != "1" ] && [ "$__choice" != "2" ]); do
            read -p "Error: value must be 1 or 2: " __choice
        done

        # Do the copy depending on the user's input
        if [ $__choice -eq 1 ]; then
            cp $1/$line $(echo $2/$line | sed 's/\/.*$//')
        elif [ $__choice -eq 2 ]; then 
            cp $2/$line $(echo $1/$line | sed 's/\/.*$//')
        fi
    done

    # Do the loop for files that are present only in the first directory
    # For each file, ask the user if they want to copy the file from first directory to the second one
    # Or if they want to remove the file in the first directory
    for line in $(diff -rq $1 $2 | sed -e '/^Files/d' -e "/^Only in $2/d" -e "s/^Only in .*: \(.*\)/\1/"); do
        # Ask for the choice of the user
        read -p "File $line is only present in $1 ? [1 to copy from $1 and 2 to remove $1]: " __choice
        
        # Make sur the user inputs a valid choice (1 or 2)
        # If the value isn't valid, ask again until the user gives a valid input
        while [ -z $__choice ] || ([ "$__choice" != "1" ] && [ "$__choice" != "2" ]); do
            read -p "Error: value must be 1 or 2" __choice
        done

        # If the user wants to copy the file
        # Else, it removes the file from the first directory
        if [ $__choice -eq 1 ]; then
            cp $1/$line $(echo $2/$line | sed 's/\/.*$//')
        elif [ $__choice -eq 2 ]; then
            rm $1/$line
        fi
    done

    # Do the same loop as before but with files that exist only in the second directory
    for line in $(diff -rq $1 $2 | sed -e '/^Files/d' -e "/^Only in $1/d" -e "s/^Only in .*: \(.*\)/\1/"); do
        # Ask the user their choice (1 or 2)
        read -p "File $line is only present in $2 ? [1 to copy from $2 and 2 to remove $2]: " __choice
        
        # Sanitize the input
        while [ -z $__choice ] || ([ "$__choice" != "1" ] && [ "$__choice" != "2" ]); do
            read -p "Error: value must be 1 or 2" __choice
        done

        # Copy the file or remove it depending on the choice of the user
        if [ $__choice -eq 1 ]; then
            cp $2/$line $(echo $1/$line | sed 's/\/.*$//')
        elif [ $__choice -eq 2 ]; then
            rm $2/$line
        fi
    done
}