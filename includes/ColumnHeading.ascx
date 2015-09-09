<%@ Control Language="C#" ClassName="ColumnHeading" %>

<script runat="server">
    public string Text { set; get; }
    void page_load() {
        lblColumnHeading.Text = Text;
    }
</script>
<asp:Label ID="lblColumnHeading"  runat="server" />