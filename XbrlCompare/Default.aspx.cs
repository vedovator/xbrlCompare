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
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                secondrow.Visible = false;
            }
        }

        protected void LoadButton_Click(object sender, EventArgs e)
        {
          string filepath = Server.MapPath("\\Upload");
          HttpFileCollection uploadedFiles = Request.Files;
          Span1.InnerHtml = string.Empty;

          
              HttpPostedFile userPostedFile1 = uploadedFiles[0];
              HttpPostedFile userPostedFile2 = uploadedFiles[1];
              int FileLen;
              System.IO.Stream MyStream;

              try {
                  // process file #1
                  // check if it has xml extension
                  if ((userPostedFile1.ContentLength > 0) && (System.IO.Path.GetExtension(userPostedFile1.FileName).ToLower() == ".xml"))
                  {
                      FileLen = userPostedFile1.ContentLength;
                      byte[] input = new byte[FileLen];
                      // Initialize the stream.
                      MyStream = userPostedFile1.InputStream;
                      // Read the file into the byte array.
                      MyStream.Read(input, 0, FileLen);
                      // Copy the byte array into a string.
                      for (int Loop1 = 0; Loop1 < FileLen; Loop1++)
                          MyString = MyString + input[Loop1].ToString();
                      Session["xmlfile1"] = MyString;
                      Span1.InnerHtml += "<u>File #1</u><br>";
                     Span1.InnerHtml += "File Content Type: " +  userPostedFile1.ContentType      + "<br>";
                     Span1.InnerHtml += "File Size: " + FileLen + "kb<br>";
                     Span1.InnerHtml += "File Name: " + userPostedFile1.FileName + "<br>";

                  }
                  // process file #2
                  if ((userPostedFile2.ContentLength > 0) && (System.IO.Path.GetExtension(userPostedFile2.FileName).ToLower() == ".xml"))
                  {
                      FileLen = userPostedFile2.ContentLength;
                      byte[] input = new byte[FileLen];
                      // Initialize the stream.
                      MyStream = userPostedFile2.InputStream;
                      // Read the file into the byte array.
                      MyStream.Read(input, 0, FileLen);
                      MyString = "";
                      // Copy the byte array into a string.
                      for (int Loop1 = 0; Loop1 < FileLen; Loop1++)
                          MyString = MyString + input[Loop1].ToString();
                      Session["xmlfile2"] = MyString; 
                      Span1.InnerHtml += "<u>File #1</u><br>";
                      Span1.InnerHtml += "File Content Type: " + userPostedFile2.ContentType + "<br>";
                      Span1.InnerHtml += "File Size: " + userPostedFile2.ContentLength + "kb<br>";
                      Span1.InnerHtml += "File Name: " + userPostedFile2.FileName + "<br>";
                  }

              } catch(Exception Ex) {
                  Span1.InnerHtml = "Error: <br>" + Ex.Message;
              }
          
        }

         void booksSettingsValidationEventHandler(object sender, ValidationEventArgs e)
        {
            if (e.Severity == XmlSeverityType.Warning)
            {
                Span1.InnerHtml ="WARNING: " + e.Message;
            }
            else if (e.Severity == XmlSeverityType.Error)
            {
                Span1.InnerHtml = "ERROR: " + e.Message;
            }
        }

        protected void ValidateButton_Click(object sender, EventArgs e)
        {
            XmlReaderSettings xbrlSettings = new XmlReaderSettings();
            string xsdfilepath = Server.MapPath("\\Test\\shiporder.xsd");
            // string xmlfilepath = Server.MapPath("\\Test\\order001.xml");
            xbrlSettings.Schemas.Add("http://vedovator.it/shiporder.xsd", xsdfilepath);
            xbrlSettings.ValidationType = ValidationType.Schema;
            xbrlSettings.ValidationEventHandler += new ValidationEventHandler(booksSettingsValidationEventHandler);
            XmlDocument doc = new XmlDocument();

            XmlReader reader1 = XmlReader.Create(Session["xmlfile1"].ToString(), xbrlSettings);

            if (reader1.Read()) {          
                doc.Load(reader1);
                string json = JsonConvert.SerializeXmlNode(doc);
                Span2.InnerHtml = "I file trasmessi sono validi.<br />";
                Span2.InnerHtml += json;
            }

            XmlReader reader2 = XmlReader.Create(Session["xmlfile2"].ToString(), xbrlSettings);

            if (reader2.Read())
            {
                doc.Load(reader2);
                string json = JsonConvert.SerializeXmlNode(doc);
                Span2.InnerHtml += "<br /><br />";
                Span2.InnerHtml += json;
            }


        }

        protected void CompareButton_Click(object sender, EventArgs e)
        {
            mainrow.Visible = false;
            secondrow.Visible = true;
            //To do legare i file trasmessi al codice del pivottable

        }



        }
    }
