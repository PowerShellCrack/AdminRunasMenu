# -----------------------------------------------------------------------------
# Script: Convert-Image
# Author: Jason Hofferle
# Date: 04/14/2011
# Version: 1.0.0
# Comments: This script displays a GUI for resizing and converting image files.
# JPG metadata such as title, camera and rating are displayed in the right pane.
# The image can be resized to 200px, 600px or 1000px, which correspond to the 
# small, medium and large radio buttons. There is also the option to convert 
# between gif, jpg and png. Source and destination directory preferences are 
# saved to Convert-Image.xml in the My Documents folder.
#
# Since the scenario allowed for any approach for creating the solution, I 
# opted to write the code in C# and import the source code with Add-Type. The 
# script checks for the presence of .NET Framework 3.0, and verifies 
# PowerShell is running in STA mode.
#  
# -----------------------------------------------------------------------------
$sourceCode = @'

using System;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Windows.Media.Imaging;
using System.Xml;

public partial class Form1 : Form
{
    Bitmap myImage;
    XmlDocument xmlDocument = new XmlDocument();
    string documentPath = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "//Convert-Image.xml";

    public Form1()
    {
        InitializeComponent();

        try { xmlDocument.Load(documentPath); }
        catch { xmlDocument.LoadXml("<settings></settings>"); }
        
        txtSourceDir.Text = GetSetting("Form1/sourceDir", Environment.GetFolderPath(Environment.SpecialFolder.MyPictures));
        txtDestDir.Text = GetSetting("Form1/destDir", Environment.GetFolderPath(Environment.SpecialFolder.MyPictures));

        refreshFileList(txtSourceDir.Text);
        try
        {
            listBoxImages.SelectedItem = listBoxImages.Items[0];
        }
        catch
        {
        }
    }

    private void displayImage(string fileName)
    {
        try
        {
            myImage = new Bitmap(fileName);
            pictureBox1.Image = (Image)myImage;

            richTextBox1.Clear();
            richTextBox1.AppendText(readMetadata(fileName));
        }
        catch
        {
        }
    }

    private static Image resizeImage(Image imgToResize, Size size)
    {
        int sourceWidth = imgToResize.Width;
        int sourceHeight = imgToResize.Height;

        float nPercent = 0;
        float nPercentW = 0;
        float nPercentH = 0;

        nPercentW = ((float)size.Width / (float)sourceWidth);
        nPercentH = ((float)size.Height / (float)sourceHeight);

        if (nPercentH < nPercentW)
            nPercent = nPercentH;
        else
            nPercent = nPercentW;

        int destWidth = (int)(sourceWidth * nPercent);
        int destHeight = (int)(sourceHeight * nPercent);

        Bitmap b = new Bitmap(destWidth, destHeight);
        Graphics g = Graphics.FromImage((Image)b);
        g.InterpolationMode = InterpolationMode.HighQualityBicubic;

        g.DrawImage(imgToResize, 0, 0, destWidth, destHeight);
        g.Dispose();

        return (Image)b;
    }

    private void saveJpeg(string path, Bitmap img, long quality)
    {
        // Encoder parameter for image quality
        EncoderParameter qualityParam = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, quality);

        // Jpeg image codec
        ImageCodecInfo jpegCodec = this.getEncoderInfo("image/jpeg");

        if (jpegCodec == null)
            return;

        EncoderParameters encoderParams = new EncoderParameters(1);
        encoderParams.Param[0] = qualityParam;

