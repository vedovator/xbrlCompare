using Newtonsoft.Json;
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
        bool anyerror = false;
        
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
                  // check if it has xml or xbrl extension
                  if ((userPostedFile1.ContentLength > 0) && (userPostedFile2.ContentLength > 0) )
                  {
                      string file1ext = System.IO.Path.GetExtension(userPostedFile1.FileName).ToLower();
                      string file2ext = System.IO.Path.GetExtension(userPostedFile2.FileName).ToLower();
                      if ((file1ext == ".xml") && (file2ext == ".xml") || (file1ext == ".xbrl") && (file2ext == ".xbrl"))
                      {
                          MyString = new StreamReader(userPostedFile1.InputStream).ReadToEnd();
                          Session["xmlfile1"] = MyString;
                          Span1.InnerHtml += "<u>File #1</u><br>";
                          Span1.InnerHtml += "File Content Type: " + userPostedFile1.ContentType + "<br>";
                          Span1.InnerHtml += "File Size: " + userPostedFile2.ContentLength + " bytes<br>";
                          Span1.InnerHtml += "File Name: " + userPostedFile1.FileName + "<br>";

                          // process file #2
                          MyString = new StreamReader(userPostedFile2.InputStream).ReadToEnd();
                          Session["xmlfile2"] = MyString;
                          Span1.InnerHtml += "<u>File #2</u><br>";
                          Span1.InnerHtml += "File Content Type: " + userPostedFile2.ContentType + "<br>";
                          Span1.InnerHtml += "File Size: " + userPostedFile2.ContentLength + " bytes<br>";
                          Span1.InnerHtml += "File Name: " + userPostedFile2.FileName + "<br>";
                      }
                      else Span1.InnerHtml = "Errore: il file non ha estensione .xml o .xbrl";
                  }
                  else Span1.InnerHtml = "Errore: sono richiesti almeno due files";
                  

              } catch(Exception Ex) {
                  Span1.InnerHtml = "Errore: <br>" + Ex.Message;
              }
          
        }

         void xbrlValidationEventHandler(object sender, ValidationEventArgs e)
        {
            string myMessage = e.Message;
            // Reduce message length
            if (myMessage.Length>500) myMessage=myMessage.Substring(0,500) + " [...]";
            if (e.Severity == XmlSeverityType.Warning)
            {
                Span2.InnerHtml += "WARNING: " + myMessage + "<br />";
            }
            else if (e.Severity == XmlSeverityType.Error)
            {
                Span2.InnerHtml += "ERRORE: " + myMessage + "<br />";
                anyerror = true;
            }
            else Span2.InnerHtml += "UNH: " + myMessage + "<br />";
        }

        protected void ValidateButton_Click(object sender, EventArgs e)
        {

            
            string xsdfilepath = Server.MapPath("\\Test\\itvedo-ci-ese-2015-05-22.xsd");
            // Create the XmlSchemaSet class.
            XmlSchemaSet sc = new XmlSchemaSet();
            // Add the schema to the collection
            sc.Add("http://www.infocamere.it/itnn/fr/itvedo/ci/ese/2015-05-22", xsdfilepath);
            
            ValidationEventHandler veh = new ValidationEventHandler(xbrlValidationEventHandler);
            XmlDocument doc = new XmlDocument();
            doc.Schemas = sc;
            Span2.InnerHtml = "";
            try
            {
                doc.LoadXml(Session["xmlfile1"].ToString());
                doc.Validate(veh);
                
                XmlDocument doc2 = new XmlDocument();
                doc2.Schemas = sc;
                doc2.LoadXml(Session["xmlfile2"].ToString());
                doc2.Validate(veh);

                // now convert in Json and show on span2
                string json = JsonConvert.SerializeXmlNode(doc);
                Session["json1"] = json;
                json = JsonConvert.SerializeXmlNode(doc2);
                Session["json2"] = json;
                
            }
            catch (NullReferenceException)
            {
                Span2.InnerHtml = "Errore: Prima di validare il file è necessario effettuare l'upload. <br />&lt;--";
                anyerror = true;
            }
            catch (Exception Ex)
            {
                Span2.InnerHtml = "Errore: <br>" + Ex.Message;
                anyerror = true;
            }
            finally {
                if (!anyerror) Span2.InnerHtml += "I file trasmessi sono validi.<br />";

            }
        }

        protected void CompareButton_Click(object sender, EventArgs e)
        {
            mainrow.Visible = false;
            secondrow.Visible = true;
        }



        }
    }
