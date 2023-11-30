window.onload = (event) => {
    refresh_date("Thu Nov 30 14:41:34 CET 2023")
    syncedDirs({
        "path/to/first/dir": true,
        "second/dir": false
    })
    backupSizeStats()
    syncStats()
};