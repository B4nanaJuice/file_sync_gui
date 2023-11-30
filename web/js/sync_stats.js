eel.expose(syncStats)
function syncStats() {
    const xValues = [50,60,70,80,90,100,110,120,130,140,150];
    const yValues = [7,8,8,9,9,9,10,11,14,14,15];

    new Chart("sync_stats_chart", {
    type: "line",
    data: {
        labels: xValues,
        datasets: [{
        fill: false,
        lineTension: 0,
        backgroundColor: "#123456",
        borderColor: "#456789",
        data: yValues
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