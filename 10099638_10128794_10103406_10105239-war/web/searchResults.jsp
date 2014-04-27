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
<%@page import="interactionBeans.interactCustomerLocal"%>
<%@page import="interactionBeans.shoppingCart"%>
<%@page import="interactionBeans.interactProductLocal"%>
<%@page import="dbEntities.Product"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashMap"%>
<%@page import="mainPackage.*" %>
<%@page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%--<%@page errorPage="/errorPage.jsp" %>--%>
<jsp:include page="/header.jsp" />

<%!
    interactProductLocal interactProduct = null;
    shoppingCart shoppingCartBean = null;
    interactCustomerLocal customerBean = null;

    public void jspInit() {
        try {
            interactProduct = (interactProductLocal) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/interactProduct!interactionBeans.interactProductLocal");
            shoppingCartBean = (shoppingCart) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/shoppingCartBean!interactionBeans.shoppingCart");
            customerBean = (interactCustomerLocal) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/interactCustomer!interactionBeans.interactCustomerLocal");
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
        }
    }
%>


<!DOCTYPE html>
<html>
    <head>
        <title>Search Results</title>
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
    </head>

    <body>
        <div class="main-body">
            <div id="main">
                <form name="searchResults" method="POST" action="browseProduct.jsp">
                    <ul>
                        <%  // First, identifies whether to search by ID or name
                            // Then, add the search result(s) to a temporary array
                            ArrayList<dbEntities.Product> results = new ArrayList<>();
                            dbEntities.Product product = new dbEntities.Product();
                            String searchBy = Security.sanitise(request.getParameter("searchBy"), false);
                            if (searchBy.equals("ID")) {
                                int searchID = 0;
                                try {
                                    searchID = Integer.valueOf(Security.sanitise(request.getParameter("searchKeywords"), false));
                                } catch (NumberFormatException e) {
                                    System.out.println("Error caught: User searched for ID with non-integer string");
                                }
                                product = interactProduct.searchByID(searchID);
                                if (product != null) {
                                    results.add(product);
                                }
                            } else if (searchBy.equals("name")) {
                                String searchKW = Security.sanitise(request.getParameter("searchKeywords"), false);
                                results.addAll(interactProduct.searchProductByKeyword(searchKW));
                            }

                            if (!results.isEmpty()) {
                                // Loops through search results
                                for (dbEntities.Product prod : results) {
                                    String title = prod.getTitle();
                                    String summary = prod.getSummary();
                                    String image = prod.getImage();
                                    int price = Integer.valueOf(String.valueOf(prod.getPrice()));
                                    int amount = prod.getQuantity();

                                    // Check to ensure that the amount is at least 1
                                    if (amount > 0) {
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
                                                        Price: <b><%= price%></b><hr>
                                                        Amount: <b><%= amount%></b>
                                                    </td>
                                                    <td>
                                                        <% if (isAdmin) {%>
                                                        <button class="product-title-button" type="submit" name="product-name" value="<%= title%>"><img src="images/Edit.png" title="edit"/></button>
                                                            <% } else {%>
                                                        <button class="product-title-button" type="submit" name="product-name" value="<%= title%>"><img src="images/Buy.png" title="buy"/></button>
                                                            <% } %>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>
                        <%
                                }
                            }
                        } else { %>
                        <li>
                            There are no search results to show!
                        </li>
                        <%
                            }
                        %>
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
                                String prTitle = p.getTitle();
                                int prPrice = Integer.valueOf(String.valueOf(p.getPrice()));
                                int prAmount = p.getQuantity();
                        %>
                        <li>
                            <button type="submit" name="checkout" value="checkout.jsp"><%= prTitle%><br/><%= prPrice%> x <%= prAmount%> = <%=(prPrice * prAmount)%></button>
                        </li>
                        <% }%>
                    </ul>
                    <br/>Total: <b><%= total%></b>
                </form>
            </div>
        </div>
    </body>
</html>
