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


function aggregateTitles(concepts) {
    // extract aggregated titels from array of xbrl concepts
    var data = [{}];

}

