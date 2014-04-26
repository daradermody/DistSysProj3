<%-- 
 
   Group:       Niko Flores (10103406), Emma Foley (10105239), Dara Dermody (10099638), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        25 April 2014
 
   Project:     Online Shop Application using Enterprise JavaBeans and Entity Classes
        Number: 3

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
        <title>Checkout</title>
        <link rel="stylesheet" type="text/css" href="style.css" />
        <%
            Security sec = new Security();
            // Check session ID, or username and password; if it fails, forward to login
            User user = sec.authoriseRequest(request);
            String username = user.getUsername(); // Set to more convenient variable
            String id = user.getUsername(); // Set to more convenient variable
            boolean isAdmin = user.getIsAdmin(); // Set to more convenient variable

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

            // Remove product in cart if instructed
            int productToRemove = Integer.valueOf(Security.sanitise(request.getParameter("removeProduct"), false));
            int amountToRemove = Integer.valueOf(Security.sanitise(request.getParameter("removeAmount"), false));
            if (productToRemove > 0) {
                interactProduct.increaseQuantity(productToRemove, amountToRemove);
                shoppingCartBean.removeItem(interactProduct.searchByID(productToRemove), 1);
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
                <form name="shoppingCart" method="POST" action="browseProduct.jsp">
                    <ul>
                        <%-- Loops through getting of shopping cart products --%>
                        <%  HashMap<dbEntities.Product, Integer> shopCart = shoppingCartBean.getItems();
                            Set<dbEntities.Product> keys = shopCart.keySet();
                            Iterator<dbEntities.Product> it = keys.iterator();
                            dbEntities.Product p;

                            for (int m = 0; m < shopCart.size(); m++) {
                                p = it.next();
                                String title = p.getTitle();
                                String summary = p.getSummary();
                                String image = p.getImage();
                                int price = Integer.valueOf(String.valueOf(p.getPrice()));
                                int amount = p.getQuantity();
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
                                                        <button class="product-image-button" type="submit" name="product-name" value="<%= title%>"><img src="<%= image%>" title="<%= title%>"></button>
                                                    </td>
                                                    <td>
                                                        <span class="product-summary">
                                                            <%= summary%>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        Price: <%= price%><br/>
                                                        Amount: <%= amount%><br/>
                                                        Item Total: <%= (price * amount)%>
                                                    </td>
                                                    <td>
                                                        <input type="number" name="removeAmount" id="reduce-amount">
                                                        <script type="text/javascript">
                                                            document.getElementById("reduce-amount").value = <%= amount%>;
                                                        </script>
                                                        <button class="product-title-button" type="submit" name="removeProduct" value="<%= p.getId()%>"><img src="Remove.png" title="edit"/></button>
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
                <br/>Total: <b><%= total%></b>
                <br/>
                <form name="cartActions" method="POST" action="index.jsp">
                    <button type="submit" name="complete" value="Complete"><img src="images/Complete.png" title="complete"></button>
                    <button type="submit" name="cancel" value="Cancel"><img src="images/Cancel.png" title="cancel"></button>
                    <button type="submit" name="deleteAll" value="Delete All"><img src="images/Trash.png" title="deleteAll"></button>
                </form>
            </div>
        </div>
    </body>
</html>