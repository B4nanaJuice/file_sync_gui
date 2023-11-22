import eel

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

eel.start('hello.html', size=(300, 200), mode = "firefox")  # Start