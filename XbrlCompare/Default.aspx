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
            <h2>Caricamento</h2>
            <p>
                Inserisci qui due file xbrl. <br />
                (Puoi usare questi esempi: <a href="Test/IstanzaCareggi2013.xml">AOUCareggi 2013</a> - <a href="Test/IstanzaEmpoli2013.xml">ASL11 2013</a>
                 - <a href="Test/IstanzaEmpoli2012.xml">ASL11 2012</a>)
            </p>
            <p>
                <asp:FileUpload ID="FileUpload1" runat="server" />
            <br />
            <asp:FileUpload ID="FileUpload2" runat="server" />
                <br />
            <asp:LinkButton ID="LoadButton" runat="server" CssClass="btn btn-default" OnClick="LoadButton_Click">Carica</asp:LinkButton>
            </p>
            <div runat="server" id="Span1" enableviewstate="false"></div>
        </div>
        <div class="col-md-4">
            <h2>Validazione</h2>
            <p>
                Verifica che i files siano validi.
            </p>
            <p>
                <asp:LinkButton ID="ValidateButton" runat="server" CssClass="btn btn-default" OnClick="ValidateButton_Click" >Valida</asp:LinkButton>                
            </p>
            <div runat="server" id="Span2" class="alert" enableviewstate="false"></div>
        </div>
        <div class="col-md-4">
            <h2>Confronta</h2>
            <p>
                Puoi confrontare due bilanci di aziende differenti navigando le sezioni di bilancio.
            </p>
            <p>
                <asp:LinkButton ID="CompareButton" runat="server" CssClass="btn btn-default" OnClick="CompareButton_Click" >Confronta</asp:LinkButton>                
            </p>
            <div runat="server" id="Span3"></div>
        </div>
    </div>
    <div class="row" runat="server" id="secondrow">
   <p>Seleziona la categoria per visualizzare la comparazione</p>       
    <div style="width:200px; margin: 10px;float:left;">
        <div class="list-group">
            <a href="#secondrow" title="sp" class="list-group-item active">STATO PATRIMONIALE</a>
            <a href="#secondrow" title="Immobilizzazioni" class="list-group-item">Immobilizzazioni</a>
            <a href="#secondrow" title="Rimanenze,Crediti,AttivitaFinanziarie,DisponibilitaLiquide" class="list-group-item">Attivo circolante</a>
            <a href="#secondrow" title="AttivoRateiRisconti" class="list-group-item">Ratei e risconti attivi</a>
            <a href="#secondrow" title="PatrimonioNetto" class="list-group-item">Patrimonio netto</a>
            <a href="#secondrow" title="FondiRischiOneri" class="list-group-item">Fondo per rischi ed oneri</a>
            <a href="#secondrow" title="TrattamentoFineRapporto" class="list-group-item">Trattamento Fine Rapporto</a>
            <a href="#secondrow" title="Debiti" class="list-group-item">Debiti</a>
            <a href="#secondrow" title="PassivoRateiRisconti" class="list-group-item">Ratei e risconti passivi</a>
        </div>
        <div class="list-group">
            <a href="#secondrow" title="ce" class="list-group-item active">CONTO ECONOMICO</a>
            <a href="#secondrow" title="ValoreProduzione" class="list-group-item">Valore della produzione</a>
            <a href="#secondrow" title="CostiProduzione" class="list-group-item">Costi della produzione</a>
            <a href="#secondrow" title="ProventiOneriFinanziari" class="list-group-item">Proventi e oneri finanziari</a>
            <a href="#secondrow" title="RettificheValoreAttivita" class="list-group-item">Rettifiche di valore di attività finanziarie</a>
            <a href="#secondrow" title="ProventiOneriStraordinari" class="list-group-item">Proventi e oneri straordinari</a>
            <a href="#secondrow" title="ImposteRedditoEsercizio" class="list-group-item">Imposte sul reddito dell'esercizio</a>
        </div>
</div>
<div id="chartContainer1" style="height: 450px; width: 65%; margin: 10px;float:right;" ></div>
<div id="chartContainer2" style="height: 450px; width: 65%; margin: 10px;float:right;"></div>

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
        bilancio1.xbrl.year = getYear(bilancio1.xbrl);
        bilancio2.xbrl.year = getYear(bilancio2.xbrl);

        delete bilancio1.xbrl.context;
        delete bilancio2.xbrl.context;
        // don't care about currency
        delete bilancio1.xbrl.unit;
        delete bilancio2.xbrl.unit;

        CanvasJS.addCultureInfo("it",
                {
                    decimalSeparator: ",",
                    digitGroupSeparator: ".",
                    days: ["domenica", "lunedi", "martedi", "mercoledi", "giovedi", "venerdi", "sabato"],
                });

        // set up chart #1
        $("#chartContainer1").CanvasJSChart({
            title: {
                text: "1"
            },
            animationEnabled: true,
            axisY: { title: "Valore in euro", },
            culture:  "it",
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
                text: "2"
            },
            animationEnabled: true,
            axisY: { title: "Valore in euro", },
            culture:  "it",
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
  

        // handle left menu selection
        $('.list-group-item').click(function() {
            $('.list-group-item').removeClass("active");
            $(this).addClass( "active" ); 
            var sections = $(this).attr("title");
            //console.log(sections);
            var chart1 = $("#chartContainer1").CanvasJSChart();
            var chart2 = $("#chartContainer2").CanvasJSChart();
            
            if (bilancio1.xbrl.year==bilancio2.xbrl.year) {
                // bind chart data
                var chart1Data = extractInfo(bilancio1.xbrl, sections);
                var chart2Data = extractInfo(bilancio2.xbrl, sections);
                chart1.options.data[0].dataPoints = chart1Data;
                chart2.options.data[0].dataPoints = chart2Data;
                chart1.options.title.text = bilancio1.xbrl["itcc-ci:DatiAnagraficiDenominazione"]["#text"] + " - Anno " + bilancio1.xbrl.year;
                chart2.options.title.text = bilancio2.xbrl["itcc-ci:DatiAnagraficiDenominazione"]["#text"] + " - Anno " + bilancio2.xbrl.year;
                chart1.render();
                chart2.render();

            }
            // set up historical compare
            else {
                // bind chart data
                var chart1Data = extractHistInfo(bilancio1.xbrl, bilancio2.xbrl, sections);
                
                chart1.options.axisY.includeZero = false;
                chart1.options.data = chart1Data;
                chart1.options.title.text = bilancio1.xbrl["itcc-ci:DatiAnagraficiDenominazione"]["#text"];
                chart1.render();
                chart2.options.title.text="";
                chart2.options.data[0].dataPoints=[];
                chart2.render();
            
            }

        });

    });
</script>
    </div>
</asp:Content>
