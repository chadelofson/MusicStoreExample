<%@ Page Title="JAS Music - SignIn" Language="C#" MasterPageFile="~/mis324/Assignments/MusicStore3/MasterPage.master" %>
<%@ Register TagPrefix="recaptcha" Namespace="Recaptcha" Assembly="Recaptcha" %>
<%@ Register TagPrefix="MyUserControl" TagName="ColumnHeading" Src="includes/ColumnHeading.ascx" %>
<script runat="server">
    void page_load() {
        //cookie exists
        if (Request.Cookies["customer"] != null) Response.Redirect("CheckOut.aspx");
        tbEmail.Focus();
        Page.Form.DefaultButton = btSubmit.UniqueID;
    }
    
    protected void onTextChange_click(object sender, EventArgs e)
    {
        Page.Validate();
        if (!Page.IsValid) return;

        Response.Cookies["Customer"]["email"] = tbEmail.Text;
        if (cbKeepSigned.Checked == true)
        {
            Response.Cookies["Customer"].Expires = DateTime.Now.AddDays(14);
        }

        Response.Redirect("CheckOut.aspx");
    }
    //onclick="btSubmit_Click"
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<center>
   <MyUserControl:ColumnHeading ID="CenterHeading" Text="Sign In" runat="server" />
   </center>
        <center>
            <asp:Label ID="lblEmail" runat="server" Text="Please enter your email address"></asp:Label>
            <br />
            <asp:TextBox ID="tbEmail" OnTextChanged="onTextChange_click" runat="server" 
                Width="297px"></asp:TextBox> <br />
            <asp:CheckBox ID="cbKeepSigned" runat="server" Checked="True" Text="Keep me signed in" /> <br /><br />
        
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                ErrorMessage="RequiredFieldValidator" ControlToValidate="tbEmail" 
                Display="Dynamic" ForeColor="Red">Please enter your email address</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                ErrorMessage="RegularExpressionValidator" ControlToValidate="tbEmail" 
                Display="Dynamic" ForeColor="Red" 
                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Please enter a valid email address</asp:RegularExpressionValidator>
            <br />
            <recaptcha:RecaptchaControl ID="recaptcha" Theme="white" runat="server" PublicKey="6LfW6c4SAAAAAGJweVefQ8jYOLBLbPMsmFnRZwlR" PrivateKey="6LfW6c4SAAAAACfPoedcj4IV6oxDH52zOUciw_nN " />
            <br />
            <asp:Button ID="btSubmit" runat="server" Text="Sign me in" />
        </center>
</asp:Content>

