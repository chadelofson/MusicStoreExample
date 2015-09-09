<%@ Page Language="C#" MasterPageFile="MasterPage.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    string lastOrder = String.Empty;
    
    void Page_Load(object sender, EventArgs e)
    {
        //FillDataList();
        Int64 CustID = Convert.ToInt64(Request.QueryString["CustID"]);
        Int64 TempID = CustID / 200 - 800;
        int CID = Convert.ToInt32(TempID);

        //if (CID > 0)
        //{
        String sql = "SELECT o.OrderID,OrderDate,ASIN,Title,Qty,Artist " +
                         "FROM tblOrders as o,tblOrderItems as oi " +
                         "WHERE o.OrderID=oi.OrderID AND CustID=" + CID.ToString() + " " +
                         "GROUP BY o.OrderID, o.OrderDate, oi.ASIN, oi.Title, oi.Qty, oi.Artist " +
                         "ORDER BY OrderID DESC";
        
        //Utilities myUtilities = new Utilities();
        DataAccess myDA = new DataAccess("MusicStore3");
        DataTable dtOrderInfo = myDA.FillDataTable(sql);
        int count = dtOrderInfo.Rows.Count;
        lblMessage.Text = "You have ordered " + count.ToString() + " CD's";
        dlOrder.DataSource = dtOrderInfo;
        dlOrder.DataBind();
        
        //DataList dl = (DataList)e.It  Item.FindControl("panelsubcat");
    }

    string DisplayOrder(string orderID, string orderDate) {
        // Determine if the OrderID is the same
        string output = String.Empty;
        //Label lbl = (Label)dlOrder.FindControl("lblOrderInfo");
        if (orderID != lastOrder)
        {
            // Set that the lastOrder is the current Order
            lastOrder = orderID;
            // Display the OrderID
            output = "<hr />OrderID: <b>" + orderID + "</b><br />" + orderDate + "<br /><hr />";
            //lbl.Style["visibility"] = "show";
        }
        //lbl.Style["visibility"] = "hidden";
        return output;
    }

    bool DisplayLabel(string orderID) {
        if (orderID != lastOrder)
        {
            return true;
        }
        return false;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>JAS MUSIC - Search Page</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <center>
      
        <h3>Order History</h3>
        <hr />
        <asp:Label ID="lblMessage" runat="server" />
        <asp:DataList ID="dlOrder" runat="server" CellSpacing="10"  DataKeyField="OrderID" ItemStyle-HorizontalAlign="Left">
<ItemStyle HorizontalAlign="Left"></ItemStyle>
            <ItemTemplate>
            
                <asp:Label ID="lblOrderInfo" BorderColor="Blue" Visible='<%# DisplayLabel((Eval("OrderID")).ToString()) %>'  runat="server" 
                    Text='<%# DisplayOrder((Eval("OrderID")).ToString(),(Eval("OrderDate")).ToString()) %>' 
                    BackColor="#214376" ForeColor="White" Width="100%"   />
                
                        <asp:HyperLink ID="imgMed" ImageUrl='<%# "http://images.amazon.com/images/P" + Eval("ASIN") + ".01._SCTHUMBZZZ_V1115763748_.jpg" %>'
                                 NavigateUrl='<%# "ProductPage.aspx?ASIN=" + Eval("ASIN") %>'
                                    CssClass="ProductImageSmall" runat="server" />
                            
                        <div class="ProductTitle">
                        <asp:Label ID="lblTitle" runat="server" Text='<%# Eval("Title") %>' />
                        </div>
                        by <span class="ProductArtist">
                        <asp:Label ID="lblArtist" runat="server" Text='<%# Eval("Artist") %>' />
                        </span>             
                        <div> Qty:
                            <%# Eval("Qty").ToString() %>
                    </div>
            </ItemTemplate>
            
        </asp:DataList>
       
    </center>
</asp:Content>

