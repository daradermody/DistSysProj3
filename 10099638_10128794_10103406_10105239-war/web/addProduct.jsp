<%-- 
 
   Group:       Niko Flores (10103406), Emma Foley (10105239), Dara Dermody (10099638), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        25 April 2014
 
   Project:     Online Shop Application using Enterprise JavaBeans and Entity Classes
        Number: 3

--%>

<%@page import="javax.naming.InitialContext"%>
<%@page import="interactionBeans.shoppingCart"%>
<%@page import="interactionBeans.interactProductLocal"%>
<%@page import="interactionBeans.interactProductLocal"%>
<%@page import="mainPackage.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="/errorPage.jsp" %>
<jsp:include page="/header.jsp" />

<%!
    interactProductLocal productBean = null;
    shoppingCart shoppingCartBean = null;

    // Initializes the enterprise java beans
    public void jspInit() {
        try {
            productBean = (interactProductLocal) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/interactProduct!interactionBeans.interactProductLocal");
            shoppingCartBean = (shoppingCart) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/shoppingCartBean!interactionBeans.shoppingCart");
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>New Product</title>
        <link rel="stylesheet" type="text/css" href="style.css" />
    </head>

    <body>
        <%
            Security sec = new Security();
            // Check session ID, or username and password; if it fails, forward to login
            User user = sec.authoriseRequest(request);
            String username = ""; // Set to more convenient variable
            String id = ""; // Set to more convenient variable
            boolean isAdmin = false; // Set to more convenient variable

            // If session ID invalid/non-existant, forward to login page (also 
            // determine if login was attempted)
            if (user == null) {
                // If login failed, set attribute so login.jsp can set error message
                request.setAttribute("invalid-login", "false");
                request.setAttribute("address", "index.jsp"); // Set requested page as this page
                // Forward request (with parameters) to login page for authentication
                getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
            }

            username = user.getUsername(); // Set to more convenient variable
            id = user.getSessionID(); // Set to more convenient variable
            isAdmin = user.getIsAdmin(); // Set to more convenient variable
            if (user.getShoppingCart() != null) {
                shoppingCartBean = user.getShoppingCart();
            }

            // Determine if user has cookies disabled
            boolean cookiesDisabled = request.getCookies() == null;

            Cookie cookie = new Cookie("id", id); // Create new cookie with session ID

            cookie.setMaxAge(-1); // Cookie will be deleted when browser exits
            cookie.setSecure(true); // Forces browser to only send cookie over HTTPS/SSL
            if (!cookiesDisabled) // If cookies enabled, add cookie to response
            {
                response.addCookie(cookie);
            }
        %>

        <!-- Import jQuery -->
        <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.0.js"></script>
        <%-- JavaScript function that adds ID field to form when submitted if cookies are disabled --%>
        <script type="text/javascript">
            $(function() {
                $('form').submit(function() { // On submission of form
                    if (!navigator.cookieEnabled) // Check if cookies disabled
                        $(this).append('<input type="hidden" name="id" value="<%= id%>">');
                    return true;
                });
            });
        </script>

        <div class="main-body">
            <form name="newProduct" method="POST" action="index.jsp">
                <div class="big-wrapper message-container">
                    <table>
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td>
                                            <div id="product-name-container">
                                                Name: <input type="text" id="product-title" name="productName">
                                            </div>
                                        </td>
                                        <td>
                                            <div id="product-price-container">
                                                Price: <input type="number" id="product-price" name="productPrice">
                                                <script type="text/javascript">
                                                    document.getElementById("product-price").value = 0;
                                                </script>
                                            </div>
                                        </td>
                                        <td>
                                            <div id="product-amount-container">
                                                Amount: <input type="number" id="product-amount" name="productAmount">
                                                <script type="text/javascript">
                                                    document.getElementById("product-amount").value = 1;
                                                </script>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <form action="upload" method="POST" enctype="multipart/form-data">
                                    <input type="file" name="productImage">
                                    </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div id="product-summary-container">
                                                Summary: <input type="text" id="product-summary" name="productSummary">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div id="product-description-container">
                                                Description: <textarea class="product-description" name="productDescription"></textarea>
                                            </div>
                                        </td>
                                    </tr>
                    </table>
                    <input id="submit-button" type="submit" value="Add Product">
            </form>
        </div>
    </body>
</html>
