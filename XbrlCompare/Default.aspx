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
    <select id="catSelect" style="font-size:1.4em; margin: 10px;">
        <option value ="CEvp">Conto Economico-Valore della Produzione</option>
        <option value ="CEcp">Conto Economico-Costi della Produzione</option>
        <option value ="SPat">Stato Patrimoniale - Attivo</option>
        <option value ="SPpa">Stato Patrimoniale - Passivo</option>
    </select>
    <br />
    <div id="chartContainer1" style="height: 360px; width: 45%; margin: 10px;float:left;"></div>
    <div id="chartContainer2" style="height: 360px; width: 45%; margin: 10px;float:right;"></div>

<script type="text/javascript">

    $(function () {
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


			    dataPoints: [
				{ y: 458756, indexLabel: "Costi Personale sanitario {y}€" },
				{ y: 448875, indexLabel: "Costi Personale non sanitario {y}€" },
				{ y: 82564, indexLabel: "Costi Dirigenza Sanitaria {y}€" },
				{ y: 78554, indexLabel: "Costi Dirigenza non sanitaria {y}€" },
				{ y: 154326, indexLabel: "Costi XYZ {y}€" },
				{ y: 89657, indexLabel: "Others {y}€" }

			    ]
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

			    dataPoints: [
				{ y: 258756, indexLabel: "Costi Personale sanitario {y}€" },
				{ y: 348875, indexLabel: "Costi Personale non sanitario {y}€" },
				{ y: 122564, indexLabel: "Costi Dirigenza Sanitaria {y}€" },
				{ y: 118554, indexLabel: "Costi Dirigenza non sanitaria {y}€" },
				{ y: 134326, indexLabel: "Costi XYZ {y}€" },
				{ y: 69657, indexLabel: "Others {y}€" }

			    ]
			}
            ]
        });
        // handle change chart type event
        $('#typeSelect').change(function () {
            var chart1 = $("#chartContainer1").CanvasJSChart();
            var chart2 = $("#chartContainer2").CanvasJSChart();
            chart1.options.data[0].type = $('#typeSelect').val();
            chart2.options.data[0].type = $('#typeSelect').val();
            chart1.render();
            chart2.render();
        });
    });
</script>
    </div>
</asp:Content>
