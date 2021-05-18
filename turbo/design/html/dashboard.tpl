{$meta_title=$btr->dashboard_global scope=global}

<div class="row">
    <div class="col-lg-6 col-md-6">
        <div class="heading_page">{$btr->dashboard_global|escape}</div>
    </div>
</div>

<div class="row">
    <div class="col-lg-3 col-md-6 pr-0">
        <div class="boxed boxed_green boxed_dashboard fn_toggle_wrap">
            <div class="row">
                <div class="col-lg-12 toggle_body_wrap on fn_card ">
                    <div class="row">
                        <div class="col-xs-3">
                            <i class="fa fa-comments fa-5x"></i>
                        </div>
                        <div class="col-xs-9 text-right">
                            <div class="huge">{$new_comments_counter}</div>
                            <div>{$btr->general_comments|escape}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <a href="index.php?module=CommentsAdmin">
            <div class="panel-footer">
                <span class="pull-left">{$btr->view_details|escape}</span>
                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                <div class="clearfix"></div>
            </div>
        </a>
    </div>
    <div class="col-lg-3 col-md-6 pr-0">
        <div class="boxed boxed_yellow boxed_dashboard fn_toggle_wrap">
            <div class="row">
                <div class="col-lg-12 toggle_body_wrap on fn_card ">
                    <div class="row">
                        <div class="col-xs-3">
                            <i class="fa fa-envelope-o fa-5x"></i>
                        </div>
                        <div class="col-xs-9 text-right">
                            <div class="huge">{$new_feedbacks_counter}</div>
                            <div>{$btr->general_feedback|escape}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <a href="index.php?module=FeedbacksAdmin">
            <div class="panel-footer">
                <span class="pull-left">{$btr->view_details|escape}</span>
                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                <div class="clearfix"></div>
            </div>
        </a>
    </div>
    <div class="col-lg-3 col-md-6 pr-0">
        <div class="boxed boxed_subscribes boxed_dashboard fn_toggle_wrap">
            <div class="row">
                <div class="col-lg-12 toggle_body_wrap on fn_card ">
                    <div class="row">
                        <div class="col-xs-3">
                            <i class="fa fa-paper-plane-o fa-5x"></i>
                        </div>
                        <div class="col-xs-9 text-right">
                            <div class="huge">{$new_subscribes_counter}</div>
                            <div>{$btr->general_subscribes|escape}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <a href="index.php?module=SubscribesAdmin">
            <div class="panel-footer">
                <span class="pull-left">{$btr->view_details|escape}</span>
                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                <div class="clearfix"></div>
            </div>
        </a>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="boxed boxed_info boxed_dashboard fn_toggle_wrap">
            <div class="row">
                <div class="col-lg-12 toggle_body_wrap on fn_card ">
                    <div class="row">
                        <div class="col-xs-3">
                            <i class="fa fa-phone fa-5x"></i>
                        </div>
                        <div class="col-xs-9 text-right">
                            <div class="huge">{$new_callbacks_counter}</div>
                            <div>{$btr->general_callback|escape}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <a href="index.php?module=CallbacksAdmin">
            <div class="panel-footer">
                <span class="pull-left">{$btr->view_details|escape}</span>
                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                <div class="clearfix"></div>
            </div>
        </a>
    </div>
</div>

