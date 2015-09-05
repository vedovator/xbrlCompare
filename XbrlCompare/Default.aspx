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
                Inserisci qui sotto i due distinti file premendo sul tasto sfoglia.
            </p>
            <p>
                <asp:FileUpload ID="FileUpload1" runat="server" />
            <br />
            <asp:FileUpload ID="FileUpload2" runat="server" />
                <br />
            <asp:LinkButton ID="LoadButton" runat="server" CssClass="btn btn-default" OnClick="LoadButton_Click">Carica</asp:LinkButton>
            </p>
            <div runat="server" id="Span1"></div>
        </div>
        <div class="col-md-4">
            <h2>Validazione</h2>
            <p>
                Verifica che il file trasmesso sia valido per la tassonomia sperimentale in uso.
            </p>
            <p>
                <asp:LinkButton ID="ValidateButton" runat="server" CssClass="btn btn-default" OnClick="ValidateButton_Click" >Valida</asp:LinkButton>                
            </p>
            <div runat="server" id="Span2"></div>
        </div>
        <div class="col-md-4">
            <h2>Confronto</h2>
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

        <script type="text/javascript">
            google.load("visualization", "1", {packages:["corechart", "charteditor"]});
            $(function(){
                var renderers = $.extend($.pivotUtilities.renderers, 
                    $.pivotUtilities.gchart_renderers);

                $.getJSON("Test/mps1.json", function(mps) {
                    $("#output1").pivotUI(mps, {
                        renderers: renderers,                       
                        cols: ["Gender"], rows: ["Party"],
                        rendererName: "Area Chart1"
                    });
                });
                $.getJSON("Test/mps2.json", function (mps) {
                    $("#output2").pivotUI(mps, {
                        renderers: renderers,
                        cols: ["Gender"], rows: ["Party"],
                        rendererName: "Area Chart2"
                    });
                });
                $(".pvtRenderer").change(function () {
                    // $(".pvtRenderer").val(this.value);
                    alert("Handler for .change() called.");
                });
             });
        </script>

        <p>Sposta le etichette per visualizzare il confronto su dati diversi</p>       
        <div id="output1" style="margin: 30px;float:left;"></div>
        <div id="output2" style="margin: 30px;float:right;"></div>

    </div>
</asp:Content>
