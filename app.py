import subprocess
import json

user_input = input("Give a command: ")

def init():
    __origin = input("Origin: ")
    __destination = input("Destination: ")

    # Run the command and get the output into the resp variable
    # Decode the output as it's in bytes
    resp = subprocess.check_output(["fsync", f"init -o {__origin} -d {__destination}"]).decode()
    # print(type(resp))
    # Print the response (Should be a dictionary)
    print(f'resp: {resp}')
    # Load the dict from the string and print the message
    print(json.loads(resp).get("message"))

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