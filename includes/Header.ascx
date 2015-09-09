<%@ Control Language="C#" ClassName="Header" %>

<script runat="server">

</script>


<div class="logo">
<asp:HyperLink ID="imgLogo" runat="server" NavigateUrl="../Default.aspx"
    ImageUrl="../images/newlogo.png" /><br />
    <font size="-1" color="#FFFFFF">
         Using Amazon.com E-Commerce Web Services<sup>@</sup>
    </font>
</div>
<div class="headerlinks">
<ul class="headerlinks">
    <li>
    <a href="SignIn.aspx"><img src="images/login.png" alt="Sign In" /></a><br />
    </li>
    <li>
    <a href="ShoppingCart.aspx"><img src="images/cart.png" alt="Shopping Cart" /></a><br />
    </li>
    <li>
    <a href="About.aspx"><img src="images/about.png" alt="About Site" /></a>
    </li>
</ul>
</div>



