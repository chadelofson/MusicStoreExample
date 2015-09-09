<%@ Page Language="C#" MasterPageFile="masterpage.master" Title="Shopping Cart - JAS Music" %>
<%@ Register TagPrefix="MyUserControl" TagName="ColumnHeading" Src="includes/ColumnHeading.ascx" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
   ShoppingCart myCart;
   Utilities myUtil = new Utilities();
   void Page_Load()
   {
      Session["someStuff"] = "Go Vikings";
      myCart = new ShoppingCart();
      if (!Page.IsPostBack)
      {
         DisplayCart();
      }
   }

   void DisplayCart()
   {
      
      DataTable dt = new DataTable();
      dt = myCart.ListItemsInCart();
      CenterHeading.Text = myCart.ItemCount + " item(s)";
      CenterHeading.Text += " in your cart.";
      int count = 0;
      double price = 0.0;
      double shippingcost = 0.0;
      if (dt.Rows.Count > 0)
      {
          foreach (DataRow dr in dt.Rows)
          {
              count += Convert.ToInt32(dr["Qty"]);
              price += Convert.ToDouble(dr["Qty"])*Convert.ToDouble(dr["Price"]);
              
          }
          shippingcost = 3.99 + count * 0.99;
      }
      double totalcost = shippingcost + price;
       
      lblSubPrice.Text = String.Format("{0:c}", myCart.PriceTotal);
      lblShippingPrice.Text = String.Format("{0:c}", shippingcost);
      lblTotalPrice.Text = String.Format("{0:c}", totalcost);
       
       
      Trace.Write("DisplayCart: binding dt to DataList.<br />");
      if (dt.Rows.Count != 0) { 
          dlCart.DataSource = dt;
          dlCart.DataBind();
      }
   }

   protected void AddRemove_click(object source, DataListCommandEventArgs e)
   {
      //Handles "Add to Cart" click event from datalist.
      //Retrieve ASIN from datalist DataKeys collection.
      String ASIN = dlCart.DataKeys[e.Item.ItemIndex].ToString();
      String command = e.CommandArgument.ToString();

      ShoppingCart myCart = new ShoppingCart();
      if (command == "remove")
      {
         myCart.UpdateQty(ASIN, -1);
      }
      else
      {
         myCart.UpdateQty(ASIN, 1);
      }

      Trace.Write("Shopping Cart", ASIN + " " + command);
      DisplayCart();
   }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<title>JAS E-Music Store - Shopping Cart</title>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<center>
   <MyUserControl:ColumnHeading ID="CenterHeading" Text="Shopping Cart" runat="server" />
   </center>
   <!--Center column -->
   <asp:Label ID="lblMessage" runat="server" />
   <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
            <tr>
                <th >&nbsp;</th>
                <th >
                Item
                </th>
                <th>
                  Qty
                </th>
                <th>
                  Price
                </th>
                <th>
                  Total
                </th>
                <th>
                    Add/Remove
                </th>
            </tr>
            </table>
            <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
   <asp:DataList ID="dlCart"  runat="server" OnItemCommand="AddRemove_click"
      DataKeyField="ASIN">
      <ItemTemplate>
      <tr>
            <td >
                <asp:Image ID="imgCD" ImageUrl='<%# "http://images.amazon.com/images/P/" + Eval("ASIN") + ".01.TZZZZZZZ.jpg" %>' runat="server" />
            </td>
            <td >
                <asp:Label ID="lblTitle" Text='<%#Eval("Title")%>' runat="server" CssClass="ProductTitle" /><br />
                <asp:Label ID="lblArtist" Text='<%#Eval("Artist")%>' runat="server" CssClass="ProductTitle" />
            </td>
            <td align="center">
                <span class="ProductPrice">
                   <%#Eval("Qty")%>
                </span>
            </td>
            <td>
               <span class="PriceColor">
                   <%# Convert.ToDouble(Eval("price")).ToString("C") %>
                </span>
            </td>
            <td>
                <span class="PriceColor">
                   <%# (Convert.ToDouble(Eval("price")) * Convert.ToDouble(Eval("Qty").ToString())).ToString("C") %>
                </span>
            </td>
            <td align="center">
                <span class="PriceColor">
                    <asp:LinkButton ID="btnAdd" Text="Add" runat="server" CommandArgument="add" /><br />
                    <asp:LinkButton ID="btnRemove" Text="Remove" runat="server" CommandArgument="remove" /><br />
                </span>
            </td>
        </tr> 
      </ItemTemplate>
   </asp:DataList>
   </table>
   <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">    
   <tr>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
                <td >
                    <asp:Label ID="lblSubtotal" Text="Subtotal:" runat="server" />
                </td>
                <td >
                    <span class="PriceColor"><asp:Label ID="lblSubPrice" runat="server" /></span>       
                </td>
                <td >
                    &nbsp;
                </td>
    </tr>
            <tr>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
                <td >
                    <asp:Label ID="lblShipping" Text="Shipping*:" runat="server" />
                </td>
                <td >
                    <span class="PriceColor"><asp:Label ID="lblShippingPrice" runat="server" /></span>
                </td>
                <td >
                    &nbsp;
                    
                </td>
            </tr>
            <tr>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
                <td >
                    <asp:Label ID="lblTotal" Text="Total:" runat="server" />
                </td>
                <td>
                    <span class="PriceColor"><asp:Label ID="lblTotalPrice" runat="server" /></span>
                </td>
                <td>
                    
                </td>
            </tr>
         </table>
   <table>
        <tr>
                <td >
                    <asp:HyperLink ID="ShopLink" runat="server" ImageUrl="images/continue-shopping.gif" NavigateUrl="Default.aspx" />
                </td>
                <td >
                <p align="right">
                    <asp:HyperLink ID="Checkout" runat="server" ImageUrl="images/proceed-to-Checkout.gif" NavigateUrl="SignIn.aspx" /></p>
                </td>
        </tr>
    </table>
    <p align="center">
            <font face="arial" size="-1">Shipping charges are $3.99 for the first item and $.99
                for each additional item.<br />
                Shipping is via UPS second day air.<br />
                Cart has a limit of 5 for each item. </font>
        </p>

</asp:Content>
