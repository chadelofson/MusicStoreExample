<%@ Page Title="JAS Music - CheckOut" Language="C#" MasterPageFile="MasterPage.master" %>
<%@ Register TagPrefix="MyUserControl" TagName="ColumnHeading" Src="includes/ColumnHeading.ascx" %>

<%@ Import Namespace="System.Data" %>
<script runat="server">
    bool bolAddressChanged = false;
    
    void page_load()
    {
        
        if (Request.Cookies["customer"] == null) Response.Redirect("SignIn.aspx");
        string SessionID = Request.Cookies["customer"].ToString();
        Checkout myCO = new Checkout(SessionID);
        //Hide reorder link until valid order is complete
        ShoppingCart myCart = new ShoppingCart();
        if (!Page.IsPostBack)
        {           
            panOrder.Visible = false;
            CenterHeading.Text = "Please update your email and shipping address";
            string email = Request.Cookies["customer"]["email"].ToString();
            DataTable dtcustomer = myCO.GetCustomerDetails(email);
            DataTable dtCartItems = myCart.ListItemsInCart();
            
            if (dtcustomer.Rows.Count == 0)
            {
                hlHistory.Visible = false;
                tbEmail.Text = email;
                lbNotMe.Text = "Return to SignIn";
            }
            else
            {
                FillTextBoxes(dtcustomer);
                ViewState["CustID"] = dtcustomer.Rows[0]["CustID"];
                int custID = (int)dtcustomer.Rows[0]["CustID"];
                Int64 EncryptedID = myCO.EncryptCustID(custID);
                hlHistory.NavigateUrl = "OrderHistory.aspx?CustID=" + EncryptedID.ToString();
                lbNotMe.Text = "Not " + (string)dtcustomer.Rows[0]["FName"] + " " + (string)dtcustomer.Rows[0]["LName"] + "?";
            }
            if (dtCartItems.Rows.Count == 0)
            {
                btSubmit.Text = "Update my information";
            }
            else
            {
                btSubmit.Text = "Ship Order";
            }

        }  /*else {
            if (ViewState["CustID"] != null)
            {
                int CustID = (int)ViewState["CustID"];
                Int64 ohCustID = myCO.EncryptCustID(CustID);
                hlOrderHistory.NavigateUrl = "OrderHistory.aspx?CustID=" + ohCustID.ToString();
            }
            else {
                int ID = 0;
                hlHistory.NavigateUrl = "OrderHistory.aspx?CustID=" + ID.ToString();
            }
        }*/
        tbFName.Focus();
        Page.Form.DefaultButton = btSubmit.UniqueID;
        Trace.Write("Page Load***", "IsPostBack: " + Page.IsPostBack);
        
        
           
    }

    protected void FillTextBoxes(DataTable CustomerTable) { 
        tbEmail.Text = (string)CustomerTable.Rows[0]["Email"];
        tbFName.Text = (string)CustomerTable.Rows[0]["FName"];
        tbLName.Text = (string)CustomerTable.Rows[0]["LName"];
        tbStreet.Text = (string)CustomerTable.Rows[0]["Street"];
        tbCity.Text = (string)CustomerTable.Rows[0]["City"];
        tbState.Text = (string)CustomerTable.Rows[0]["State"];
        tbZip.Text = (string)CustomerTable.Rows[0]["Zip"];
    }
    
    
    
    protected void ShipOrder_click(object sender, EventArgs e)
    {
        Page.Validate();
        if (!Page.IsValid) return;
        string SessionID = Request.Cookies["customer"].ToString();
        Checkout myCO = new Checkout(SessionID);
        ShoppingCart myCart = new ShoppingCart();
        int CID = 0;
        if (ViewState["CustID"] != null) CID = (int)ViewState["CustID"];
        if (CID != 0) {
            if (bolAddressChanged)
            {
                myCO.UpdateCustAddress(CID, tbEmail.Text, tbFName.Text, tbLName.Text, tbStreet.Text, tbCity.Text, tbState.Text, tbZip.Text);
            }
        } else {
            CID = myCO.AddNewCustomer(tbEmail.Text, tbFName.Text, tbLName.Text, tbStreet.Text, tbCity.Text, tbState.Text, tbZip.Text);  
        }
        Int64 EncryptedID = myCO.EncryptCustID(CID);
        panCustomer.Visible = false;
        panOrder.Visible = true;
        hlOrderHistory.NavigateUrl = "OrderHistory.aspx?CustID=" + EncryptedID.ToString();
        AccountUpdate.Text="Your information has been updated";
        DataTable dt = myCart.ListItemsInCart();
        if (dt.Rows.Count == 0) return;
        int OrderID=myCO.WriteOrder(dt, CID);
        lblConfirmation.Text = myCO.WriteConfirmationString(OrderID,dt,tbFName.Text,tbLName.Text,tbStreet.Text,tbCity.Text,tbState.Text,tbZip.Text);
        lblEmailStatus.Text = myCO.WriteEmail(lblConfirmation.Text, tbEmail.Text, tbFName.Text, tbLName.Text);
    }

    protected void  AddressChanged(object sender, EventArgs e)
    {
        bolAddressChanged = true;
    }

    protected void lbNotMe_Click(object sender, EventArgs e)
    {

        Response.Cookies["Customer"].Expires = DateTime.Now.AddDays(-1d);
        Response.Cookies.Add(Response.Cookies["Customer"]);
        Response.Redirect("SignIn.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Panel ID="panCustomer" runat="server">
    <center>
        <MyUserControl:ColumnHeading ID="CenterHeading" Text="Shopping Cart" runat="server" />
    </center>
        <table>
                <tr>

                    <td width="100">
                        <asp:Label ID="lblEmail" runat="server"  Text="Email:"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbEmail" Width="250" runat="server" ontextchanged="AddressChanged"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredEmailValidator" runat="server" ErrorMessage="RequiredFieldValidator" Display="Dynamic" ForeColor="Red" ControlToValidate="tbEmail">Required</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionEmail" runat="server" ErrorMessage="RegularExpressionValidator" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="tbEmail">Please enter a valid email address</asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td width="100">
                            <asp:Label ID="lblFName" runat="server"  Text="First Name:"></asp:Label>
                    </td>
                    <td>
                            <asp:TextBox ID="tbFName" Width="125" runat="server" 
                                ontextchanged="AddressChanged"/>
                    </td>
                    <td>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="RequiredFieldValidator" Display="Dynamic" ForeColor="Red" ControlToValidate="tbFName">Required</asp:RequiredFieldValidator>
                            
                    </td>
                </tr>
                <tr>
                        <td width="100">
                            <asp:Label ID="lblLName" runat="server" Text="Last Name:"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="tbLName" Width="125"  runat="server" ontextchanged="AddressChanged" />
                        </td>
                        <td>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="RequiredFieldValidator" Display="Dynamic" ForeColor="Red" ControlToValidate="tbLName">Required</asp:RequiredFieldValidator>
                            
                        </td>
                </tr>
                <tr>
                     <td width="100">
                        <asp:Label ID="lblStreet" runat="server" Text="Street:"></asp:Label>
                     </td>
                     <td>
                        <asp:TextBox ID="tbStreet" Width="250" runat="server" ontextchanged="AddressChanged" />
                     </td>
                     <td>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="RequiredFieldValidator" Display="Dynamic" ForeColor="Red" ControlToValidate="tbStreet">Required</asp:RequiredFieldValidator>
                            
                     </td>
                </tr>
                <tr>
                     <td width="100">
                        <asp:Label ID="lblCity" runat="server" Text="City"></asp:Label>
                     </td>
                     <td>
                        <asp:TextBox ID="tbCity" Width="125" ontextchanged="AddressChanged"  runat="server" />
                     </td>
                     <td>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="RequiredFieldValidator" Display="Dynamic" ForeColor="Red" ControlToValidate="tbCity">Required</asp:RequiredFieldValidator>
                            
                     </td>
                </tr>
                <tr>
                    <td width="100">
                        <asp:Label ID="lblState" runat="server" Text="State:"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbState" Width="30" ontextchanged="AddressChanged"   runat="server" />
                    </td>
                    <td>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="RequiredFieldValidator" Display="Dynamic" ForeColor="Red" ControlToValidate="tbState">Required</asp:RequiredFieldValidator>
                            
                    </td>
               </tr>
               <tr>
                    <td width="100">
                        <asp:Label ID="lblZip" runat="server" Text="Zip:" ></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbZip" Width="50" ontextchanged="AddressChanged" runat="server"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="RequiredFieldValidator" Display="Dynamic" ForeColor="Red" ControlToValidate="tbZip">Required</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator7" runat="server" 
                            ErrorMessage="RegularExpressionValidator" ForeColor="Red" 
                            ControlToValidate="tbZip" ValidationExpression="\d{5}?">Please enter a 5 digit zip code</asp:RegularExpressionValidator>
                    </td>
               </tr>
               <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:Button ID="btSubmit" OnClick="ShipOrder_click" runat="server" />
                    </td>
                    <td>&nbsp;</td>
               </tr>   
        </table>
        <center>
        <asp:LinkButton ID="lbNotMe" runat="server" Text="" onclick="lbNotMe_Click" />
        <br />
        <br />
        <asp:HyperLink ID="hlHistory" Text="Order History"  runat="server" />
        </center>
    </asp:Panel>
    
    <asp:Panel ID="panOrder" runat="server">
    <center>
        <asp:Label ID="AccountUpdate" runat="server" /> 
        <br />
        <asp:Label ID="lblConfirmation" runat="server"></asp:Label>
        <br />
        <asp:Label ID="lblEmailStatus" runat="server"></asp:Label>
        <br />
        <asp:HyperLink ID="ContinueShopping" runat="server" NavigateUrl="Default.aspx" ImageUrl="images/continue-shopping.gif" ToolTip="Continue Shopping" />
        <br />
        <br />
        <asp:HyperLink ID="hlOrderHistory" Text="Order History" runat="server"   />
        </center>
    </asp:Panel>
</asp:Content>

