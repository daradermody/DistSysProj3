<%-- 
 
   Group:       Dara Dermody (10099638), Emma Foley (10105239), Niko Flores (10103406), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        07 April 2014
 
   Project:     Secure Authentication and Session Management System for a Web Application

--%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashMap"%>
<%@page import="mainPackage.*" %>
<%@page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="/errorPage.jsp" %>
<jsp:include page="/header.jsp" />
<jsp:useBean id="interactProduct" class="interactionBeans.interactProduct" /> 
<jsp:useBean id="interactCustomer" class="interactionBeans.interactCustomer" /> 
<jsp:useBean id="shoppingCartBean" class="interactionBeans.shoppingCartBean" /> 

<!DOCTYPE html>
<html>
    <head>
        <title><%= Security.sanitise(request.getParameter("product-title"), false)%></title>
        <link rel="stylesheet" type="text/css" href="style.css" />
    </head>

    <body>
        <%
            Security sec = new Security();
            // Check session ID, or username and password; if it fails, forward to login
            String[] userInfo = sec.authoriseRequest(request);
            String username = userInfo[0]; // Set to more convenient variable
            String id = userInfo[1]; // Set to more convenient variable
            String isAdmin = userInfo[2]; // Set to more convenient variable

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
            <div id="main">
                <%
                    dbEntities.Customer customer = new dbEntities.Customer();
                    // Retrieves the user from database
                    for (dbEntities.Customer c : interactCustomer.findAllCustomers()) {
                        if (username == c.getUsername()) {
                            customer = c;
                            break;
                        }
                    }

                    // Retrieves the request product from database
                    dbEntities.Product product = new dbEntities.Product();
                    String requestedProduct = Security.sanitise(request.getParameter("product-name"), false);
                    for (dbEntities.Product p : interactProduct.findAllProducts()) {
                        if (requestedProduct == p.getTitle()) {
                            product = p;
                            break;
                        }
                    }

                    // If requested product not found, redirect to main product page
                    if (product == null) {
                        response.sendRedirect("index.jsp");
                    }

                    // If the admin user changes the amount of the product, reflect the changes
                    int addAmount = Integer.valueOf(Security.sanitise(request.getParameter("productAmount"), false));
                    if (addAmount > 0) {
                        interactProduct.increaseQuantity(product.getId(), addAmount);
                    }

                    // If the user opts to buy the item, decrease amount of item and add to shopping cart
                    // Ensure that the requested amount will not force the total amount to go below 0
                    int buyAmount = Integer.valueOf(Security.sanitise(request.getParameter("reduceAmount"), false));
                    if (buyAmount > 0 && ((product.getQuantity() - buyAmount) >= 0)) {
                        interactProduct.reduceQuantity(product.getId(), buyAmount);
                        shoppingCartBean.addItem(product, buyAmount);
                    }

                    // If user posted content, add comment to product
                    String postedContent = Security.sanitise(request.getParameter("productBody"), true);
                    if (!postedContent.equals("")) {
                        interactProduct.addComment(product, customer, postedContent);
                    }%>

                <div class="big-wrapper">
                    <table>
                        <tr>
                            <td>
                                <%= product.getTitle()%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td>
                                            <img src="<%= product.getImage()%>" title="<%= product.getTitle()%>">
                                        </td>
                                        <td>
                                            Price: <%= product.getPrice()%><br>
                                            <% if (isAdmin.equals("true")) {%>
                                            <form name="browse-product" method="POST" action="browseProduct.jsp">
                                                Amount: <%= product.getQuantity()%> + <input type="number" id="product-amount" name="productAmount">
                                                <script type="text/javascript">
                                                    document.getElementById("product-amount").value = 0;
                                                </script>
                                                <br/><input id="submit-button" type="submit" value="Change Amount">
                                            </form>
                                            <% } else {%>                                             
                                            Amount: <%= product.getQuantity()%>
                                            <% }%>
                                        </td>
                                        <td>
                                            <form name="browse-product" method="POST" action="browseProduct.jsp">
                                                <input type="number" id="reduce-amount" name="reduceAmount">
                                                <script type="text/javascript">
                                                    document.getElementById("reduce-amount").value = 1 > ;</script>
                                                <button class="product-title-button" type="submit" name="buyProduct" value="Buy Product"><img src="Buy.png" title="buy"/></button>
                                            </form>
                                        </td>
                                        <% if (isAdmin.equals("true")) { %>
                                        <td>
                                            <form name="browse-product" method="POST" action="index.jsp">
                                                <button class="product-title-button" type="submit" name="removeProduct" value="<%= product.getId()%>"><img src="Remove.png" title="remove"/></button>
                                            </form>
                                        </td>
                                        <% } %>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%= product.getDescription()%>
                            </td>
                        </tr>
                    </table>
                </div>
                <ul>
                    <%
                        // For each message, display according to set of tags and style
                        for (dbEntities.Comments comm : interactProduct.getComments(product.getId())) {
                            String message = comm.getContent();
                            String poster = comm.getPoster();
                            String date = comm.getDate().toString();
                    %>
                    <li>
                        <div class="big-wrapper message-container">
                            <div class="poster-info">
                                <span><%= poster%></span>
                                <br><%= date%>
                            </div>

                            <div class="message">
                                <%= message%>
                            </div>
                        </div>
                    </li>
                    <% } // End of for loop for retrieving all messages%>

                    <li>
                        <div class="big-wrapper message-container">
                            <div class="poster-info">
                                <p><%= username%><br></p>
                            </div>

                            <div class="message">
                                <form name="newComment" action="browseProduct.jsp" method="POST">
                                    <textarea class="message product-message" name="productBody"></textarea>
                                    <input id="submit-button" type="submit" value="Comment">
                                    <input type="hidden" name="product-title" value="<%= product.getTitle()%>">
                                </form>
                                <form name="refresh" action="browseProduct.jsp" method="POST">
                                    <input type="hidden" name="product-title" value="<%= product.getTitle()%>">
                                    <button id="refresh-button" type="submit" name="refresh" value="true">Refresh</button>
                                </form>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div id="sidebar">
            <form name="checkout" method="POST" action="checkout.jsp">
                <%
                    double total = shoppingCartBean.getTotal();
                %>
                <button class="checkout-button" type="submit" name="checkout" value="checkout.jsp"><img src="images/Checkout.png" title="checkout"></button>
                <br>
                <ul>
                    <%-- Loops through, getting 5 items of the shopping cart --%>
                    <%  HashMap<dbEntities.Product, Integer> shopCart = shoppingCartBean.get5Items();
                        Set<dbEntities.Product> keys = shopCart.keySet();
                        Iterator<dbEntities.Product> it = keys.iterator();
                        dbEntities.Product p;

                        for (int i = 0; i < shopCart.size(); i++) {
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
            </form>
        </div>
    </body>
</html>