<%-- 
 
   Group:       Dara Dermody (10099638), Emma Foley (10105239), Niko Flores (10103406), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        07 April 2014
 
   Project:     Secure Authentication and Session Management System for a Web Application

--%>
<%@page import="mainPackage.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="/errorPage.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <title>New Thread</title>
        <meta name="description" content="Website for forum application for Distributed Systems Project II">
        <meta name="keywords" content="distributed systems project forum application java servlet security">

        <link rel="stylesheet" type="text/css" href="style.css" />
    </head>

    <body>
        <%
            // Check session ID, or username and password; if it fails, forward to login
            String[] userInfo = Security.authoriseRequest(request);
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
                    if(!navigator.cookieEnabled) // Check if cookies disabled
                        $(this).append('<input type="hidden" name="id" value="<%= id %>">');
                    return true;
                });
            });
        </script>

        
        <div class="main-body">
            <header>
              <span id="logo">Distributed Systems Project II</span>
                <form name="logOut" action="login.jsp" method="POST">
                    <input type="hidden" name="log-out" value="true">
                    <input type="submit" class="header-button" value="Log Out">
                </form>
                <form name="home" action="index.jsp" method="POST">
                    <input type="submit" class="header-button" value="Threads">
                </form>
            </header>

            <form name="newThread" method="POST" action="index.jsp">
                <div class="big-wrapper message-container">
                    <div id="thread-title-container">
                        Title of thread: <input type="text" id="thread-title" name="threadName">
                    </div>
                    <textarea class="message new-thread" name="threadBody"></textarea>
                    <input id="submit-button" type="submit" value="Create">
                </div>
            </form>
        </div>
    </body>
</html>
