eel.expose(refresh_date)
function refresh_date(d) {
    __date = d.split(" ")
    __day = __date[2]
    __month = __date[1]
    __time = __date[3]
    __year = __date[5]

    document.querySelector(".date").textContent = `${__day} ${__month} ${__year} ${__time}`
}