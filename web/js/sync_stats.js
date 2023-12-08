eel.expose(syncStats)
function syncStats(data) {
    data = {
        "1": 4,
        "2": 5,
        "a": 10,
        "b": 2,
        "c": 12,
        "de": 5,
        "f": 14,
        "g": 9,
        "h": 1,
        "i": 8,
        "j": 20,
        "k": 13,
        "l": 6,
        "m": 4,
        "n": 13,
        "o": 12,
        "p": 19
    }

    let dates = Object.keys(data)
    dates = dates.reverse()
    dates.length = Math.min(dates.length, 15)
    dates = dates.reverse()

    v = []
    for (d of dates) {
        v.push(data[d])
    }

    new Chart("sync_stats_chart", {
    type: "line",
    data: {
        labels: dates,
        datasets: [{
            label: "Number of changes",
            fill: false,
            lineTension: 0,
            backgroundColor: "#123456",
            borderColor: "#456789",
            data: v,
            tension: 0.4,
            cubicInterpolationMode: 'monotone'
        }]
    },
    options: {
        legend: {display: false},
        scales: {
            yAxes: [{ticks: {min: 6, max:16}}],
            y: {
                grid: {
                    drawOnChartArea: false
                }
            }
            
        }
    }
    });
}