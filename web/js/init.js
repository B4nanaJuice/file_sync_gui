function init() {
    let __origin = document.querySelector('.init_content').querySelectorAll('.directory')[0].value
    let __destination = document.querySelector('.init_content').querySelectorAll('.directory')[1].value
    eel.initialize(__origin, __destination)
}