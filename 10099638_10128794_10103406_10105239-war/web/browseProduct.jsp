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
            <ul>
                <%
                    // Retrieves the user from database
                    for (dbEntities.Customer c : interact)
                
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

                    // If user posted content, add comment to product
                    String postedContent = Security.sanitise(request.getParameter("productBody"), true);
                    if (!postedContent.equals("")) {
                        interactProduct.addComment(product, cust, content);
                    }

                    // For each message, display according to set of tags and style
                    int messageCount = 0; // Used to find last message posted
                    int numMessages = product.getAllMessages().size(); // Variable holding number of messages

                    for (Message message : product.getAllMessages()) {
                        messageCount++; // Increment counter of messages
%>
                <li>
                    <div class="big-wrapper message-container">
                        <div class="poster-info">
                            <img src="images/male-default.png" title="<%= message.getPoster()%>" alt="<%= message.getPoster()%>">
                            <span><%= message.getPoster()%></span>
                            <br><%= message.getDate()%>
                        </div>

                        <%-- Identify message as "latest" if it is the last message (for auto-scrolling) --%>
                        <div class="message" <%= (messageCount == numMessages) ? "id='latest'" : ""%>>
                            <%= message.getContent()%> <%-- Fetch message body --%> 
                        </div>
                    </div>
                </li>
                <% } // End of for loop for retrieving all messages%>

                <li>
                    <div class="big-wrapper message-container">
                        <div class="poster-info">
                            <p><img src="images/male-default.png" title="<%= username%>" alt="<%= username%>"></p>
                            <p><%= username%><br></p>
                        </div>

                        <div class="message">
                            <form name="newPost" action="browseProduct.jsp#latest" method="POST">
                                <textarea class="message product-message" name="productBody"></textarea>
                                <input id="submit-button" type="submit" value="Post">
                                <input type="hidden" name="product-title" value="<%= product.getTitle()%>">
                            </form>
                            <form name="refresh" action="browseProduct.jsp#latest" method="POST">
                                <input type="hidden" name="product-title" value="<%= product.getTitle()%>">
                                <button id="refresh-button" type="submit" name="refresh" value="true">Refresh</button>
                            </form>
                        </div>
                    </div>
                </li>
            </ul>
        </div>

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
                    <%      HashMap<dbEntities.Product, Integer> shopCart = shoppingCartBean.get5Items();
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
            </div>
        </div>
    </body>
</html>



