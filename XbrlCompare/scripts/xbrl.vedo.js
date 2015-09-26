/*!
 * xbrl JavaScript Library v1.0.0
 *
 * Copyright 2015 Riccardo Vedovato
 * Released under the MIT license
 *
 * Date: 2015-09-19T16:20Z
 */


function splitCamel(name) {
    // The function returns the string with white spaces
    var splitted = name.replace(/([a-z])([A-Z])/g, '$1 $2');
    return splitted;
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

function getYears(finrep) {
    var items = finrep.xbrl.context;
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
    return anni;
}

