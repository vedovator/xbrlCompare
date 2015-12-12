/*!
 * xbrl JavaScript Library v1.0.0
 *
 * Copyright 2015 Riccardo Vedovato
 * Released under the MIT license
 *
 * Date: 2015-09-30T16:20Z
 */


function splitCamel(name) {
    // The function returns the string with white spaces
    var splitted = name.replace(/([a-z])([A-Z])/g, '$1 $2');
    return splitted;
}

function extractInfo(bilancio, sections) {
    var arrayData = [];
    jQuery.each(bilancio, function (i, item) {

        var arrSections = sections.split(",");
        // show aggregated data for SP & CE
        if (sections === 'sp') {
            var aggregatedSections = ['itcc-ci:TotaleImmobilizzazioniMateriali', 'itcc-ci:TotaleImmobilizzazioniImmateriali', 'itcc-ci:TotaleImmobilizzazioniFinanziarie', 'itcc-ci:TotaleRimanenze', 'itcc-ci:TotaleCrediti', 'itcc-ci:TotaleDisponibilitaLiquide'];
            if ($.inArray(i, aggregatedSections) > -1) {
                var concept = splitCamel(i.replace("itcc-ci:", "").replace("itvedo-ci-ese:", "")) + ' {y}';
                var b = { 'indexLabel': concept, 'y': item["#text"] };
                arrayData.push(b);
            }
        };
        if (sections === 'ce') {
            var aggregatedSections = ['itcc-ci:TotaleValoreProduzione', 'itcc-ci:TotaleCostiProduzione', 'itcc-ci:TotalePartiteStraordinarie', 'itcc-ci:ImposteRedditoEsercizioTotaleImposteRedditoEsercizio'];
            if ($.inArray(i, aggregatedSections) > -1) {
                var concept = splitCamel(i.replace("itcc-ci:", "").replace("itvedo-ci-ese:", "")) + ' {y}';
                var b = { 'indexLabel': concept, 'y': item["#text"] };
                arrayData.push(b);
            }
        };
        // show detail sections

        for (j = 0; j < arrSections.length; j++) {
            if (arrSections[j] === i.replace("itcc-ci:", "").replace("itvedo-ci-ese:", "").substring(0, arrSections[j].length)) {
                var concept = splitCamel(i.replace("itcc-ci:", "").replace("itvedo-ci-ese:", "")) + ' {y}';
                if (concept.indexOf('Totale') < 0) {
                    var b = { 'indexLabel': concept, 'y': item["#text"] };
                    arrayData.push(b);
                    //console.log(b);
                };
            };
        }






    });
    return arrayData;
}



function extractHistInfo(finrep1, finrep2, sections) {
    var arrayData = [];
    var arrSections = sections.split(",");
    jQuery.each(finrep1, function (i, item) {
        // show aggregated data for SP & CE
        if (sections === 'sp') {
            var aggregatedSections = ['itcc-ci:TotaleImmobilizzazioniMateriali', 'itcc-ci:TotaleImmobilizzazioniImmateriali', 'itcc-ci:TotaleImmobilizzazioniFinanziarie', 'itcc-ci:TotaleRimanenze', 'itcc-ci:TotaleCrediti', 'itcc-ci:TotaleDisponibilitaLiquide'];

            if ($.inArray(i, aggregatedSections) > -1) {
                var concept = splitCamel(i.replace("itcc-ci:", "").replace("itvedo-ci-ese:", ""));
                var b = { type: 'line', showInLegend: true, legendText: concept, dataPoints: [] };
                b.dataPoints.push({ 'x': new Date(item["@contextRef"].substring(8, 12), 01), 'y': Number(item["#text"]) });
                if (typeof finrep2[i] !== 'undefined') {
                    b.dataPoints.push({ 'x': new Date(finrep2[i]["@contextRef"].substring(8, 12), 01), 'y': Number(finrep2[i]["#text"]) });
                };
                arrayData.push(b);
            }
        };
        if (sections === 'ce') {
            var aggregatedSections = ['itcc-ci:TotaleValoreProduzione', 'itcc-ci:TotaleCostiProduzione', 'itcc-ci:TotalePartiteStraordinarie', 'itcc-ci:ImposteRedditoEsercizioTotaleImposteRedditoEsercizio'];

            if ($.inArray(i, aggregatedSections) > -1) {
                var concept = splitCamel(i.replace("itcc-ci:", "").replace("itvedo-ci-ese:", ""));
                var b = { type: 'line', showInLegend: true, legendText: concept, dataPoints: [] };
                b.dataPoints.push({ 'x': new Date(item["@contextRef"].substring(8, 12), 01), 'y': Number(item["#text"]) });
                if (typeof finrep2[i] !== 'undefined') {
                    b.dataPoints.push({ 'x': new Date(finrep2[i]["@contextRef"].substring(8, 12), 01), 'y': Number(finrep2[i]["#text"]) });
                };
                arrayData.push(b);
            }
        };
        // show detail sections

        for (j = 0; j < arrSections.length; j++) {
            if (arrSections[j] === i.replace("itcc-ci:", "").replace("itvedo-ci-ese:", "").substring(0, arrSections[j].length)) {
                var concept = splitCamel(i.replace("itcc-ci:", "").replace("itvedo-ci-ese:", ""));
                if (concept.indexOf('Totale') < 0) {
                    var b = { type: 'line', showInLegend: true, legendText: concept, dataPoints: [] };
                    b.dataPoints.push({ 'x': new Date(item["@contextRef"].substring(8, 12), 01), 'y': Number(item["#text"]) });
                    if (typeof finrep2[i] !== 'undefined') {
                        b.dataPoints.push({ 'x': new Date(finrep2[i]["@contextRef"].substring(8, 12), 01), 'y': Number(finrep2[i]["#text"]) });
                    };
                    arrayData.push(b);
                };
            };
        }
    });
    return arrayData;
}

