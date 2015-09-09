<%@ Control Language="C#" ClassName="LeftMenu" %>

<script runat="server">
    void page_load()
    {
        //Initialize dataAccess class
        DataAccess myDA = new DataAccess("MusicStore3");

        //Populate dataTable and bind to GridView Control
        string strSQL = "SELECT DISTINCT tblStyles.intStyleId, tblStyles.strStyleName " +
                        " FROM tblStyles INNER JOIN " +
                        "tblStyleASIN ON tblStyles.intStyleId = tblStyleASIN.intStyleID " +
                        "ORDER BY tblStyles.strStyleName";
        
        dlMenu.DataSource = myDA.FillDataTable(strSQL);
        dlMenu.DataBind();
    }
    
    protected void tbSearch_TextChanged(object sender, EventArgs e)
    {
        Response.Redirect("SearchBrowse.aspx?Search=" + tbSearch.Text);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Response.Redirect("SearchBrowse.aspx?Search=" + tbSearch.Text);
    }
</script>

<b>Search</b><br />
<asp:TextBox ID="tbSearch" runat="server" 
    ontextchanged="tbSearch_TextChanged" /><br />
<asp:Button ID="btnSearch" runat="server" Text="Search" 
    onclick="btnSearch_Click" /><br /><br />
<b>Browse</b><br />

<asp:DataList ID="dlMenu" runat="server">
<ItemTemplate>
 <a class="menulink" href="SearchBrowse.aspx?style=<%# Eval("intStyleID") %>">
 <%# Eval("strStyleName") %>
 </a>
 <br />
 </ItemTemplate>
 </asp:DataList>
 <br />
 <asp:HyperLink ID="Home" Text="Return Home" runat="server" NavigateUrl="../Default.aspx" />

