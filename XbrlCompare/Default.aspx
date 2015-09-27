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
   <p>Select category to visualize compared data</p>       
    Bilancio in <span id="currency"></span> per l'anno <select id="yearSelect" style="font-size:1.4em; margin: 10px;"></select>
    <div style="width:200px; margin: 10px;float:left;">
        <div class="list-group">
            <a href="#" title="" class="list-group-item active">STATO PATRIMONIALE</a>
            <a href="#" title="Immobilizzazioni" class="list-group-item">Immobilizzazioni</a>
            <a href="#" title="Rimanenze,Crediti,AttivitaFinanziarie,DisponibilitaLiquide" class="list-group-item">Attivo circolante</a>
            <a href="#" title="Ratei,Risconti" class="list-group-item">Ratei e risconti attivi</a>
            <a href="#" title="Conti" class="list-group-item">Conti d'ordine</a>
            <a href="#" title="Conti" class="list-group-item">Patrimonio netto</a>
            <a href="#" title="Conti" class="list-group-item">Fondo per rischi ed oneri</a>
            <a href="#" title="Conti" class="list-group-item">Trattamento Fine Rapporto</a>
            <a href="#" title="Conti" class="list-group-item">Debiti</a>
            <a href="#" title="Conti" class="list-group-item">Ratei e risconti passivi</a>
        </div>
        <div class="list-group">
            <a href="#" title="" class="list-group-item active">CONTO ECONOMICO</a>
            <a href="#" title="" class="list-group-item">Valore della produzione</a>
            <a href="#" title="" class="list-group-item">Costi della produzione</a>
            <a href="#" title="" class="list-group-item">Proventi e oneri finanziari</a>
            <a href="#" title="" class="list-group-item">Rettifiche di valore di attività finanziarie</a>
            <a href="#" title="" class="list-group-item">Proventi e oneri straordinari</a>
            <a href="#" title="" class="list-group-item">Imposte sul reddito dell'esercizio</a>
        </div>
    Sezione <select id="catSelect" style="font-size:1.4em; margin: 10px;">
        <option value ="jhlkajsdhf">Select a value</option>
    </select>    <br />
    <input type="button" id="go" value="  show data  " style="font-size:1.4em; margin: 10px;" />
</div>
<div id="chartContainer1" style="height: 360px; width: 65%; margin: 10px;float:right;" ></div>
<div id="chartContainer2" style="height: 360px; width: 65%; margin: 10px;float:right;"></div>

<script type="text/javascript">

    $(function () {

        var bilancio1 = <%= Session["json1"]  %>;
        var bilancio2 = <%= Session["json2"]  %>;

        // do some cleaning and initialization
        delete bilancio1["?xml"];
        delete bilancio1.xbrl["link:schemaRef"];
        delete bilancio1.xbrl["@xmlns:link"];
        delete bilancio1.xbrl["@xmlns:xlink"];
        delete bilancio1.xbrl["@xmlns"];
        delete bilancio1.xbrl["@xmlns:itcc-ci"];
        delete bilancio1.xbrl["@xmlns:itcc-ci-ese"];
        delete bilancio1.xbrl["@xmlns:iso4217"];
        delete bilancio2["?xml"];
        delete bilancio2.xbrl["link:schemaRef"];
        delete bilancio2.xbrl["@xmlns:link"];
        delete bilancio2.xbrl["@xmlns:xlink"];
        delete bilancio2.xbrl["@xmlns"];
        delete bilancio2.xbrl["@xmlns:itcc-ci"];
        delete bilancio2.xbrl["@xmlns:itcc-ci-ese"];
        delete bilancio2.xbrl["@xmlns:iso4217"];
        // get years from financial reports and bind them to select
        var years = getYears(bilancio1);
        $.each(years, function (i, item) {
            $('#yearSelect').append($('<option>', {
                value: item,
                text: item
            }));
        });

        // Get titles from financial reports and bind them to select
        var titles = aggregateTitles(bilancio1);
        $.each(titles, function (i, item) {
            $('#catSelect').append($('<option>', {
                value: item,
                text: item
            }));
        });

        delete bilancio1.xbrl.context;
        // show current currency
        $('#currency').text(bilancio1.xbrl.unit.measure);
        delete bilancio1.xbrl.unit;

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
        /* handle chart type change event
        $('#typeSelect').change(function () {
            var chart1 = $("#chartContainer1").CanvasJSChart();
            var chart2 = $("#chartContainer2").CanvasJSChart();
            chart1.options.data[0].type = $('#typeSelect').val();
            chart2.options.data[0].type = $('#typeSelect').val();
            chart1.render();
            chart2.render();
        }); no more useful */

        // handle section change event
        $('#catSelect').change(function () {
            var chart1 = $("#chartContainer1").CanvasJSChart();
            var chart2 = $("#chartContainer2").CanvasJSChart();
            // bind chart data
            var chart1Data = [];
            var chart2Data = [];
            jQuery.each(bilancio1.xbrl, function (i, item) {
                
                var wordLength = $('#catSelect').val().length;
                if ($('#catSelect').val() === i.replace("itcc-ci:", "").substring(0, wordLength)) {
                    var concept = splitCamel(i.replace("itcc-ci:", "").replace($('#catSelect').val(),""));
                    if (concept.indexOf('Totale') < 0) {
                        var b = { 'indexLabel': concept, 'y': item["#text"] };
                        chart1Data.push(b);
                    } else { console.log(b);  };
                };
            });
            jQuery.each(bilancio2.xbrl, function (i, item) {
                
                var wordLength = $('#catSelect').val().length;
                if ($('#catSelect').val() === i.replace("itcc-ci:", "").substring(0, wordLength)) {
                    var concept = splitCamel(i.replace("itcc-ci:", "").replace($('#catSelect').val(),""));
                    if (concept.indexOf('Totale') < 0) {
                        var b = { 'indexLabel': concept, 'y': item["#text"] };
                        chart2Data.push(b);
                    } else { console.log(b);  };
                };
            });
            chart1.options.data[0].dataPoints = chart1Data;
            chart2.options.data[0].dataPoints = chart2Data;
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