function aggregateTitles(finrep) {
    // extract aggregated titles as an array from xbrl financial report
    var titles = [];
    jQuery.each(finrep.xbrl, function (i, item) {
        if (i.substring(0, 8) === "itcc-ci:") {
            var b = splitCamel(i.replace("itcc-ci:", ""));
            titles.push(b);
        } else { console.log("***" + i) };
    });

    var fstLvlAgg = [];
    jQuery.each(titles, function (i, item) {
        var str = splitCamel(item);
        // if second level is needed just add this: + str.split(" ")[1]
        var res = str.split(" ")[0];
        fstLvlAgg.push(res);
    });
    fstLvlAgg = $.unique(fstLvlAgg);
    return fstLvlAgg;
}

function getYear(finrep) {
    // Get Max Year for current report
    var items = finrep.context;
    //console.log(items);
    var anni = [];
    jQuery.each(items, function (i, item) {
        if (typeof item.period.instant === "undefined") {
            item.year = item.period.endDate.substring(0, 4);
        } else {
            item.year = item.period.instant.substring(0, 4);
        }
        anni.push(item.year);
    });
    anni = $.unique(anni);
    var anno = Math.max.apply(Math, anni); // get max year
    return anno;
}

/* old stuff - handle section change event
$('#catSelect').change(function () {
    var chart1 = $("#chartContainer1").CanvasJSChart();
    var chart2 = $("#chartContainer2").CanvasJSChart();
    // bind chart data
    var chart1Data = [];
    var chart2Data = [];
    jQuery.each(bilancio1.xbrl, function (i, item) {

        var wordLength = $('#catSelect').val().length;
        if ($('#catSelect').val() === i.replace("itcc-ci:", "").substring(0, wordLength)) {
            var concept = splitCamel(i.replace("itcc-ci:", "").replace($('#catSelect').val(), ""));
            if (concept.indexOf('Totale') < 0) {
                var b = { 'indexLabel': concept, 'y': item["#text"] };
                chart1Data.push(b);
            } else { console.log(b); };
        };
    });
    jQuery.each(bilancio2.xbrl, function (i, item) {

        var wordLength = $('#catSelect').val().length;
        if ($('#catSelect').val() === i.replace("itcc-ci:", "").substring(0, wordLength)) {
            var concept = splitCamel(i.replace("itcc-ci:", "").replace($('#catSelect').val(), ""));
            if (concept.indexOf('Totale') < 0) {
                var b = { 'indexLabel': concept, 'y': item["#text"] };
                chart2Data.push(b);
            } else { console.log(b); };
        };
    });
    chart1.options.data[0].dataPoints = chart1Data;
    chart2.options.data[0].dataPoints = chart2Data;
    chart1.render();
    chart2.render();
});
// Get titles from financial reports and bind them to select
        var titles = aggregateTitles(bilancio1);
        $.each(titles, function (i, item) {
            $('#catSelect').append($('<option>', {
                value: item,
                text: item
            }));
        });
*/
/* handle chart type change event
  $('#typeSelect').change(function () {
      var chart1 = $("#chartContainer1").CanvasJSChart();
      var chart2 = $("#chartContainer2").CanvasJSChart();
      chart1.options.data[0].type = $('#typeSelect').val();
      chart2.options.data[0].type = $('#typeSelect').val();
      chart1.render();
      chart2.render();
  }); no more useful */

