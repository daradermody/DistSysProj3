<%-- 
 
   Group:       Dara Dermody (10099638), Emma Foley (10105239), Niko Flores (10103406), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        07 April 2014
 
   Project:     Secure Authentication and Session Management System for a Web Application

--%>
<%@page import="mainPackage.*"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="/errorPage.jsp" %>
<jsp:include page="/header.jsp" />

<!DOCTYPE html>
<html>
    <head>
        <title><%= Security.sanitise(request.getParameter("product-title"), false) %></title>
        <link rel="stylesheet" type="text/css" href="style.css" />
    </head>

    <body>
        <%
            Security sec = new Security();
            // Check session ID, or username and password; if it fails, forward to login
            String[] userInfo = sec.authoriseRequest(request);
            String username = userInfo[0]; // Set to more convenient variable
            String id = userInfo[1]; // Set to more convenient variable
            
            // If session ID invalid/non-existant, forward to login page (also 
            // determine if login was attempted)
            if(id.equals("")) {
                // If login failed, set attribute so login.jsp can set error message
                if(!username.equals("<none>"))
                    request.setAttribute("invalid-login", "true");
                else
                    request.setAttribute("invalid-login", "false");
                request.setAttribute("address", "index.jsp"); // Set requested page as this page
                // Forward request (with parameters) to login page for authentication
                getServletContext().getRequestDispatcher("/login.jsp").forward(request,response);
            }
            
            // Determine if user has cookies disabled
            boolean cookiesDisabled = request.getCookies() == null;
            
            Cookie cookie = new Cookie("id", id); // Create new cookie with session ID
            cookie.setMaxAge(-1); // Cookie will be deleted when browser exits
            cookie.setSecure(true); // Forces browser to only send cookie over HTTPS/SSL
            if(!cookiesDisabled) // If cookies enabled, add cookie to response
                response.addCookie(cookie);   
        %>

        <!-- Import jQuery -->
        <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.0.js"></script>
        <%-- JavaScript function that adds ID field to form when submitted if cookies are disabled --%>
        <script type="text/javascript">
            $(function() {
                $('form').submit(function() { // On submission of form
                    if (!navigator.cookieEnabled) // Check if cookies disabled
                        $(this).append('<input type="hidden" name="id" value="<%= id %>">');
                    return true;
                });
            });
        </script>


        <div class="main-body">
            <ul>
                <%
                    // Find index of product being requested
                    String productTitle;
                    
                    String requestedProduct = Security.sanitise(request.getParameter("product-name"), false);
                    ShopProduct product = null;
                    for (int index = 0; index < ShopListing.getNumberOfProducts(); index++) {
                        productTitle = ShopListing.getProduct(index).getTitle();
                        
                        if (productTitle.equals(requestedProduct)) {
                            product = ShopListing.getProduct(index); // Retrieve requested product
                            break;
                        }
                    }
                    // If requested product not found, redirect to main product page
                    if(product == null) response.sendRedirect("index.jsp");

                    // If user posted content, add message to product
                    String postedContent = Security.sanitise(request.getParameter("messageBody"), true);

                    if (!postedContent.equals(""))
                        product.addMessage(postedContent, username);

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
                        <div class="message" <%= (messageCount == numMessages) ? "id='latest'" : "" %>>
                            <%= message.getContent() %> <%-- Fetch message body --%> 
                        </div>
                    </div>
                </li>
                <% } // End of for loop for retrieving all messages%>

                <li>
                    <div class="big-wrapper message-container">
                        <div class="poster-info">
                            <p><img src="images/male-default.png" title="<%= username %>" alt="<%= username %>"></p>
                            <p><%= username %><br></p>
                        </div>

                        <div class="message">
                            <form name="newPost" action="browseProduct.jsp#latest" method="POST">
                                <textarea class="message product-message" name="messageBody"></textarea>
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
    </body>
</html>



