<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Confronti._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>CONFRONTO BILANCI XBRL</h1>
        <p class="lead">Questa applicazione sperimentale consente di caricare due bilanci in formato XBRL di cui si vuole effettuare il confronto. 
        Dopo aver validato i bilanci e' possibile poi scegliere quali elementi confrontare e ottenerne una visualizzazione in formato tabellare o grafico.
        </p>
        

    </div>

    <div class="row" runat="server" id="mainrow">
        <div class="col-md-4">
            <h2>Loading</h2>
            <p>
                Insert here two distinct Xbrl instance files.
            </p>
            <p>
                <asp:FileUpload ID="FileUpload1" runat="server" />
            <br />
            <asp:FileUpload ID="FileUpload2" runat="server" />
                <br />
            <asp:LinkButton ID="LoadButton" runat="server" CssClass="btn btn-default" OnClick="LoadButton_Click">Load</asp:LinkButton>
            </p>
            <div runat="server" id="Span1"></div>
        </div>
        <div class="col-md-4">
            <h2>Validation</h2>
            <p>
                Verify that current uploaded files are valid.
            </p>
            <p>
                <asp:LinkButton ID="ValidateButton" runat="server" CssClass="btn btn-default" OnClick="ValidateButton_Click" >Validate</asp:LinkButton>                
            </p>
            <div runat="server" id="Span2"></div>
        </div>
        <div class="col-md-4">
            <h2>Compare</h2>
            <p>
                You can easily compare two financial statements from different companies (relating the same period) navigating through financial elements.
            </p>
            <p>
                <asp:LinkButton ID="CompareButton" runat="server" CssClass="btn btn-default" OnClick="CompareButton_Click" >Confronta</asp:LinkButton>                
            </p>
            <div runat="server" id="Span3"></div>
        </div>
    </div>
    <div class="row" runat="server" id="secondrow">

 

    <p>Select type chart and category to visualize compared data</p>       
    <select id="typeSelect" style="font-size:1.4em; margin: 10px;">
        <option value ="bar">Barre</option>
        <option value ="column">Colonne</option>
        <option value ="pie">Torta</option>
        <option value ="doughnut">Ciambella</option>
    </select>
    Anno <select id="yearSelect" style="font-size:1.4em; margin: 10px;"></select>
    Sezione <select id="catSelect" style="font-size:1.4em; margin: 10px;">
    </select>
        <br />
    Bilancio in <span id="currency"></span>
    <input type="button" id="go" value="  show data  " style="font-size:1.4em; margin: 10px;" />
    <br />
    
    <br />
    <div id="chartContainer1" style="height: 360px; width: 45%; margin: 10px;float:left;"></div>
    <div id="chartContainer2" style="height: 360px; width: 45%; margin: 10px;float:right;"></div>

