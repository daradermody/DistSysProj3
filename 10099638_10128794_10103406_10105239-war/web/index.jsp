<%-- 
 
   Group:       Dara Dermody (10099638), Emma Foley (10105239), Niko Flores (10103406), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        07 April 2014
 
   Project:     Secure Authentication and Session Management System for a Web Application

--%>
<%@page import="interactionBeans.interactProductLocal"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashMap"%>
<%@page import="mainPackage.*" %>
<%@page import="interactionBeans.*" %>
<%@page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%--<%@page errorPage="/errorPage.jsp" %>--%>

<%!
    interactProductLocal productBean = null;
    shoppingCart shoppingCartBean = null;

    public void jspInit() {
        try {
            productBean = (interactProductLocal) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/interactProduct!interactionBeans.interactProductLocal");
            shoppingCartBean = (shoppingCart) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/shoppingCartBean!interactionBeans.shoppingCart");
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
        }
    }
%>


<jsp:include page="/header.jsp" />

<!DOCTYPE html>
<html>
    <head>
        <title>Browse Products</title>
        <link rel="stylesheet" type="text/css" href="style.css" />
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
            if(user.getShoppingCart() != null)
                shoppingCartBean = user.getShoppingCart();

            // Determine if user has cookies disabled
            boolean cookiesDisabled = request.getCookies() == null;

            Cookie cookie = new Cookie("id", id); // Create new cookie with session ID

            cookie.setMaxAge(-1); // Cookie will be deleted when browser exits
            cookie.setSecure(true); // Forces browser to only send cookie over HTTPS/SSL
            if (!cookiesDisabled) // If cookies enabled, add cookie to response
                response.addCookie(cookie);

            // Complete checkout by simply removing all the items in the shopping cart
            String complete = Security.sanitise(request.getParameter("complete"), false);

            if (!complete.equals("")) {
                shoppingCartBean.checkout();

                // Data log for completed checkout
                PrintWriter fileLog = new PrintWriter(new BufferedWriter(new FileWriter("log.txt", true)));
                Date date = new Date();
                fileLog.println("Shopping Cart - Completed checkout @ " + date.toString());
            }

            // Put the items from the shopping cart back to the database, if the customer clicks delete all
            String deleteAll = Security.sanitise(request.getParameter("deleteAll"), false);

            if (!deleteAll.equals(
                    "")) {
                shoppingCartBean.cancel();

                // Data log for dumped items
                PrintWriter fileLog = new PrintWriter(new BufferedWriter(new FileWriter("log.txt", true)));
                Date date = new Date();
                fileLog.println("Shopping Cart - All items dumped @ " + date.toString());
                //for(int n = 0; n < productNamesDumped.size(); n++) {
                //    fileLog.println("\t" + productNamesDumped.get(n));
            }

            // Remove product if instructed from the browseProduct page
            String productID = Security.sanitise(request.getParameter("removeProduct"), false);
            if (!productID.equals("")) {
                int productToRemove = Integer.valueOf(productID);
                //admin removing the item from database
                productBean.removeProduct(productToRemove);
                
                // Data log for item removal
                PrintWriter fileLog = new PrintWriter(new BufferedWriter(new FileWriter("log.txt", true)));
                Date date = new Date();
                fileLog.println("Item: " + (productBean.searchByID(productToRemove)).getTitle() + " removed @ " + date.toString());
            }

            // Add new product if parameters exist
            String newProductName = Security.sanitise(request.getParameter("productName"), false);
            String newProductDescription = Security.sanitise(request.getParameter("productDescription"), true);

            String productPrice = Security.sanitise(request.getParameter("productPrice"), false);
            int newProductPrice = (!productPrice.equals("")) ? Integer.valueOf(productPrice) : 9999999;

            String productAmount = Security.sanitise(request.getParameter("productPrice"), false);
            int newProductAmount = (!productPrice.equals("")) ? Integer.valueOf(productAmount) : 0;

            String newProductImage = "images/" + Security.sanitise(request.getParameter("productImage"), false);
            String newProductSummary = Security.sanitise(request.getParameter("productSummary"), true);

            if (!newProductName.equals("") && !newProductDescription.equals("") && (newProductPrice > 0) && (newProductAmount > 0)) {
                // Create new shop product object with user-inputted product details
                productBean.addProduct(newProductName, newProductDescription, newProductAmount, newProductPrice, newProductImage, newProductSummary);
                // Data log for product addition
                PrintWriter fileLog = new PrintWriter(new BufferedWriter(new FileWriter("log.txt", true)));
                Date date = new Date();
                if (!newProductName.equals("")) {
                    fileLog.println("New item: " + newProductName + " added @ " + date.toString());
                } else {
                    fileLog.println("New item added @ " + date.toString());
                }
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
                        <% for (dbEntities.Product product : productBean.findAllProducts()) {
                                String title = product.getTitle();
                                String summary = product.getSummary();
                                String image = product.getImage();
                                int price = Integer.valueOf(String.valueOf(product.getPrice()));
                                int amount = product.getQuantity();
                                int prodId = product.getId();
                                // Check to ensure that the amount is at least 1
                                if (amount > 0 || isAdmin) {
                        %>
                        <li>
                            <div class="big-wrapper">
                                <table>
                                    <tr>
                                        <td>
                                            <button class="product-title-button" type="submit" name="product-id" value="<%= prodId%>"><%= title%></button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <button class="product-image-button" type="submit" name="product-id" value="<%= prodId%>"><img src="<%= image%>" title="<%= title%>"></button>
                                                    </td>
                                                    <td>
                                                        <span>
                                                            <%= summary%>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        Price: <b><%= price%></b><hr>
                                                        Amount: <b><%= amount%></b>
                                                    </td>
                                                    <td>
        
                                                        <% if (isAdmin) {%>
                                                        <button class="product-edit-button" type="submit" name="product-id" value="<%= prodId%>"><img src="images/Edit.png" title="edit"/></button>


                                                            <% } else {%>
                                                        <button class="product-buy-button" type="submit" name="product-id" value="<%= prodId%>"><img src="images/Buy.png" title="buy"/></button>
                                                            <% } %>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>
                        <% }
                            }%>
                    </ul>
                </form>
            </div>
            <div id="sidebar" class="big-wrapper">
                <form name="checkout" method="POST" action="checkout.jsp">
                    <%
                        double total = shoppingCartBean.getTotal();
                    %>
                    <button class="checkout-button" type="submit" name="checkout" value="checkout.jsp"><img src="images/Checkout.png" title="checkout"></button>
                    <br/>
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
                            <button class type="submit" name="checkout" value="checkout.jsp"><%= title%><br/><%= price%> x <%= amount%> = <%=(price * amount)%></button>
                        </li>
                        <% }%>
                    </ul>
                    <br/>Total: <%= total%>
                </form>
            </div>
        </div>
    </body>
</html>
