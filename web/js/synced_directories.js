eel.expose(syncedDirs)
function syncedDirs(data) {
    // data = {
    //     pathA: true,
    //     pathB: false
    // }

    document.querySelector('.directories').querySelector('.dirA').textContent = Object.keys(data)[0]
    document.querySelector('.directories').querySelector('.dirB').textContent = Object.keys(data)[1]

    document.querySelector('.status').querySelector('.dirA').querySelector('.fa-check').style.display = (Object.values(data)[0] ? "inline": "none")
    document.querySelector('.status').querySelector('.dirA').querySelector('.fa-xmark').style.display = (!Object.values(data)[0] ? "inline": "none")

    document.querySelector('.status').querySelector('.dirB').querySelector('.fa-check').style.display = (Object.values(data)[1] ? "inline": "none")
    document.querySelector('.status').querySelector('.dirB').querySelector('.fa-xmark').style.display = (!Object.values(data)[1] ? "inline": "none")

}