eel.expose(backupSizeStats)
function backupSizeStats(data) {
    console.log(data)
    // data = {
    //     "1.1.1": {
    //         "count": 3,
    //         "size": 52
    //     },
    //     "1.1.2": {
    //         "count": 5,
    //         "size": 85
    //     },
    //     "1.1.3": {
    //         "count": 5,
    //         "size": 85
    //     }
    // }

    let versions = Object.keys(data);
    versions = versions.reverse()
    versions.length = Math.min(versions.length, 8)
    versions = versions.reverse()

    let countValues = [];
    let sizeValues = [];
    for (v in data) {
        countValues.push(data[v].count);
        sizeValues.push(data[v].size);
    }

    countValues = countValues.reverse()
    countValues.length = Math.min(versions.length, 8)
    countValues = countValues.reverse()

    sizeValues = sizeValues.reverse()
    sizeValues.length = Math.min(versions.length, 8)
    sizeValues = sizeValues.reverse()

    const barColors = ["#123456", "#234567","#345678","#456789","#56789a", "#6789ab", "#789abc", "#89abcd"];
    const barColors2 = ["#561234", "#672345","#783456","#894567","#9a5678", "#ab6789", "#bc789a", "#cd89ab"];

    new Chart("myChart", {
    type: "bar",
    data: {
        labels: versions,
        datasets: [{
            label: "File amount",
            backgroundColor: barColors,
            data: countValues,
            yAxisID: 'y'

        }, {
            label: "Backup size",
            backgroundColor: barColors2,
            data: sizeValues,
            yAxisID: 'y1'
        }]
    },
    options: {
        legend: {display: false},
        title: {
            display: true,
            text: "World Wine Production 2018"
        },
        scales: {
            y: {
                type: 'linear',
                display: true,
                position: 'left',
                // grid line settings
            },
            y1: {
                type: 'linear',
                display: true,
                position: 'right',
        
                // grid line settings
                grid: {
                    drawOnChartArea: false // only want the grid lines for one axis to show up
                }
            }
        }
    }
    });
}