        img.Save(path, jpegCodec, encoderParams);
    }

    private void saveGif(string path, Bitmap img, long quality)
    {
        EncoderParameter qualityParam = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, quality);

        ImageCodecInfo gifCodec = this.getEncoderInfo("image/gif");

        if (gifCodec == null)
            return;

        EncoderParameters encoderParams = new EncoderParameters(1);
        encoderParams.Param[0] = qualityParam;

        img.Save(path, gifCodec, encoderParams);
    }

    private void savePng(string path, Bitmap img, long quality)
    {
        EncoderParameter qualityParam = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, quality);

        ImageCodecInfo pngCodec = this.getEncoderInfo("image/png");

        if (pngCodec == null)
            return;

        EncoderParameters encoderParams = new EncoderParameters(1);
        encoderParams.Param[0] = qualityParam;

        img.Save(path, pngCodec, encoderParams);
    }

    private ImageCodecInfo getEncoderInfo(string mimeType)
    {
        // Get image codecs for all image formats
        ImageCodecInfo[] codecs = ImageCodecInfo.GetImageEncoders();

        // Find the correct image codec
        for (int i = 0; i < codecs.Length; i++)
            if (codecs[i].MimeType == mimeType)
                return codecs[i];
        return null;
    }

    private void btnSaveImage_Click(object sender, EventArgs e)
    {
        SaveSelected(listBoxImages.SelectedItem.ToString());
    }

    private void SaveSelected(string fileName)
    {
        Bitmap img = new Bitmap(fileName);

        Size mySize = new Size();

        if (radioThumb.Checked)
        {
            mySize.Width = 96;
            mySize.Height = 96;
        }

        if (radioSmall.Checked)
        {
            mySize.Width = 200;
            mySize.Height = 200;
        }

        if (radioMedium.Checked)
        {
            mySize.Width = 600;
            mySize.Height = 600;
        }

        if (radioLarge.Checked)
        {
            mySize.Width = 1000;
            mySize.Height = 1000;
        }

        //Image resizedImage = resizeImage(myImage, mySize);
        Bitmap resizedImage = new Bitmap(resizeImage(img, mySize));

        string newName = fileName;
        newName = "SHARE_" + newName.Substring(newName.LastIndexOf("\\") + 1);
        newName = newName.Substring(0, newName.LastIndexOf("."));
        
        if (radioJPEG.Checked)
        {
            saveJpeg(txtDestDir.Text + "\\" + newName + ".jpg", resizedImage, 100);
        }
        else if (radioGIF.Checked)
        {
            saveGif(txtDestDir.Text + "\\" + newName + ".gif", resizedImage, 100);
        }
        else
        {
            savePng(txtDestDir.Text + "\\" + newName + ".png", resizedImage, 100);
        }
    }

    private void SaveAll()
    {
        richTextBox1.Clear();

        foreach (string img in listBoxImages.Items)
        {
            SaveSelected(img);
        }
    }

    private void btnBrowse_Click(object sender, EventArgs e)
    {
        folderBrowserDialog1.SelectedPath = txtSourceDir.Text;
        DialogResult result = folderBrowserDialog1.ShowDialog();
        if (result == DialogResult.OK)
        {
            refreshFileList(folderBrowserDialog1.SelectedPath);
            txtSourceDir.Text = folderBrowserDialog1.SelectedPath;
        }
    }

    private void refreshFileList(string path)
    {
        listBoxImages.Items.Clear();
        try
        {
            DirectoryInfo dir = new DirectoryInfo(path);
            FileInfo[] file = dir.GetFiles();

            foreach (FileInfo fi in file)
            {
                if (".jpg|.jpeg|.bmp|.png|.gif".IndexOf(Path.GetExtension(fi.Name).ToLower()) >= 0)
                {
                    listBoxImages.Items.Add(fi.FullName);
                }
            }
        }
        catch
        {
        }

    }

    private void listBoxImages_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            displayImage(listBoxImages.SelectedItem.ToString());
        }
        catch
        {
        }
    }

    static string readMetadata(string filename)
    {
        BitmapSource img = BitmapFrame.Create(new Uri(filename));

        StringBuilder returnValue = new StringBuilder();

        /* Image data */
        double mpixel = (img.PixelHeight * img.PixelWidth) / (double)1000000;
        returnValue.AppendFormat("  Pixelsize {0}x{1} ({2} megapixels)", img.PixelWidth, img.PixelHeight, mpixel).AppendLine();
        returnValue.AppendFormat("  DPI {0}x{1}", img.DpiX, img.DpiY).AppendLine();

        /* Image metadata */
        BitmapMetadata meta = (BitmapMetadata)img.Metadata;

        //returnValue.AppendFormat("  metadatan    Type: {0}", meta.GetType()).AppendLine();
        returnValue.AppendFormat("  Title: {0}", meta.Title).AppendLine();
        returnValue.AppendFormat("  Subject: {0}", meta.Subject).AppendLine();
        returnValue.AppendFormat("  Comment: {0}", meta.Comment).AppendLine();
        returnValue.AppendFormat("  Date taken: {0}", meta.DateTaken).AppendLine();
        returnValue.AppendFormat("  Camera: {0} {1}", meta.CameraManufacturer, meta.CameraModel).AppendLine();
        returnValue.AppendFormat("  Copyright: {0}", meta.Copyright).AppendLine();

        StringBuilder authors = new StringBuilder();
        if (meta.Author != null)
        {
            foreach (string author in meta.Author)
            {
                authors.Append(author + "; ");
            }
            //Console.WriteLine("  Author(s): {0}", authors.ToString());
            returnValue.AppendFormat("  Author(s): {0}", authors.ToString()).AppendLine();
        }

        //Console.WriteLine("  Rating: {0}", meta.Rating);
        returnValue.AppendFormat("  Rating: {0}", meta.Rating).AppendLine();

        StringBuilder keyWords = new StringBuilder();
        if (meta.Keywords != null)
        {
            foreach (string keyword in meta.Keywords)
            {
                keyWords.Append(keyword + "; ");
            }
            //Console.WriteLine("  Keywords: {0}", keyWords.ToString());
            returnValue.AppendFormat("  Keywords: {0}", keyWords.ToString()).AppendLine();
        }
        Console.WriteLine("");

        return returnValue.ToString();
    }

    private void btnBrowseDest_Click(object sender, EventArgs e)
    {
        folderBrowserDialog1.SelectedPath = txtDestDir.Text;
        DialogResult result = folderBrowserDialog1.ShowDialog();
        if (result == DialogResult.OK)
        {
            txtDestDir.Text = folderBrowserDialog1.SelectedPath;
        }
    }

    private void btnPrepareAll_Click(object sender, EventArgs e)
    {
        SaveAll();
    }

    private void Form1_FormClosing(object sender, FormClosingEventArgs e)
    {
        PutSetting("Form1/sourceDir", txtSourceDir.Text);
        PutSetting("Form1/destDir", txtDestDir.Text);
    } 

    public int GetSetting(string xPath, int defaultValue)
    { return Convert.ToInt16(GetSetting(xPath, Convert.ToString(defaultValue))); }

    public void PutSetting(string xPath, int value)
    { PutSetting(xPath, Convert.ToString(value)); }

    public string GetSetting(string xPath, string defaultValue)
    {
        XmlNode xmlNode = xmlDocument.SelectSingleNode("settings/" + xPath);
        if (xmlNode != null) { return xmlNode.InnerText; }
        else { return defaultValue; }
    }

    public void PutSetting(string xPath, string value)
    {
        XmlNode xmlNode = xmlDocument.SelectSingleNode("settings/" + xPath);
        if (xmlNode == null) { xmlNode = createMissingNode("settings/" + xPath); }
        xmlNode.InnerText = value;
        xmlDocument.Save(documentPath);
    }

    private XmlNode createMissingNode(string xPath)
    {
        string[] xPathSections = xPath.Split('/');
        string currentXPath = "";
        XmlNode testNode = null;
        XmlNode currentNode = xmlDocument.SelectSingleNode("settings");
        foreach (string xPathSection in xPathSections)
        {
            currentXPath += xPathSection;
            testNode = xmlDocument.SelectSingleNode(currentXPath);
            if (testNode == null)
            {
                currentNode.InnerXml += "<" +
                            xPathSection + "></" +
                            xPathSection + ">";
            }
            currentNode = xmlDocument.SelectSingleNode(currentXPath);
            currentXPath += "/";
        }
        return currentNode;
    }
} 

