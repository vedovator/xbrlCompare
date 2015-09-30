﻿using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Schema;

namespace Confronti
{
    public partial class _Default : Page
    {
        protected string MyString;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                secondrow.Visible = false;
            }
        }

        protected void LoadButton_Click(object sender, EventArgs e)
        {
          HttpFileCollection uploadedFiles = Request.Files;
          Span1.InnerHtml = string.Empty;
          
              HttpPostedFile userPostedFile1 = uploadedFiles[0];
              HttpPostedFile userPostedFile2 = uploadedFiles[1];

              try {
                  // process file #1
                  // check if it has xml extension
                  if ((userPostedFile1.ContentLength > 0) && (userPostedFile2.ContentLength > 0) )
                  {
                      if ((System.IO.Path.GetExtension(userPostedFile1.FileName).ToLower() == ".xml") && (System.IO.Path.GetExtension(userPostedFile2.FileName).ToLower() == ".xml"))
                      {
                          MyString = new StreamReader(userPostedFile1.InputStream).ReadToEnd();
                          Session["xmlfile1"] = MyString;
                          Span1.InnerHtml += "<u>File #1</u><br>";
                          Span1.InnerHtml += "File Content Type: " + userPostedFile1.ContentType + "<br>";
                          Span1.InnerHtml += "File Size: " + userPostedFile2.ContentLength + "kb<br>";
                          Span1.InnerHtml += "File Name: " + userPostedFile1.FileName + "<br>";

                          // process file #2
                          MyString = new StreamReader(userPostedFile2.InputStream).ReadToEnd();
                          Session["xmlfile2"] = MyString;
                          Span1.InnerHtml += "<u>File #2</u><br>";
                          Span1.InnerHtml += "File Content Type: " + userPostedFile2.ContentType + "<br>";
                          Span1.InnerHtml += "File Size: " + userPostedFile2.ContentLength + "kb<br>";
                          Span1.InnerHtml += "File Name: " + userPostedFile2.FileName + "<br>";
                      }
                      else Span1.InnerHtml = "Errore: il file non ha estenzione .xml";
                  }
                  else Span1.InnerHtml = "Errore: sono richiesti almeno due files";
                  

              } catch(Exception Ex) {
                  Span1.InnerHtml = "Error: <br>" + Ex.Message;
              }
          
        }

         void xbrlValidationEventHandler(object sender, ValidationEventArgs e)
        {
            if (e.Severity == XmlSeverityType.Warning)
            {
                Span2.InnerHtml ="WARNING: " + e.Message;
            }
            else if (e.Severity == XmlSeverityType.Error)
            {
                Span2.InnerHtml = "ERROR: " + e.Message;
            }
            else Span2.InnerHtml = "UNH: " + e.Message;
        }

        protected void ValidateButton_Click(object sender, EventArgs e)
        {
            string xsdfilepath = Server.MapPath("\\Test\\itvedo-ci-ese-2015-05-22.xsd");
            // Create the XmlSchemaSet class.
            XmlSchemaSet sc = new XmlSchemaSet();
            // Add the schema to the collection
            sc.Add("http://www.infocamere.it/itnn/fr/itcc/ci/ese/2014-11-17", xsdfilepath);
            
            ValidationEventHandler veh = new ValidationEventHandler(xbrlValidationEventHandler);
            XmlDocument doc = new XmlDocument();
            doc.Schemas = sc;
            doc.LoadXml(Session["xmlfile1"].ToString());
            doc.Validate(veh);
            XmlDocument doc2 = new XmlDocument();
            doc2.Schemas = sc;
            doc2.LoadXml(Session["xmlfile2"].ToString());
            doc2.Validate(veh);
            Span2.InnerHtml = "I file trasmessi sono validi.<br />";
            
            // now convert in Json and show on span2
            string json = JsonConvert.SerializeXmlNode(doc);
            Session["json1"] = json;
            //Span2.InnerHtml += json;
            json = JsonConvert.SerializeXmlNode(doc2);
            Session["json2"] = json;
            Span2.InnerHtml += "Files convertiti in formato JSON<br />";
            //Span2.InnerHtml += json;
        }

        protected void CompareButton_Click(object sender, EventArgs e)
        {
            mainrow.Visible = false;
            secondrow.Visible = true;
            //To do legare i file trasmessi al codice del pivottable

        }



        }
    }
