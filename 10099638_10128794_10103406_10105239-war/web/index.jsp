<%-- 
 
   Group:       Dara Dermody (10099638), Emma Foley (10105239), Niko Flores (10103406), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        07 April 2014
 
   Project:     Secure Authentication and Session Management System for a Web Application

--%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashMap"%>
<%@page import="mainPackage.*" %>
<%@page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="/errorPage.jsp" %>
<jsp:include page="/header.jsp" />
<jsp:useBean id="interactProduct" class="interactionBeans.interactProduct" /> 
<jsp:useBean id="shoppingCartBean" class="interactionBeans.shoppingCartBean" /> 

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
            String newProductName = Security.sanitise(request.getParameter("productName"), false);
            String newProductDescription = Security.sanitise(request.getParameter("productDescription"), true);
            int newProductPrice = Integer.valueOf(Security.sanitise(request.getParameter("productPrice"), false));
            int newProductAmount = Integer.valueOf(Security.sanitise(request.getParameter("productAmount"), false));
            String newProductImage = Security.sanitise(request.getParameter("productImage"), false);
            String newProductSummary = Security.sanitise(request.getParameter("productSummary"), true);

            if (!newProductName.equals("") && !newProductDescription.equals("") && (newProductPrice > 0) && (newProductAmount > 0)) {
                // Create new shop product object with user-inputted product details
                interactProduct.addProduct(newProductName, newProductDescription, newProductAmount, newProductPrice, newProductImage, newProductSummary);
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
            <div id="main">
                <form name="productList" method="POST" action="browseProduct.jsp">
                    <ul>
                        <%-- Loops through getting of products --%>
                        <% for (dbEntities.Product product : interactProduct.findAllProducts()) {
                                String title = product.getTitle();
                                String summary = product.getSummary();
                                String image = product.getImage();
                                int price = Integer.valueOf(String.valueOf(product.getPrice()));
                                int amount = product.getQuantity();
                        %>
                        <li>
                            <div class="big-wrapper">
                                <table>
                                    <tr>
                                        <td>
                                            <button class="product-title-button" type="submit" name="product-name" value="<%= title%>"><%= title%></button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <button class="product-image-button" type="submit" name="product-image" value="<%= title%>"><img src="<%= image%>" title="<%= title%>"></button>
                                                    </td>
                                                    <td>
                                                        <span class="product-summary">
                                                            <%= summary%>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        Price: <%= price%><br>
                                                        Amount: <%= amount%>
                                                    </td>
                                                    <td>
                                                        <button class="product-title-button" type="submit" name="buy-product" value="<%= title%>">BUY</button>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>
                        <% }%>
                    </ul>
                </form>
            </div>
            <div id="sidebar">
                <%
                    double total = shoppingCartBean.getTotal();
                %>
                <button class="checkout-button" type="submit" name="checkout" value="checkout.jsp"><img src="images/Checkout.png" title="checkout"></button>
                <br>
                <ul>
                    <%-- Loops through, getting the last 5 items of the shopping cart --%>
                    <%      HashMap<dbEntities.Product,Integer> shopCart = shoppingCartBean.get5Items();
                            Set<dbEntities.Product> keys = shopCart.keySet();
                            Iterator<dbEntities.Product> it = keys.iterator();
                            dbEntities.Product p;

                            for(int i = 0; i < shopCart.size(); i++) {
                                p = it.next();
                                String title = p.getTitle();
                                int price = Integer.valueOf(String.valueOf(p.getPrice()));
                                int amount = p.getQuantity();
                    %>
                    <li>
                        <button class="checkout-button" type="submit" name="checkout" value="checkout.jsp"><%= title%><br/><%= price%> x <%= amount%> = <%=(price * amount)%></button>
                    </li>
                    <% }%>
                </ul>
                <br/>Total: <%= total%>
            </div>
        </div>
    </body>
</html>