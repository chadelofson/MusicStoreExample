<%@ Control Language="C#" ClassName="WebUserControl" %>

<script runat="server">
    public string Text { get; set; }

    void page_load() {
        Header.Text = Text;
    }
</script>
<asp:Label ID="Header" runat="server" BackColor="#0B3676" ForeColor="White" Width="100%" />