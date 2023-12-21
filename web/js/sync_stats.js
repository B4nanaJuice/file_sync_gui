eel.expose(syncStats)
function syncStats(data) {

    // data = {
    //     "231219": 3,
    //     "231220": 2,
    //     "231221": 7
    // }

    let dates = Object.keys(data)
    dates = dates.reverse()
    dates.length = Math.min(dates.length, 20)
    dates = dates.reverse()

    let counts = Object.values(data)
    counts = counts.reverse()
    counts.length = Math.min(counts.length, 20)
    counts = counts.reverse()

    new Chart("sync_stats_chart", {
    type: "line",
    data: {
        labels: dates,
        datasets: [{
            label: "Push amount",
            fill: false,
            lineTension: 0,
            backgroundColor: "#123456",
            borderColor: "#456789",
            data: counts
        }]
    },
    options: {
        legend: {display: false},
        scales: {
        yAxes: [{ticks: {min: 6, max:16}}],
        }
    }
    });
}