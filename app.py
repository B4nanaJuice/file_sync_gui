import subprocess
import json

user_input = input("Give a command: ")

def init():
    __origin = input("Origin: ")
    __destination = input("Destination: ")

    # Run the command and get the output into the resp variable
    # Decode the output as it's in bytes
    resp = subprocess.Popen(f"$HOME/file_sync_gui/fsync init -o {__origin} -d {__destination}", stdout=subprocess.PIPE,shell=True, text=True).stdout.read()
    # print(type(resp))
    # Print the response (Should be a dictionary)
    print(f'resp: {resp}')
    # Load the dict from the string and print the message

def push():
    __force_origin = input("Force origin: ")

    subprocess.run(["fsync", f"push {'' if __force_origin == '' else f'-f {__force_origin}'}"])

def save():
    __origin = input("Origin: ")
    __version = input("Version: ")

    subprocess.run(["fsync", f"save -o {__origin} {f'-v {__version}' if __version != '' else ''}"])

def load():
    __version = input("Version: ")
    __destination = input("Destination: ")

    subprocess.run(["fsync", f"load -v {__version} -d {__destination}"])

def test():
    resp = subprocess.Popen("for d in $(ls .backup/); do find .backup/$d/ -type f | xargs ls -l | awk '{count+=$5} END{print count}' | xargs echo $d | sed -e 's/ /,/g' -e 's/$/,/g'; done", stdout=subprocess.PIPE,shell=True, text=True).stdout.read()
    print(resp)

test()

while user_input != "quit" and user_input != "exit":

    {
        "init": init,
        "push": push,
        "save": save,
        "load": load
    }.get(user_input, lambda: "Invalid input.")()

    # subprocess.run(["./fsync.sh", f"{user_input}"])
    user_input = input("Give a command: ")

print("bye !")