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

        string strSearch = Request.QueryString.Get("Search");
        string strSelect = Request.QueryString.Get("style");

        //Wrap execute web service for exception handling.
        try
        {
           //AmazonSearch("keywords" or "BrowseNode", keyword or node, page, sort, catalog)
           //Sort options: http://docs.amazonwebservices.com/AWSECommerceService/latest/DG/USSortValuesArticle.html#USSortValuesArticle_music
           if (strSearch != null) {
               dsResults = myAWS.AmazonSearch("keywords", strSearch, "1", "relevancerank", "Music");
                lblMessage.Text = myAWS.TotalResults + " items available on ";
                lblMessage.Text += myAWS.TotalPages + " pages";
           } else {
              dsResults = myAWS.AmazonSearch("BrowseNode", strSelect, "1", "relevancerank", "Music");
                lblMessage.Text = myAWS.TotalResults + " items available on ";
                lblMessage.Text += myAWS.TotalPages + " pages";  
           }
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
        }
        */
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
        double dblTarget = Convert.ToDouble(strTarget)/100;
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
            double dblPrice = Convert.ToDouble(hfListPrice.Value)/100;

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
        <h3>
            Amazon Web Service Example</h3>
        <hr />
        <asp:Label ID="lblMessage" runat="server" />
        <asp:DataList ID="dlProduct" runat="server" CellSpacing="10" ItemStyle-HorizontalAlign="Left"
      OnItemCommand="dlProduct_command" DataKeyField="ASIN">
           
            <ItemTemplate>

                <asp:HyperLink ID="imgMed" ImageUrl='<%# "http://images.amazon.com/images/P" + Eval("ASIN") + ".01._SCTHUMBZZZ_V1115763748_.jpg" %>'
                         NavigateUrl='<%# "ProductPage.aspx?ASIN=" + Eval("ASIN") %>'
                            CssClass="ProductImageSmall" runat="server" />
                            
                <div class="ProductTitle">
                <asp:Label ID="lblTitle" runat="server" Text='<%# Eval("Title") %>' />
                </div>
                by <span class="ProductArtist">
                <asp:Label ID="lblArtist" runat="server" Text='<%# Eval("Artist") %>' />
                </span>             
                <div> List Price:
            <span class="PriceColor"><%# myUtil.FormatCurrency(Eval("ListPrice").ToString(), 1.0) %></span>
            <asp:ImageButton ID="addtocart" runat="server" CommandName="ItemCommand" ImageAlign="right"
            ImageUrl="images/add-to-cart-small.gif" />
            <asp:HiddenField ID="hfListPrice" runat="server" Value='<%# Eval("ListPrice") %>' />
            </div>
                
                <p class="ProductDescription">
                    <%# Truncate(stripHTML(Eval("EditorialReviews").ToString()),300) %>
                    <a href="ProductPage.aspx?ASIN=<%# Eval("ASIN") %>">read more...</a> </p>
            </ItemTemplate>
        </asp:DataList>
       
    </center>
</asp:Content>

