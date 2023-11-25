eel.expose(response)
function response(resp) {
    if (["success", "error"].includes(resp.type)) {
        createNotification(resp)
    } else {
        console.log(resp)
    }
}

function createNotification(content) {
    let __notification = document.createElement('div')
    __notification.classList.add(content.type)
    __notification.classList.add('notification-content')

    let __close_button = document.createElement('button')
    __close_button.textContent = 'X'
    __close_button.onclick = function(){this.parentNode.remove()}

    let __message = document.createElement('p')
    __message.classList.add('message')
    __message.textContent = content.message

    __notification.appendChild(__close_button)
    __notification.appendChild(__message)

    document.querySelector('.notifications').appendChild(__notification)
}