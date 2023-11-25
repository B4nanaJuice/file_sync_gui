import eel
import json
import subprocess as sp

# Set web files folder
eel.init('web')

@eel.expose
def getDate():
    resp = sp.Popen(f"date", stdout=sp.PIPE,shell=True, text=True).stdout.read()
    eel.refresh_date(resp)

@eel.expose
def initialize(__origin: str, __destination: str):
    resp = sp.Popen(f"$HOME/file_sync_gui/fsync init -o {__origin} -d {__destination}", stdout=sp.PIPE,shell=True, text=True).stdout.read()
    print(resp)
    eel.response(json.loads(resp))

eel.start('index.html', size=(300, 200), mode = "firefox")  # Start