{$meta_title=$btr->stats_stats scope=global}

<div class="row">
    <div class="col-lg-6 col-md-6">
        <div class="heading_page">{$btr->stats_stats|escape}</div>
	</div>
</div>
<div class="row">
    <div class="col-lg-12 col-md-12">
        <div class="boxed fn_toggle_wrap">
            <div id='container'></div>
		</div>
	</div>
</div>
{* On document load *}
<script>
    var stats_orders = '{$btr->stats_orders|escape}';
    var stats_message = '{$btr->stats_message|escape}';
    var stats_orders_amount =  '{$btr->stats_orders_amount|escape}';
</script>
{literal}
<script src="design/js/highcharts/highcharts.js" type="text/javascript"></script>
<script>
    var chart;
    $(function() {
        var options = {
            exporting: {
                chartOptions: { // specific options for the exported image
                    plotOptions: {
                        series: {
                            dataLabels: {
                                enabled: true
							}
						}
					}
				},
                fallbackToExportServer: false
			},
            chart: {
                zoomType: 'x',
                renderTo: 'container',
                defaultSeriesType: 'area',
                type : "line"
			},
            title: {
                text: stats_orders
			},
            xAxis: {
                type: 'datetime',
                minRange: 7 * 24 * 3600000,
                maxZoom: 7 * 24 * 3600000,
                gridLineWidth: 1,
                ordinal: true,
                showEmpty: false
			},
            yAxis: {
                title: {
                    text: '{/literal}{$currency->name}{literal}'
				}
			},
            plotOptions: {
                line: {
                    dataLabels: {
                        enabled: true
					},
                    enableMouseTracking: true,
                    connectNulls: false
				},
                area: {
                    marker: {
                        enabled: false
					},
				}
			},
            series: []
		};
        $.get('ajax/stat/stat.php', function(data){
            var series = {
                data: []
			};
            var minDate = Date.UTC(data[0].year, data[0].month-1, data[0].day),
			maxDate = Date.UTC(data[data.length-1].year, data[data.length-1].month-1, data[data.length-1].day);
            var newDates = [], currentDate = minDate, d;
            while (currentDate <= maxDate) {
                d = new Date(currentDate);
                newDates.push((d.getMonth() + 1) + '/' + d.getDate() + '/' + d.getFullYear());
                currentDate += (24 * 60 * 60 * 1000); // add one day
			}
            series.name = stats_orders_amount + '{/literal}{$currency->sign}{literal}';
            // Iterate over the lines and add categories or series
            $.each(data, function(lineNo, line) {
                series.data.push([Date.UTC(line.year, line.month-1, line.day), parseInt(line.y)]);
			});
            //
            options.series.push(series);
            // Create the chart
            var chart = new Highcharts.Chart(options);
		});
	});
    Highcharts.theme = {
		colors: ['#02bcf2', '#f7a35c', '#90ee7e', '#7798BF', '#aaeeee', '#ff0066',
		'#eeaaee', '#55BF3B', '#DF5353', '#7798BF', '#aaeeee'],
		chart: {
			backgroundColor: null,
			style: {
				fontFamily: 'Open Sans, sans-serif' 
			}
		},
		title: {
			style: {
				fontSize: '16px',
				fontWeight: 'bold',
				textTransform: 'uppercase'
			}
		},
		tooltip: {
			shadow: false
		},
		legend: {
			itemStyle: {
				fontWeight: 'bold',
				fontSize: '13px'
			}
		},
		xAxis: {
			gridLineWidth: 1,
			labels: {
				style: {
					fontSize: '12px'
				}
			}
		},
		plotOptions: {
			candlestick: {
				lineColor: '#404048'
			}
		},
		// General
		background2: '#F0F0EA'
	};
    // Apply the theme
    var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
</script>
{/literal}