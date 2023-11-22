import eel
import json
import subprocess

# Set web files folder
eel.init('web')

@eel.expose                         # Expose this function to Javascript
def say_hello_py(x):
    print('Hello from %s' % x)

@eel.expose
def test(text):
    print("creted element")

say_hello_py('Python World!')
eel.say_hello_js('Python World!')   # Call a Javascript function

test("coucou")
eel.test("Hey toi")

@eel.expose
def request(): # Send the response to the javascript side
    resp = subprocess.Popen(f"$HOME/file_sync_gui/fsync init -o A -d B", stdout=subprocess.PIPE,shell=True, text=True).stdout.read()
    eel.response(json.loads(resp))
    print(resp)

eel.start('hello.html', size=(300, 200), mode = "firefox")  # Start