<%-- 
 
   Group:       Niko Flores (10103406), Emma Foley (10105239), Dara Dermody (10099638), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        25 April 2014
 
   Project:     Online Shop Application using Enterprise JavaBeans and Entity Classes
        Number: 3

--%>
<%@page import="interactionBeans.interactCustomerLocal"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="interactionBeans.shoppingCart"%>
<%@page import="interactionBeans.interactProductLocal"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashMap"%>
<%@page import="mainPackage.*" %>
<%@page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="/errorPage.jsp" %>
<jsp:include page="/header.jsp" />

<%!
    interactProductLocal productBean = null;
    shoppingCart cart = null;
    interactCustomerLocal customerBean = null;

    // Initializes the enterprise java beans
    public void jspInit() {
        try {
            productBean = (interactProductLocal) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/interactProduct!interactionBeans.interactProductLocal");
            cart = (shoppingCart) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/shoppingCartBean!interactionBeans.shoppingCart");
            customerBean = (interactCustomerLocal) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/interactCustomer!interactionBeans.interactCustomerLocal");
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
        }
    }
%>
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

            System.out.println("Starting shopping cart crap");
            System.out.println("Shopping cart exists " + (user.shoppingCart != null));

            if (user.getShoppingCart() == null) {
                user.shoppingCart = (shoppingCart) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/shoppingCartBean!interactionBeans.shoppingCart");
                System.out.println("Creating new shopping cart");
            }

            cart = user.shoppingCart;
            System.out.println("Exist? " + (cart != null));

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
                    for (dbEntities.Customer c : customerBean.findAllCustomers()) {
                        if (username == c.getUsername()) {
                            customer = c;
                            break;
                        }
                    }

                    // Retrieves the requested product from database
                    dbEntities.Product product = null;
                    String requestedProduct = Security.sanitise(request.getParameter("product-id"), false);
                    if (requestedProduct != "") {
                        int productID = Integer.parseInt(requestedProduct);
                        for (dbEntities.Product p : productBean.findAllProducts()) {
                            if (productID == p.getId()) {
                                product = p;
                                break;
                            }
                        }
                    }

                    // If requested product not found, redirect to main product page
                    if (product == null) {
                        response.sendRedirect("index.jsp");
                    } else {
                        // If the admin user changes the amount of the product, reflect the changes
                        String addAmount = Security.sanitise(request.getParameter("productAmount"), false);
                        int amountAdd = 0;
                        if (!addAmount.equals("")) {
                            amountAdd = Integer.valueOf(addAmount);
                            productBean.increaseQuantity(product.getId(), amountAdd);
                        }

                        // If the user opts to buy the item, decrease amount of item and add to shopping cart
                        // Ensure that the requested amount will not force the total amount to go below 0
                        String buyAmount = Security.sanitise(request.getParameter("reduceAmount"), false);
                        int amountBuy = 0;
                        if (!buyAmount.equals("")) {
                            amountBuy = Integer.valueOf(buyAmount);
                            if (amountBuy > 0 && ((product.getQuantity() - amountBuy) >= 0)) {
                                productBean.reduceQuantity(product.getId(), amountBuy);
                                cart.addItem(product, amountBuy);
                            }
                        }
                        product = productBean.searchByID(product.getId());

                        // If user posted content, add comment to product
                        String postedContent = Security.sanitise(request.getParameter("productBody"), true);
                        if (!postedContent.equals("")) {
                            productBean.addComment(product, customer, postedContent);
                        }
                    }%>

                <div class="big-wrapper">
                    <table>
                        <tr>
                            <td>
                                <button class="product-title-button" type="submit"><%= product.getTitle()%></button>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td>
                                            <button class="product-image-button" type="submit"><img height="90" width="90" src="<%= product.getImage()%>" title="<%= product.getTitle()%>"></button>
                                        </td>
                                        <td>
                                            <span>
                                                <%= product.getSummary()%>
                                            </span>
                                        </td>
                                        <td>
                                            Price: <b><%= product.getPrice()%></b><hr>
                                            <% if (isAdmin) {%>
                                            <form name="increase-amount" method="POST" action="browseProduct.jsp">
                                                <input type="hidden" name="product-id" value="<%= product.getId()%>">
                                                Amount: <b><%= product.getQuantity()%></b> + <input type="number" id="product-amount" name="productAmount" value="0">
                                                <br/><input id="submit-button" type="submit" value="Change Amount">
                                            </form>
                                            <% } else {%>                                             
                                            Amount: <b><%= product.getQuantity()%></b>
                                            <% }%>
                                        </td>
                                        <% if (isAdmin) {%>
                                        <td>
                                            <form name="remove-product" method="POST" action="index.jsp">
                                                <button class="product-image-button" type="submit" name="removeProduct" value="<%= product.getId()%>"><img height="32" width="32" src="images/Remove.png" title="remove"/></button>
                                                <input type="hidden" name="product-id" value="<%= product.getId()%>">
                                            </form>
                                        </td>
                                        <% } else {%>
                                        <td>
                                            <form name="buy-product" method="POST" action="browseProduct.jsp">
                                                <input type="number" id="reduce-amount" name="reduceAmount">
                                                <script type="text/javascript">
                                                    document.getElementById("reduce-amount").value = 1;</script>
                                                <button class="product-edit-button" type="submit" name="buyProduct" value="Buy Product"><img height="32" width="32" src="images/Buy.png" title="buy"/></button>
                                                <input type="hidden" name="product-id" value="<%= product.getId()%>">
                                            </form>
                                        </td>
                                        <% }%>
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
                        // Display each comment for the specified product
                        for (dbEntities.Comments comm : productBean.getComments(product.getId())) {
                            System.out.println("Comment date exists? " + (comm.getDate() != null));
                            String message = comm.getContent();
                            String poster = comm.getPoster();
                            String date = "";
                            if (comm.getDate() != null) {
                                date = comm.getDate().toString();
                            }
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
                    <% }
                        System.out.println("End loop"); // End of for loop for retrieving all messages%>

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
                                    <input type="hidden" name="product-id" value="<%= product.getId()%>">
                                </form> 
                                <form name="refresh" action="browseProduct.jsp" method="POST">
                                    <input type="hidden" name="product-title" value="<%= product.getTitle()%>">
                                    <button id="submit-button" type="submit" name="refresh" value="true">Refresh</button>
                                    <input type="hidden" name="product-id" value="<%= product.getId()%>">
                                </form>
                            </div>

                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div id="sidebar" class="big-wrapper">
            <form name="checkout" method="POST" action="checkout.jsp">
                <%
                    double total = cart.getTotal();
                %>
                <button class="checkout-button" type="submit" name="checkout" value="checkout.jsp"><img src="images/Checkout.png" title="checkout"></button>
                <br>
                <ul>
                    <%-- Loops through, getting ONLY 5 items of the shopping cart --%>
                    <%  HashMap<dbEntities.Product, Integer> shopCart = cart.get5Items();
                        Set<dbEntities.Product> keys = shopCart.keySet();
                        Iterator<dbEntities.Product> it = keys.iterator();
                        dbEntities.Product p;

                        for (int i = 0; i < shopCart.size(); i++) {
                            p = it.next();
                            String title = p.getTitle();
                            int price = Integer.valueOf(String.valueOf(p.getPrice()));
                            int amount = cart.getItems().get(p);
                    %>
                    <li>
                        <button class="checkout-button" type="submit" name="checkout" value="checkout.jsp"><%= title%><br/><b><%= price%> x <%= amount%> = <%=(price * amount)%></b></button>
                    </li>
                    <% }%>
                </ul>
                <hr/>Total: <b><%= total%></b>
            </form>
        </div>
    </body>
</html>
