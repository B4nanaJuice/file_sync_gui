function init() {
    let __origin = document.querySelector('.init_content').querySelectorAll('.directory')[0].value
    let __destination = document.querySelector('.init_content').querySelectorAll('.directory')[1].value
    eel.initialize(__origin, __destination)
}

function push() {
    let __force_origin = document.querySelector('.push_content').querySelector('.directory').value
    eel.push(__force_origin)
}

function save() {
    let __origin = document.querySelector('.save_content').querySelector('.directory').value
    let __version = document.querySelector('.save_content').querySelector('.version').value
    eel.save(__origin, __version)
}

function load() {
    let __version = document.querySelector('.load_content').querySelector('.version').value
    let __destination = document.querySelector('.load_content').querySelector('.directory').value
    eel.load(__version, __destination)
}