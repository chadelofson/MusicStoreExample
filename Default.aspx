<%@ Page Language="C#" MasterPageFile="MasterPage.master" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
    Utilities myUtil = new Utilities();
    void Page_Load()
    {
        if (!Page.IsPostBack) FillDataList();
    }


    void FillDataList()
    {
        String sql = "SELECT top 4 strASIN, strTitle, strArtist, dblPrice as ListPrice, strReview as EditorialReviews " +
                        "FROM tblDescription ORDER BY NewID() ";
        Utilities myUtilities = new Utilities();
        DataAccess myDA = new DataAccess("MusicStore3");
        DataTable dtProdInfo = myDA.FillDataTable(sql);

        //tidy up editorial reviews
        foreach (DataRow dr in dtProdInfo.Rows)
        {
            dr["EditorialReviews"] = myUtilities.Truncate(dr["EditorialReviews"].ToString(), 300);
            dr["EditorialReviews"] = myUtilities.stripHTML(dr["EditorialReviews"].ToString());
        }

        dlProduct.DataSource = dtProdInfo;
        dlProduct.DataBind();
    }

    /**/
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
<title>JAS E-Music Store - Home Page</title>
</asp:Content>
 

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="font-size: smaller; margin: 3px 0 4px 0">
      <asp:Label ID="lblResultPages" runat="server" />
   </div>
   <asp:DataList ID="dlProduct" runat="server" CellSpacing="10" ItemStyle-HorizontalAlign="Left"
      OnItemCommand="dlProduct_command" DataKeyField="strASIN">
      <ItemTemplate>
         <asp:Label ID="lblTitle" Text='<%#Eval("strTitle")%>' runat="server" CssClass="ProductTitle" />
         <br />
         by <b>
            <asp:Label ID="lblArtist" Text='<%#Eval("strArtist")%>' runat="server" CssClass="ProductArtist" /></b>
         <br />
         <asp:HiddenField ID="hfListPrice" Value='<%# Eval("ListPrice")%>' runat="server" />
         <asp:HyperLink ID="imgSmall" AlternateText='<%# Eval("strTitle") %>' ImageUrl='<%# "http://images.amazon.com/images/P" + Eval("strASIN") + ".01._SCTHUMBZZZ_V1115763748_.jpg" %>'
            NavigateUrl='<%# "ProductPage.aspx?ASIN=" + Eval("strASIN") %>' CssClass="ProductImageSmall"
            runat="server" />
         <asp:ImageButton ID="addtocart" runat="server" CommandName="ItemCommand" ImageAlign="right"
            ImageUrl="images/add-to-cart-small.gif" />
         <span class="ProductDescription">
            <%# Eval("EditorialReviews") %>
            <a href="ProductPage.aspx?ASIN=<%# Eval("strASIN") %>">read more... </a></span>
      </ItemTemplate>
   </asp:DataList>
   <asp:Label ID="lblMessage" runat="server" />

</asp:Content>   
