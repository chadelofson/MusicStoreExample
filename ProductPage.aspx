<%@ Page Language="C#" MasterPageFile="MasterPage.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    Utilities myUtil = new Utilities();
    
    void Page_Load()
    {
        if (!Page.IsPostBack)
        {
            ExecuteAmazonWebService();
        }
    }

    void ExecuteAmazonWebService()
    {
        DataSet dsResults = new DataSet();
        AmazonWebService myAWS = new AmazonWebService();

        string strASIN = Request.QueryString.Get("ASIN");
        

        //Wrap execute web service for exception handling.
        try
        {
           //AmazonSearch("keywords" or "BrowseNode", keyword or node, page, sort, catalog)
           //Sort options: http://docs.amazonwebservices.com/AWSECommerceService/latest/DG/USSortValuesArticle.html#USSortValuesArticle_music

            dsResults = myAWS.AmazonSearch("keywords", strASIN, "1", "relevancerank", "Music");
           //} else {
           /*   dsResults = myAWS.AmazonSearch("BrowseNode", strASIN.Trim(), "1", "relevancerank", "Music");
                lblMessage.Text = myAWS.TotalResults + " items available on ";
                lblMessage.Text += myAWS.TotalPages + " pages";  */
           //}
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.Message;
            
        }
        
        //Retrieve DataTable of Product Info from DataSet
        DataTable ProductInfo = dsResults.Tables[0];
        dlProduct.DataSource = ProductInfo;
        dlProduct.DataBind();    
           
        //List the columns returned in datatable
        /*foreach (DataColumn dc in ProductInfo.Columns)
        {
            lblColumns.Text += "<li>" + dc.ColumnName + "</li>";
        }*/

    }

    //These methods are used on several pages. They should be
    //placed into a "Utilities" class for reusability.
    String Truncate(String strTarget, Int16 MaxLength)
    {      
        //Truncate strings to MaxLength
        if (strTarget.Length < MaxLength) return strTarget;
        strTarget = strTarget.Substring(0, MaxLength);
        //truncate on word break
        return strTarget.Substring(0, strTarget.LastIndexOf(" "));
    }

    string stripHTML(string strTarget)
    { 
        //strip html from descriptions.
        return Regex.Replace(strTarget, "<.+?>", "");   
    }
    
        string FormatCurrency(string strTarget, double Percent)
    {
        //Response.Write("strTarget: " + strTarget);
        //return strTarget;
        double dblTarget = Convert.ToDouble(strTarget);
        dblTarget = Percent * dblTarget;
        return String.Format("{0:c}", dblTarget);
    
    }

        void dlProduct_command(Object sender, DataListCommandEventArgs e)
        {
            //Handles "Add to Cart" click event from datalist.
            //Retrieve ASIN from datalist DataKeys collection.
            String ASIN = dlProduct.DataKeys[e.Item.ItemIndex].ToString();

            //Retrive product attributes from labels in the datarow.
            Label lblTitle = (Label)e.Item.FindControl("lblTitle");
            Label lblArtist = (Label)e.Item.FindControl("lblArtist");
            HiddenField hfListPrice = (HiddenField)e.Item.FindControl("hfListPrice");
            double dblPrice = Convert.ToDouble(hfListPrice.Value);

            ShoppingCart myCart = new ShoppingCart();
            myCart.AddToCart(ASIN, lblTitle.Text, lblArtist.Text, dblPrice);

            Response.Redirect("ShoppingCart.aspx");
        }
    
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>JAS MUSIC - Search Page</title>
    

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <center>
        
        <asp:Label ID="lblMessage" runat="server" />
        <asp:DataList ID="dlProduct" runat="server" CellSpacing="10" ItemStyle-HorizontalAlign="Left"
      OnItemCommand="dlProduct_command" DataKeyField="ASIN">
            <ItemTemplate>
                <div class="musictitle">
                    <font face="Comic Sans MS" color="#ffffff">
                    <%# Eval("Artist") %>
                    </font>

                </div>
                <br />
                
                <span id="ctl00_ContentHolder_dlProduct_ctl00_lblTitle" class="ProductTitle">
                    <asp:Label ID="lblTitle" runat="server" Text=' <%# Eval("Title") %>' />
                </span><br />
                by <span id="ctl00_ContentHolder_dlProduct_ctl00_lblArtist" class="ProductArtist">
                    <asp:Label ID="lblArtist" runat="server" Text='<%# Eval("Artist") %>' />
                </span><br />
                <div>
                    <asp:HyperLink ID="imgMed" rel="lightbox" ImageUrl='<%# "http://images.amazon.com/images/P/" + Eval("ASIN") + ".01.MZZZZZZZ.jpg" %>'
                             NavigateUrl='<%# "http://images.amazon.com/images/P/" + Eval("ASIN") + ".01.LZZZZZZZ.jpg" %>'
                                CssClass="ProductImageSmall" runat="server" />
                    
                    <b>List Price: </b>
                    <span class="PriceColor"><%# myUtil.FormatCurrency(Eval("ListPrice").ToString(), 1.0) %></span>
                    <br /><br />
                    <b>ASIN: </b>
                    <%# Eval("ASIN").ToString().Trim() %><br />
                    <b>Release Date: </b>
                    <%# Eval("ReleaseDate").ToString().Trim()%><br />
                    <b>Number of Discs: </b>
                    <%# Eval("NumberOfDiscs").ToString() %><br />
                    <b>Music Label: </b>
                    <%# Eval("Label") %>
                    <br />
                    <asp:ImageButton ID="addtocart" runat="server" CommandName="ItemCommand" ImageAlign="right" ImageUrl="images/add-to-cart-small.gif" />
                    <asp:HiddenField ID="hfListPrice" runat="server" Value='<%# Eval("ListPrice") %>' />
                </div>
                <div>
                    <br /><br />
                    <span class="SectionHeading">Editorial Reviews:</span><br /><br />
                    <span class="ProductDescription">
                        <%# stripHTML(Eval("EditorialReviews").ToString()) %>
                    </span>
                    <br /><br />    
                </div>
                <div>
                <span class="SectionHeading">TRACKS:</span><br />
                <hr />

                    <%# Eval("NumberOfTracks") %>
                <hr />
                </div>
            </ItemTemplate>
        </asp:DataList>
        
        
    </center>
</asp:Content>