{if $orders_count}
<div class="row">
    <div class="col-xl-6 col-lg-12 col-md-12 pr-0">
        <div class="boxed fn_toggle_wrap">
            <div class="heading_box">
                {$btr->stats_orders|escape}
                <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                    <a class="btn-minimize" href="javascript:;"><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                </div>
            </div>
            <div class="toggle_body_wrap fn_card on">
                <div style="width:100%; height:400px; margin-top: 52px;" id='container'></div>
            </div>
        </div>
    </div>
    <div class="col-xl-6 col-lg-12 col-md-12">
        <div class="boxed fn_toggle_wrap">
            <div class="heading_box">
                {$btr->sales_statistics|escape}
                <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                    <a class="btn-minimize" href="javascript:;"><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                </div>
            </div>
            <div class="toggle_body_wrap fn_card on">
                <div style="width:100%; height:400px; margin-top: 52px;" id='containerSales'></div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-xl-6 col-lg-12 col-md-12 pr-0">
        <div class="boxed fn_toggle_wrap">
            <div class="heading_box">
                {$btr->statistics_number_of_orders|escape}
                <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                    <a class="btn-minimize" href="javascript:;"><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                </div>
            </div>
            <div class="toggle_body_wrap fn_card on">
                <div id="containerOrders" class="chart"></div>
            </div>
        </div>
    </div>
    <div class="col-xl-6 col-lg-12 col-md-12">
        <div class="boxed fn_toggle_wrap">
            <div class="heading_box">
                {$btr->statistics_amount_of_orders|escape}
                <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                    <a class="btn-minimize" href="javascript:;"><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                </div>
            </div>
            <div class="toggle_body_wrap fn_card on">
                <div id="containerAmount" class="chart"></div>
            </div>
        </div>
    </div>
</div>
{/if}

