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
    echo "conflict between $1 and $2"
}