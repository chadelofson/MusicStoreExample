<%@ Page Title="" Language="C#" MasterPageFile="~/mis324/Assignments/MusicStore3/MasterPage.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<title>JAS Music - About this site</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <div style="padding: 5px; text-align: left; font-size: smaller;">
        <ul>
            <li>XML Music is a class project built by Chad Elofson for <a href="http://yorktown.cbe.wwu.edu/sandvig/mis324/">
                MIS 324</a> Intermediate Web Development and Management at Western Washington University.
            </li>
            <li>Created with ASP.NET and C#. </li>
            <li>Product and customer data is stored in SQL Server Express database and normalized
                to third-normal form. </li>
            <li>Amazon web services used for product information</li><li>MasterPages and user controls
                used to eliminate duplicate UI code. </li>
            <li>All user entries are validated using validation controls</li><li><b>Home Page</b>
                <ul>
                    <li>&quot;Today's Feature Items&quot; are randomly selected from a database. </li>
                    <li>A DataList server control is used to display the items. </li>
                    <li>The browse menu is dynamically generated from a database. </li>
                    <li>The browse menu is cached for 10 minutes (to maximize efficiency).</li></ul>
            </li>
            <li><b>Search/Browse response page</b>
                <ul>
                    <li>Amazon web services used to search Amazon's database.</li>
                    <li>Responds gracefully if no items are found by search. </li>
                </ul>
            </li>
            <li><b>Product page</b>
                <ul>
                    <li>Amazon web services used to retrieve product information.</li></ul>
                <li><b>Shopping cart page</b>
                    <ul>
                        <li>Shopping cart functionality is provided by a shopping cart class.</li><li>Cart information
                            stored in database.</li></ul>
                    <li><b>Checkout page</b><ul>
                        <li>Searches the database for existing customer accounts and populates the form with
                            their information.</li><li>Information for new customers is written to the database.</li><li>
                                Customers &amp; order are assigned a unique ID number via an autonumber database
                                field.</li><li>Validation controls are used to validate all user inputs, including a
                                    regular expression validator to check the pattern of the email address.
                        </li>
                        <li>The textbox OnTextChanged event is used check for changes to customer information.
                            Database is updated only if data has changed.</li><li>An HTML confirmation email is
                                sent to the customer. </li>
                    </ul>
                        <li><b>Order History Page</b> </li>
                        <ul>
                            <li>Searches the database and displays all orders associated with customer's ID.
                            </li>
                        </ul>
                        <li><font color="#006699"><b>Enhancements</b></font><font color="#FF0000"> </font>
                        </li>
                        <ul>
                            <li>Graphics.</li>
                            <li>Captcha at the Sign in page to prevent spamming</li>
                            <li>Product page uses lightbox to display large image.</li>
                            <li>City, state and zip code are validated against a database containing over 42,000
                                zipcodes. Validation is implemented using a custom validator control.</li>
                            <li>OrderHistory groups items by OrderID.</li>
                        </ul>
                        <li>Thanks to Amazon.com (the world's greatest on-line store) for the use of its icons,
                            CD images and descriptions. </li>
        </ul>
    </div>


</asp:Content>

