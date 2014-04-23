<%-- 
 
   Group:       Dara Dermody (10099638), Emma Foley (10105239), Niko Flores (10103406), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        07 April 2014
 
   Project:     Secure Authentication and Session Management System for a Web Application

--%>
<%@page import="mainPackage.*" %>
<%@page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="/errorPage.jsp" %>
<jsp:include page="/header.jsp" />

<!DOCTYPE html>
<html>
    <head>
        <title>Browse Products</title>
        <link rel="stylesheet" type="text/css" href="style.css" />
        <%
            Security sec = new Security();
            // Check session ID, or username and password; if it fails, forward to login
            String[] userInfo = sec.authoriseRequest(request);
            String username = userInfo[0]; // Set to more convenient variable
            String id = userInfo[1]; // Set to more convenient variable

           // If session ID invalid/non-existant, forward to login page (also 
            // determine if login was attempted)
            if (id.equals("")) {
                // If login failed, set attribute so login.jsp can set error message
                if (!username.equals("<none>")) {
                    request.setAttribute("invalid-login", "true");
                } else {
                    request.setAttribute("invalid-login", "false");
                }
                request.setAttribute("address", "index.jsp"); // Set requested page as this page
                // Forward request (with parameters) to login page for authentication
                getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
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

            // Add new product if parameters exist
            String newProductTitle = Security.sanitise(request.getParameter("productName"), false);
            String newProductMessage = Security.sanitise(request.getParameter("productBody"), true);
            if (!newProductMessage.equals("") && !newProductMessage.equals("")) {
                // Create new forum product object with user-inputted product title/name
                ShopProduct newProduct = new ShopProduct(newProductTitle);
                // Add message to product obejct
                newProduct.addMessage(newProductMessage, username);
                ShopListing.addProduct(newProduct); // Add product object to database
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
    </head>

    <body>
        <div class="main-body">
            <form name="productList" method="POST" action="browseProduct.jsp">
                <ul>
                    <%-- Loops through getting of product items --%>
                    <% for (int i = 0; i < ShopListing.getNumberOfProducts(); i++) {
                            String title = ShopListing.getProduct(i).getTitle();
                            String description = ShopListing.getProduct(i).getAllMessages().get(0).getContent();
                    %>
                    <li>
                        <div class="big-wrapper">
                            <button class="product-title-button" type="submit" name="product-name" value="<%= title%>"><%= title%></button>
                            <span class="product-description">
                                <%= description%>
                            </span>
                        </div>
                    </li>
                    <% }%>
                </ul>
            </form>
        </div>
    </body>
</html>
