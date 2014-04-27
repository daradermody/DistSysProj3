<%-- 
 
   Group:       Niko Flores (10103406), Emma Foley (10105239), Dara Dermody (10099638), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        25 April 2014
 
   Project:     Online Shop Application using Enterprise JavaBeans and Entity Classes
        Number: 3

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
<%@page errorPage="/errorPage.jsp" %>

<%!
    interactProductLocal productBean = null;
    shoppingCart cart = null;

    // Initializes the enterprise java beans
    public void jspInit() {
        try {
            productBean = (interactProductLocal) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/interactProduct!interactionBeans.interactProductLocal");
            cart = (shoppingCart) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/shoppingCartBean!interactionBeans.shoppingCart");
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
        }
    }
%>


<jsp:include page="/header.jsp" />

<!DOCTYPE html>
<html>
    <head>
        <title>Complete Checkout</title>
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
                cart = user.shoppingCart;
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
            <h1>Thank you for buying from Koalascense!
                You didn't have to pay. You still owe us money.
                Depending on where you live, we will break your legs, unless the
                police get to you first.</h1>
            <br>
            <br>
            <hr>
            <h2>See you soon!</h2>
        </div>
    </body>
</html>
