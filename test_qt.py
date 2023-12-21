import eel
import json
import subprocess as sp
import threading
import time

# Set web files folder
eel.init('web')

@eel.expose # Have to use this function ONLY when loading/reloading the page
def refresh_backup_size():
    resp = sp.Popen("bash $HOME/file_sync_gui/utils/backup_size_stats.sh", 
                    stdout = sp.PIPE, shell = True, text = True).stdout.read()
    eel.backupSizeStats(json.loads(resp))

@eel.expose
def sync_stats():
    resp = sp.Popen("bash $HOME/file_sync_gui/utils/get_sync_stats.sh",
                    stdout = sp.PIPE, shell = True, text = True).stdout.read()
    eel.syncStats(json.loads(resp))

@eel.expose
def getDate():
    resp = sp.Popen(f"date", stdout=sp.PIPE,shell=True, text=True).stdout.read()
    eel.refresh_date(resp)

@eel.expose
def initialize(__origin: str, __destination: str):
    resp = sp.Popen(f"$HOME/file_sync_gui/fsync init -o {__origin} -d {__destination}", 
                    stdout=sp.PIPE,shell=True, text=True).stdout.read()
    print(resp)
    eel.response(json.loads(resp))
    refresh_date()

@eel.expose
def push(__force_origin: str):
    resp = sp.Popen(f"$HOME/file_sync_gui/fsync push {f'-f {__force_origin}' if __force_origin != '' else ''}", 
                    stdout = sp.PIPE, shell = True, text = True).stdout.read()
    resp = json.loads(resp)
    if resp["type"] == "success":
        sp.Popen("bash $HOME/file_sync_gui/utils/sync_stats.sh", shell = True)
        eel.refresh_page()
    else:
        eel.response(resp)

@eel.expose
def save(__origin: str, __version: str):
    # Check if the user put an origin directory
    if __origin == "":
        eel.response({"type": "error", "message": "You must provide an origin directory."})
    else :
        resp = sp.Popen(f"$HOME/file_sync_gui/fsync save -o {__origin} {f'-v {__version}' if __version != '' else ''}", 
                        stdout = sp.PIPE, shell = True, text = True).stdout.read()
        resp = json.loads(resp)
        if resp["type"] == "success":
            eel.refresh_page()
        else:
            eel.response(resp)

@eel.expose
def load(__version: str, __destination: str):
    if __version == "": 
        eel.response({"type": "error", "message": "You must provide a version to load."})
    elif __destination == "":
        eel.response({"type": "error", "message": "You must provide a destination directory."})
    else:
            resp = sp.Popen(f"$HOME/file_sync_gui/fsync load -v {__version} -d {__destination}", 
                            stdout = sp.PIPE, shell = True, text = True).stdout.read()
            print(resp)
            eel.response(json.loads(resp))

# Set the current date of the .synchro file on the dashboard
# Must be called when init and push
@eel.expose
def refresh_date():
    resp = sp.Popen("cat $HOME/file_sync_gui/.synchro | awk '{print $3}' | sed 's/-/ /g'", stdout = sp.PIPE, shell = True, text = True).stdout.read()
    eel.refresh_date(resp)


# Always active to check if there are modifications in one of the two directories
# The thread starts later
def synced_directories():
    while True:
        resp = sp.Popen("bash $HOME/file_sync_gui/utils/synced_directories.sh", stdout = sp.PIPE, shell = True, text = True).stdout.read()
        # print(resp)
        data = json.loads(resp)
        eel.syncedDirs(data)
        time.sleep(5)

threading.Thread(target = synced_directories).start() # Also start the thread for synced_directories
eel.start('index.html', size=(300, 200), mode = "firefox")  # Start

