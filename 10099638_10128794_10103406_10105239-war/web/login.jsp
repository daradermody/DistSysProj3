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
<%@page import="interactionBeans.shoppingCart"%>
<%@page import="java.lang.NullPointerException"%>
<%@page import="mainPackage.Security"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="/errorPage.jsp" %>

<%!
    shoppingCart cart = null;

    // Initializes the enterprise java beans
    public void jspInit() {
        try {
            cart = (shoppingCart) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/shoppingCartBean!interactionBeans.shoppingCart");
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <meta name="description" content="Website for online shop application using EJB, entity classes and servlets/JSP/HTML for Distributed Systems Project III">
        <meta name="keywords" content="java distributed systems project online shop application enterprise java beans entity classes servlet jsp html">

        <link rel="stylesheet" type="text/css" href="style.css" />
        <!-- Import jQuery -->
        <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.0.js"></script>
        <%-- Import PBKDF2 key derivation function --%>
        <script type="text/javascript"  src="https://crypto-js.googlecode.com/svn/tags/3.1.2/build/rollups/sha1.js"></script>
        <%-- JavaScript function to hash password before sending it to server --%>
        <script type="text/javascript">
            $(function() {
                $('#login-fields').submit(function() {
                    $passwd = $('input[name="password"]');
                    $passwd.val(CryptoJS.SHA1($passwd.val()));
                    return true;
                });
            });
        </script>
    </head>

    <body>
        <%
            // Check if page was reached upon clicking the Log Out button
            String id = null;
            if (Security.sanitise((String) request.getParameter("log-out"), true).equals("true")) {
                System.out.println("Log out");
                // Check for ID in cookies
                Cookie[] cookies = request.getCookies(); // Fetch Cookie array
                if (cookies != null) // Cycle through each cookie in Cookie array to find one with name "id"
                {
                    for (Cookie cookie : cookies) {
                        if (cookie.getName().equals("id")) {
                            id = Security.sanitise(cookie.getValue(), false); // Get and sanitise string value
                        }
                    }
                }
                // If no session cookie, check for session parameter in URL
                if (id == null) {
                    id = Security.sanitise(request.getParameter("id"), false);
                }

                Security.endSession(id); // End session by calling to destroying user-id association
            }

            // Add session ID cookie to test if client has cookies enabled (cookie
            // is searched for in subsequent pages.
            response.addCookie(new Cookie("id", ""));

            // Get address of intended location (before client was forwarded to login 
            // page) for use when user is verified
            String address = Security.sanitise((String) request.getAttribute("address"), true);

            // If no particular page was requested, set to default (index.jsp)
            if (address.equals("")) {
                address = "index.jsp";
            }

            // If user submitted parameters for intended page, retrieve them and 
            // add them (except username/passwords)
            if (!request.getParameterMap().isEmpty()) {
                address += "?"; // Add initial character seperating URL with parameters

                // Cycle through each parameter in parameter map
                for (Entry<String, String[]> entry : request.getParameterMap().entrySet()) // Check if username or password in request (do not include them)
                {
                    if (!entry.getKey().equals("username") && !entry.getKey().equals("password")) {
                        address += String.format("%s=%s&", Security.sanitise(entry.getKey(), false), Security.sanitise(entry.getValue()[0], false));
                    }
                }

                address = address.substring(0, address.length() - 1); // Truncate last '&' character
            }
        %>

        <div class="main-body">
            <header>
                <div id="logo">Distributed Systems Project III</div>
            </header>
            <div class="big-wrapper" id="login-container">
                <div id="login-image">
                </div>
                <form id="login-fields" name="login" action="<%= address%>" method="POST">
                    <ol>
                        <li><input type="text" class="login-text-field" placeholder="Username" name="username"></li>
                        <li><input type="password" class="login-text-field" placeholder="Password" name="password"></li>
                        <li>
                        <center>
                            <input type="submit" value="Login"> 
                            <%
                                // Check if user arrived at this page by entering invalid details
                                String invalidLogin = (String) request.getAttribute("invalid-login");
                                // If user previous entered invalid details, display error message 
                                if (invalidLogin != null && invalidLogin.equals("true")) {
                                    out.println("<span class='error-message'>Invalid login! Bears "
                                            + "are now flocking to your location.</span>");
                                }
                            %>
                        </center>
                        </li>
                    </ol>
                </form>
            </div>
        </div>
    </body>
</html>