<script type="text/javascript">

    $(function () {

        var bilancio = { "?xml": { "@version": "1.0", "@encoding": "UTF-8" }, "xbrl": { "@xmlns": "http://www.xbrl.org/2003/instance", "@xmlns:link": "http://www.xbrl.org/2003/linkbase", "@xmlns:xlink": "http://www.w3.org/1999/xlink", "@xmlns:itcc-ci": "http://www.infocamere.it/itnn/fr/itcc/ci/2013-01-04", "@xmlns:itcc-ci-ese": "http://www.infocamere.it/itnn/fr/itcc/ci/ese/2013-01-04", "@xmlns:iso4217": "http://www.xbrl.org/2003/iso4217", "link:schemaRef": { "@xlink:type": "simple", "@xlink:arcrole": "http://www.w3.org/1999/xlink/properties/linkbase", "@xlink:href": "itcc-ci-ese-2013-01-04.xsd" }, "context": [{ "@id": "i_31-12-2012", "entity": { "identifier": { "@scheme": "http://www.infocamere.it", "#text": "Careggi" } }, "period": { "instant": "2012-12-31" }, "scenario": { "itcc-ci-ese:scen": "Depositato" } }, { "@id": "d_31-12-2012", "entity": { "identifier": { "@scheme": "http://www.infocamere.it", "#text": "Careggi" } }, "period": { "startDate": "2012-01-01", "endDate": "2012-12-31" }, "scenario": { "itcc-ci-ese:scen": "Depositato" } }, { "@id": "i_31-12-2013", "entity": { "identifier": { "@scheme": "http://www.infocamere.it", "#text": "Careggi" } }, "period": { "instant": "2013-12-31" }, "scenario": { "itcc-ci-ese:scen": "Depositato" } }, { "@id": "d_31-12-2013", "entity": { "identifier": { "@scheme": "http://www.infocamere.it", "#text": "Careggi" } }, "period": { "startDate": "2013-01-01", "endDate": "2013-12-31" }, "scenario": { "itcc-ci-ese:scen": "Depositato" } }], "unit": { "@id": "eur", "measure": "iso4217:EUR" }, "itcc-ci:ImmobilizzazioniImmaterialiCostiImpiantoAmpliamento": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "5989" }, "itcc-ci:ImmobilizzazioniImmaterialiConcessioniLicenzeMarchiDirittiSimili": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "1195920" }, "itcc-ci:ImmobilizzazioniImmaterialiImmobilizzazioniCorsoAcconti": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "371224" }, "itcc-ci:ImmobilizzazioniImmaterialiAltre": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "15851342" }, "itcc-ci:TotaleImmobilizzazioniImmateriali": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "17424475" }, "itcc-ci:ImmobilizzazioniMaterialiTerreniDisponibili": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "68534" }, "itcc-ci:ImmobilizzazioniMaterialiFabbricatiDisponibili": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "20758038" }, "itcc-ci:ImmobilizzazioniMaterialiFabbricatiIndisponibili": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "304529837" }, "itcc-ci:ImmobilizzazioniMaterialiTerreniFabbricati": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "325356409" }, "itcc-ci:ImmobilizzazioniMaterialiImpiantiMacchinario": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "31421494" }, "itcc-ci:ImmobilizzazioniMaterialiAttrezzatureSanitarieScientifiche": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "22278028" }, "itcc-ci:ImmobilizzazioniMaterialiAttrezzatureMobiliArredi": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "7514557" }, "itcc-ci:ImmobilizzazioniMaterialiAttrezzatureAutomezzi": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "18426" }, "itcc-ci:ImmobilizzazioniMaterialiAltriBeni": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "486528" }, "itcc-ci:ImmobilizzazioniMaterialiImmobilizzazioniCorsoAcconti": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "76954775" }, "itcc-ci:TotaleImmobilizzazioniMateriali": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "464030217" }, "itcc-ci:TotaleImmobilizzazioni": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "481668726" }, "itcc-ci:CreditiVersoAltriEsigibiliOltreEsercizioSuccessivo": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "500" }, "itcc-ci:CreditiVersoAltriTotaleCreditiVersoAltri": [{ "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "500" }, { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "24144129" }], "itcc-ci:ImmobilizzazioniFinanziariePartecipazioni": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "213534" }, "#comment": [], "itcc-ci:RimanenzeBeniSanitari": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "21402053" }, "itcc-ci:RimanenzeBeniNonSanitari": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "940189" }, "itcc-ci:RimanenzeAccontiAcquistiBeniSanitari": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "379594" }, "itcc-ci:TotaleRimanenze": { "@contextRef": "i_31-12-2013", "@unitRef": "eur", "@decimals": "0", "#text": "22721837" } } };

        // do some cleaning and initialization
        delete bilancio["?xml"];
        delete bilancio.xbrl["link:schemaRef"];
        delete bilancio.xbrl["@xmlns:link"];
        delete bilancio.xbrl["@xmlns:xlink"];
        delete bilancio.xbrl["@xmlns"];
        delete bilancio.xbrl["@xmlns:itcc-ci"];
        delete bilancio.xbrl["@xmlns:itcc-ci-ese"];
        delete bilancio.xbrl["@xmlns:iso4217"];
        // get years from financial reports and bind them to select
        var years = getYears(bilancio);
        $.each(years, function (i, item) {
            $('#yearSelect').append($('<option>', {
                value: item,
                text: item
            }));
        });

        // Get titles from financial reports and bind them to select
        var titles = aggregateTitles(bilancio);
        $.each(titles, function (i, item) {
            $('#catSelect').append($('<option>', {
                value: item,
                text: item
            }));
        });

        delete bilancio.xbrl.context;
        // show current currency
        $('#currency').text(bilancio.xbrl.unit.measure);
        delete bilancio.xbrl.unit;

        // set up chart #1
        $("#chartContainer1").CanvasJSChart({
            title: {
                text: "AOU Careggi"
            },
            animationEnabled: true,
            axisY: { title: "Valore in euro", },
            data: [
			{
			    type: "doughnut",
			    indexLabelFontFamily: "Garamond",
			    indexLabelFontSize: 14,
			    startAngle: 0,
			    indexLabelFontColor: "dimgrey",
			    indexLabelLineColor: "darkgrey",
			    toolTipContent: "{y} €",
			    dataPoints: []
			}
            ]
        });
        // set up chart #2
        $("#chartContainer2").CanvasJSChart({
            title: {
                text: "ASL 11"
            },
            animationEnabled: true,
            axisY: { title: "Valore in euro", },
            data: [
			{
			    type: "doughnut",
			    indexLabelFontFamily: "Garamond",
			    indexLabelFontSize: 14,
			    startAngle: 0,
			    indexLabelFontColor: "dimgrey",
			    indexLabelLineColor: "darkgrey",
			    toolTipContent: "{y} €",
			    dataPoints: []
			}
            ]
        });
        // handle chart type change event
        $('#typeSelect').change(function () {
            var chart1 = $("#chartContainer1").CanvasJSChart();
            var chart2 = $("#chartContainer2").CanvasJSChart();
            chart1.options.data[0].type = $('#typeSelect').val();
            chart2.options.data[0].type = $('#typeSelect').val();
            chart1.render();
            chart2.render();
        });

        // handle section change event
        $('#catSelect').change(function () {
            var chart1 = $("#chartContainer1").CanvasJSChart();
            var chart2 = $("#chartContainer2").CanvasJSChart();
            // bind chart data
            var chartData = [];
            jQuery.each(bilancio.xbrl, function (i, item) {
                
                var wordLength = $('#catSelect').val().length;
                if ($('#catSelect').val() === i.replace("itcc-ci:", "").substring(0, wordLength)) {
                    var concept = splitCamel(i.replace("itcc-ci:", "").replace($('#catSelect').val(),""));
                    var b = { 'indexLabel': concept, 'y': item["#text"] };
                    console.log(b);
                    chartData.push(b);
                };
                
            });
            chart1.options.data[0].dataPoints = chartData;
            chart2.options.data[0].dataPoints = chartData;
            chart1.render();
            chart2.render();
        });

        // handle year change event
        $('#yearSelect').change(function () {
            var chart1 = $("#chartContainer1").CanvasJSChart();
            var chart2 = $("#chartContainer2").CanvasJSChart();
            // to do
            chart1.render();
            chart2.render();
        });

        $('#go').on('click', function () {
            var chart1 = $("#chartContainer1").CanvasJSChart();
            var chart2 = $("#chartContainer2").CanvasJSChart();
            chart1.render();
            chart2.render();
        });

    });
</script>
    </div>
</asp:Content>