{* On document load *}
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
                    type: "line"
                },
                title: {
                    text: ''
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
            $.get('ajax/stat/stat.php', function(data) {
                var series = {
                    data: []
                };
                var minDate = Date.UTC(data[0].year, data[0].month - 1, data[0].day),
                    maxDate = Date.UTC(data[data.length - 1].year, data[data.length - 1].month - 1, data[data.length - 1].day);
                var newDates = [],
                    currentDate = minDate,
                    d;
                while (currentDate <= maxDate) {
                    d = new Date(currentDate);
                    newDates.push((d.getMonth() + 1) + '/' + d.getDate() + '/' + d.getFullYear());
                    currentDate += (24 * 60 * 60 * 1000); // add one day
                }
                series.name = '{/literal}{$btr->stats_orders_amount|escape}{literal}' + '{/literal}{$currency->sign}{literal}';
                // Iterate over the lines and add categories or series
                $.each(data, function(lineNo, line) {
                    series.data.push([Date.UTC(line.year, line.month - 1, line.day), parseInt(line.y)]);
                });
                //
                options.series.push(series);
                // Create the chart
                var chart = new Highcharts.Chart(options);
            });
        });
        Highcharts.theme = {
            colors: ['#02bcf2', '#f7a35c', '#90ee7e', '#7798BF', '#aaeeee', '#ff0066',
                '#eeaaee', '#55BF3B', '#DF5353', '#7798BF', '#aaeeee'
            ],
            chart: {
                backgroundColor: null,
                style: {
                    fontFamily: 'Open Sans, sans-serif'
                }
            },
            title: {
                style: {
                    fontSize: '18px',
                    fontWeight: 'bold',
                    textTransform: 'none'
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
    <script>
        var chart;
        $(function() {
            var options = {
                chart: {
                    renderTo: 'containerSales',
                    defaultSeriesType: 'column'
                },
                title: {
                    text: ''
                },
                subtitle: {
                    text: ''
                },
                xAxis: {
                    type: 'datetime'
                },
                yAxis: {
                    title: {
                        text: '{/literal}{$currency->name}{literal}'
                    }
                },
                plotOptions: {
                    column: {
                        borderWidth: 0,
                        enableMouseTracking: true
                    }
                },
                series: []
            };
            $.get('ajax/stat/stat_sales.php', function(data) {
                var series = { data: [] };
                var series0 = { data: [] };
                var series1 = { data: [] };
                series.name = '{/literal}{$btr->sum_of_all_orders|escape}, {$currency->sign}{literal}';
                series0.name = '{/literal}{$btr->amount_unpaid|escape}, {$currency->sign}{literal}';
                series1.name = '{/literal}{$btr->amount_paid|escape}, {$currency->sign}{literal}';
                d = new Date();
                for (i = 0; i < 31; i++) {
                    series.data.push([Date.UTC(1900 + d.getYear(), d.getMonth(), d.getDate()), 0]);
                    series0.data.push([Date.UTC(1900 + d.getYear(), d.getMonth(), d.getDate()), 0]);
                    series1.data.push([Date.UTC(1900 + d.getYear(), d.getMonth(), d.getDate()), 0]);
                }
                // Iterate over the lines and add categories or series
                $.each(data, function(lineNo, line) {
                    series.data.push([Date.UTC(line.year, line.month - 1, line.day), parseInt(line.x)]);
                    series0.data.push([Date.UTC(line.year, line.month - 1, line.day), parseInt(line.y)]);
                    series1.data.push([Date.UTC(line.year, line.month - 1, line.day), parseInt(line.z)]);
                });
                options.series.push(series);
                options.series.push(series0);
                options.series.push(series1);
                console.log(options.series);
                // Create the chart
                var chart = new Highcharts.Chart(options);
            });
        });
        // Apply the theme
        var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
    </script>
{/literal}
{* On document load *}
{literal}
    <script src="design/js/loader.js" type="text/javascript"></script>
    <script type="text/javascript">
        google.load("visualization", "1", {packages:["corechart"]});
        google.setOnLoadCallback(drawChartOrders);

        function drawChartOrders() {
            var serie = [];
            serie.push([{/literal}'{$btr->general_date|escape}', '{$btr->general_new_order|escape}', '{$btr->general_accepted_order|escape}', '{$btr->general_closed_order|escape}', '{$btr->general_canceled_order|escape}'{literal}]); 
        {/literal}
        {foreach $stat_orders as $s}
            serie.push(['{$s.title}', {$s.new}, {$s.confirm}, {$s.complite}, {$s.delete}]); 
        {/foreach}
        {literal}
            var options = {
                legend: { position: "bottom" },
                colors: ['#357EC7', '#FFF380', '#6CBB3C', '#B6B6B4'],
                bar: {groupWidth: '90%'},
                hAxis: {slantedText:true, slantedTextAngle:90, textStyle: {fontSize: 11}}, 
                vAxis: {minValue: 0, textStyle: {fontSize: 11}},
                backgroundColor: '#fff',
                isStacked: true,
                titleTextStyle: {fontSize: 18, bold: true}
            };
            var chart = new google.visualization.ColumnChart(document.getElementById('containerOrders'));
            chart.draw(google.visualization.arrayToDataTable(serie), options);
        }
        google.load("visualization", "1", {packages:["corechart"]});
        google.setOnLoadCallback(drawChart);

        function drawChart() {
            var serie = [];
            serie.push([{/literal}'{$btr->general_date|escape}', '{$btr->general_new_order|escape}, {$currency->sign|escape}', '{$btr->general_accepted_order|escape}, {$currency->sign|escape}', '{$btr->general_closed_order|escape}, {$currency->sign|escape}', '{$btr->general_canceled_order|escape}, {$currency->sign|escape}'{literal}]); 
        {/literal}
        {foreach $stat as $s}
            serie.push(['{$s.title}', {$s.new}, {$s.confirm}, {$s.complite}, {$s.delete}]);
        {/foreach}
        {literal} 
            var options = {
                legend: { position: "bottom" },
                colors: ['#357EC7', '#FFF380', '#6CBB3C', '#B6B6B4'],
                bar: {groupWidth: '90%'},
                hAxis: {slantedText:true, slantedTextAngle:90, textStyle: {fontSize: 11}}, 
                vAxis: {minValue: 0, textStyle: {fontSize: 11}},
                backgroundColor: '#fff',
                isStacked: true,
                titleTextStyle: {fontSize: '18', bold: true}
            };
            var chart = new google.visualization.ColumnChart(document.getElementById('containerAmount'));
            chart.draw(google.visualization.arrayToDataTable(serie), options);
        }
        $(window).resize(function() {
            drawChartOrders();
            drawChart();
        });
    </script>
{/literal}