partial class Form1
{
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
        if (disposing && (components != null))
        {
            components.Dispose();
        }
        base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
        this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
        this.richTextBox1 = new System.Windows.Forms.RichTextBox();
        this.btnBrowseSource = new System.Windows.Forms.Button();
        this.txtSourceDir = new System.Windows.Forms.TextBox();
        this.listBoxImages = new System.Windows.Forms.ListBox();
        this.btnPrepareSelected = new System.Windows.Forms.Button();
        this.groupBoxFormat = new System.Windows.Forms.GroupBox();
        this.radioPNG = new System.Windows.Forms.RadioButton();
        this.radioJPEG = new System.Windows.Forms.RadioButton();
        this.radioGIF = new System.Windows.Forms.RadioButton();
        this.groupBoxSize = new System.Windows.Forms.GroupBox();
        this.radioLarge = new System.Windows.Forms.RadioButton();
        this.radioMedium = new System.Windows.Forms.RadioButton();
        this.radioSmall = new System.Windows.Forms.RadioButton();
        this.radioThumb = new System.Windows.Forms.RadioButton();
        this.groupBoxAffect = new System.Windows.Forms.GroupBox();
        this.radioNoAffect = new System.Windows.Forms.RadioButton();
        this.pictureBox1 = new System.Windows.Forms.PictureBox();
        this.lbl_Source = new System.Windows.Forms.Label();
        this.lbl_Destination = new System.Windows.Forms.Label();
        this.txtDestDir = new System.Windows.Forms.TextBox();
        this.btnBrowseDest = new System.Windows.Forms.Button();
        this.btnPrepareAll = new System.Windows.Forms.Button();
        this.groupBoxFormat.SuspendLayout();
        this.groupBoxSize.SuspendLayout();
        this.groupBoxAffect.SuspendLayout();
        ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
        this.SuspendLayout();
        // 
        // richTextBox1
        // 
        this.richTextBox1.Location = new System.Drawing.Point(529, 59);
        this.richTextBox1.Name = "richTextBox1";
        this.richTextBox1.Size = new System.Drawing.Size(244, 325);
        this.richTextBox1.TabIndex = 8;
        this.richTextBox1.Text = "";
        // 
        // btnBrowseSource
        // 
        this.btnBrowseSource.Location = new System.Drawing.Point(698, 4);
        this.btnBrowseSource.Name = "btnBrowseSource";
        this.btnBrowseSource.Size = new System.Drawing.Size(75, 23);
        this.btnBrowseSource.TabIndex = 7;
        this.btnBrowseSource.Text = "Browse";
        this.btnBrowseSource.UseVisualStyleBackColor = true;
        this.btnBrowseSource.Click += new System.EventHandler(this.btnBrowse_Click);
        // 
        // txtSourceDir
        // 
        this.txtSourceDir.Location = new System.Drawing.Point(124, 6);
        this.txtSourceDir.Name = "txtSourceDir";
        this.txtSourceDir.Size = new System.Drawing.Size(568, 20);
        this.txtSourceDir.TabIndex = 6;
        // 
        // listBoxImages
        // 
        this.listBoxImages.FormattingEnabled = true;
        this.listBoxImages.Location = new System.Drawing.Point(124, 390);
        this.listBoxImages.Name = "listBoxImages";
        this.listBoxImages.Size = new System.Drawing.Size(649, 121);
        this.listBoxImages.TabIndex = 5;
        this.listBoxImages.SelectedIndexChanged += new System.EventHandler(this.listBoxImages_SelectedIndexChanged);
        // 
        // btnPrepareSelected
        // 
        this.btnPrepareSelected.Location = new System.Drawing.Point(11, 385);
        this.btnPrepareSelected.Name = "btnPrepareSelected";
        this.btnPrepareSelected.Size = new System.Drawing.Size(102, 60);
        this.btnPrepareSelected.TabIndex = 4;
        this.btnPrepareSelected.Text = "Prepare Selected Image";
        this.btnPrepareSelected.UseVisualStyleBackColor = true;
        this.btnPrepareSelected.Click += new System.EventHandler(this.btnSaveImage_Click);
        // 
        // groupBoxAffect
        // 
        this.groupBoxFormat.Controls.Add(this.radioNoAffect);
        this.groupBoxAffect.Location = new System.Drawing.Point(11, 183);
        this.groupBoxAffect.Name = "groupBoxAffect";
        this.groupBoxAffect.Size = new System.Drawing.Size(102, 100);
        this.groupBoxAffect.TabIndex = 4;
        this.groupBoxAffect.TabStop = false;
        this.groupBoxAffect.Text = "Image Affect:";
        // 
        // radioNoAffect
        // 
        this.radioNoAffect.AutoSize = true;
        this.radioNoAffect.Checked = true;
        this.radioNoAffect.Location = new System.Drawing.Point(7, -20);
        this.radioNoAffect.Name = "radioNoAffect";
        this.radioNoAffect.Size = new System.Drawing.Size(48, 17);
        this.radioNoAffect.TabIndex = 0;
        this.radioNoAffect.Text = "No Affect";
        this.radioNoAffect.UseVisualStyleBackColor = true;
        // 
        // groupBoxFormat
        // 
        this.groupBoxFormat.Controls.Add(this.radioPNG);
        this.groupBoxFormat.Controls.Add(this.radioJPEG);
        this.groupBoxFormat.Controls.Add(this.radioGIF);
        this.groupBoxFormat.Location = new System.Drawing.Point(11, 285);
        this.groupBoxFormat.Name = "groupBoxFormat";
        this.groupBoxFormat.Size = new System.Drawing.Size(102, 90);
        this.groupBoxFormat.TabIndex = 3;
        this.groupBoxFormat.TabStop = false;
        this.groupBoxFormat.Text = "Save image as:";
        // 
        // radioPNG
        // 
        this.radioPNG.AutoSize = true;
        this.radioPNG.Location = new System.Drawing.Point(7, 68);
        this.radioPNG.Name = "radioPNG";
        this.radioPNG.Size = new System.Drawing.Size(48, 17);
        this.radioPNG.TabIndex = 2;
        this.radioPNG.Text = "PNG";
        this.radioPNG.UseVisualStyleBackColor = true;
        // 
        // radioJPEG
        // 
        this.radioJPEG.AutoSize = true;
        this.radioJPEG.Checked = true;
        this.radioJPEG.Location = new System.Drawing.Point(7, 44);
        this.radioJPEG.Name = "radioJPEG";
        this.radioJPEG.Size = new System.Drawing.Size(52, 17);
        this.radioJPEG.TabIndex = 1;
        this.radioJPEG.TabStop = true;
        this.radioJPEG.Text = "JPEG";
        this.radioJPEG.UseVisualStyleBackColor = true;
        // 
        // radioGIF
        // 
        this.radioGIF.AutoSize = true;
        this.radioGIF.Location = new System.Drawing.Point(7, 20);
        this.radioGIF.Name = "radioGIF";
        this.radioGIF.Size = new System.Drawing.Size(42, 17);
        this.radioGIF.TabIndex = 0;
        this.radioGIF.Text = "GIF";
        this.radioGIF.UseVisualStyleBackColor = true;
        // 
        // groupBoxSize
        // 
        this.groupBoxSize.Controls.Add(this.radioLarge);
        this.groupBoxSize.Controls.Add(this.radioMedium);
        this.groupBoxSize.Controls.Add(this.radioSmall);
        this.groupBoxSize.Controls.Add(this.radioThumb);
        this.groupBoxSize.Location = new System.Drawing.Point(11, 59);
        this.groupBoxSize.Name = "groupBoxSize";
        this.groupBoxSize.Size = new System.Drawing.Size(102, 120);
        this.groupBoxSize.TabIndex = 2;
        this.groupBoxSize.TabStop = false;
        this.groupBoxSize.Text = "Resize image:";
        // 
        // radioLarge
        // 
        this.radioLarge.AutoSize = true;
        this.radioLarge.Location = new System.Drawing.Point(6, 87);
        this.radioLarge.Name = "radioLarge";
        this.radioLarge.Size = new System.Drawing.Size(52, 17);
        this.radioLarge.TabIndex = 3;
        this.radioLarge.Text = "Large (1000px)";
        this.radioLarge.UseVisualStyleBackColor = true;
        // 
        // radioMedium
        // 
        this.radioMedium.AutoSize = true;
        this.radioMedium.Checked = true;
        this.radioMedium.Location = new System.Drawing.Point(6, 65);
        this.radioMedium.Name = "radioMedium";
        this.radioMedium.Size = new System.Drawing.Size(62, 17);
        this.radioMedium.TabIndex = 2;
        this.radioMedium.TabStop = true;
        this.radioMedium.Text = "Med (600px)";
        this.radioMedium.UseVisualStyleBackColor = true;
        // 
        // radioSmall
        // 
        this.radioSmall.AutoSize = true;
        this.radioSmall.Location = new System.Drawing.Point(6, 42);
        this.radioSmall.Name = "radioSmall";
        this.radioSmall.Size = new System.Drawing.Size(50, 17);
        this.radioSmall.TabIndex = 1;
        this.radioSmall.Text = "Small (200px)";
        this.radioSmall.UseVisualStyleBackColor = true;
        // 
        // radioThumb
        // 
        this.radioThumb.AutoSize = true;
        this.radioThumb.Location = new System.Drawing.Point(6, 19);
        this.radioThumb.Name = "radioThumb";
        this.radioThumb.Size = new System.Drawing.Size(50, 17);
        this.radioThumb.TabIndex = 0;
        this.radioThumb.Text = "Thumb (96px)";
        this.radioThumb.UseVisualStyleBackColor = true;
        // 
        // pictureBox1
        // 
        this.pictureBox1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
        this.pictureBox1.Location = new System.Drawing.Point(124, 59);
        this.pictureBox1.Name = "pictureBox1";
        this.pictureBox1.Size = new System.Drawing.Size(399, 325);
        this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
        this.pictureBox1.TabIndex = 1;
        this.pictureBox1.TabStop = false;
        // 
        // lbl_Source
        // 
        this.lbl_Source.AutoSize = true;
        this.lbl_Source.Location = new System.Drawing.Point(8, 9);
        this.lbl_Source.Name = "lbl_Source";
        this.lbl_Source.Size = new System.Drawing.Size(86, 13);
        this.lbl_Source.TabIndex = 9;
        this.lbl_Source.Text = "Source Directory";
        // 
        // lbl_Destination
        // 
        this.lbl_Destination.AutoSize = true;
        this.lbl_Destination.Location = new System.Drawing.Point(8, 35);
        this.lbl_Destination.Name = "lbl_Destination";
        this.lbl_Destination.Size = new System.Drawing.Size(105, 13);
        this.lbl_Destination.TabIndex = 10;
        this.lbl_Destination.Text = "Destination Directory";
        // 
        // txtDestDir
        // 
        this.txtDestDir.Location = new System.Drawing.Point(124, 32);
        this.txtDestDir.Name = "txtDestDir";
        this.txtDestDir.Size = new System.Drawing.Size(568, 20);
        this.txtDestDir.TabIndex = 11;
        // 
        // btnBrowseDest
        // 
        this.btnBrowseDest.Location = new System.Drawing.Point(698, 30);
        this.btnBrowseDest.Name = "btnBrowseDest";
        this.btnBrowseDest.Size = new System.Drawing.Size(75, 23);
        this.btnBrowseDest.TabIndex = 12;
        this.btnBrowseDest.Text = "Browse";
        this.btnBrowseDest.UseVisualStyleBackColor = true;
        this.btnBrowseDest.Click += new System.EventHandler(this.btnBrowseDest_Click);
        // 
        // btnPrepareAll
        // 
        this.btnPrepareAll.Location = new System.Drawing.Point(11, 455);
        this.btnPrepareAll.Name = "btnPrepareAll";
        this.btnPrepareAll.Size = new System.Drawing.Size(102, 60);
        this.btnPrepareAll.TabIndex = 13;
        this.btnPrepareAll.Text = "Prepare All Images";
        this.btnPrepareAll.UseVisualStyleBackColor = true;
        this.btnPrepareAll.Click += new System.EventHandler(this.btnPrepareAll_Click);
        // 
        // Form1
        // 
        this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
        this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
        this.ClientSize = new System.Drawing.Size(791, 536);
        this.Controls.Add(this.btnPrepareAll);
        this.Controls.Add(this.btnBrowseDest);
        this.Controls.Add(this.txtDestDir);
        this.Controls.Add(this.lbl_Destination);
        this.Controls.Add(this.lbl_Source);
        this.Controls.Add(this.richTextBox1);
        this.Controls.Add(this.btnBrowseSource);
        this.Controls.Add(this.txtSourceDir);
        this.Controls.Add(this.pictureBox1);
        this.Controls.Add(this.listBoxImages);
        this.Controls.Add(this.groupBoxSize);
        this.Controls.Add(this.groupBoxFormat);
        this.Controls.Add(this.groupBoxAffect);
        this.Controls.Add(this.btnPrepareSelected);
        this.Name = "Form1";
        this.Text = "Bulk Image Convertor";
        this.StartPosition = FormStartPosition.CenterScreen;
        this.FormBorderStyle = FormBorderStyle.FixedDialog;
        this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
        this.groupBoxFormat.ResumeLayout(false);
        this.groupBoxFormat.PerformLayout();
        this.groupBoxAffect.ResumeLayout(false);
        this.groupBoxAffect.PerformLayout();
        this.groupBoxSize.ResumeLayout(false);
        this.groupBoxSize.PerformLayout();
        ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
        this.ResumeLayout(false);
        this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
    private System.Windows.Forms.PictureBox pictureBox1;
    private System.Windows.Forms.GroupBox groupBoxSize;
    private System.Windows.Forms.RadioButton radioLarge;
    private System.Windows.Forms.RadioButton radioMedium;
    private System.Windows.Forms.RadioButton radioSmall;
    private System.Windows.Forms.RadioButton radioThumb;
    private System.Windows.Forms.GroupBox groupBoxFormat;
    private System.Windows.Forms.RadioButton radioPNG;
    private System.Windows.Forms.RadioButton radioJPEG;
    private System.Windows.Forms.RadioButton radioGIF;
    private System.Windows.Forms.GroupBox groupBoxAffect;
    private System.Windows.Forms.RadioButton radioNoAffect;
    private System.Windows.Forms.Button btnPrepareSelected;
    private System.Windows.Forms.ListBox listBoxImages;
    private System.Windows.Forms.Button btnBrowseSource;
    private System.Windows.Forms.TextBox txtSourceDir;
    private System.Windows.Forms.RichTextBox richTextBox1;
    private System.Windows.Forms.Label lbl_Source;
    private System.Windows.Forms.Label lbl_Destination;
    private System.Windows.Forms.TextBox txtDestDir;
    private System.Windows.Forms.Button btnBrowseDest;
    private System.Windows.Forms.Button btnPrepareAll;
}
'@

# Function to check the registry for .NET Framework v3.0
Function Test-Framework
{
    $path = "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v3.0\Setup"
    if (-not (Test-Path $path))
    {
        return $false
    }
    
    if ((Get-ItemProperty $path)."InstallSuccess" -eq $null)
    {
        return $false
    }
    
    return $true
}

if (-NOT (Test-Framework))
{
    Write-Warning ".NET Framework 3.0 not detected. This may result in errors."
}

# Single Threaded Apartment mode is required for WPF.
# Check to make sure PowerShell is running in STA mode.
If ($host.Runspace.ApartmentState -ne 'STA')
{
    Write-Warning "STA Mode not detected."
    Write-Warning "Please run this script with -STA switch or inside ISE"
    Exit
}

$assemblies = ('System.Windows.Forms','System.Drawing','PresentationCore','WindowsBase','System.Xml','System.Xaml')

try
{
    Add-Type -TypeDefinition $sourceCode -ReferencedAssemblies $assemblies -ErrorAction STOP
    
    (New-Object Form1).Showdialog() | Out-Null
}
catch
{
    Write-Warning "An error occurred attempting to add the .NET Framework class to the PowerShell session."
    Write-Warning "The error was: $($Error[0].Exception.Message)"
}