<%-- 
 
   Group:       Niko Flores (10103406), Emma Foley (10105239), Dara Dermody (10099638), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        25 April 2014
 
   Project:     Online Shop Application using Enterprise JavaBeans and Entity Classes
        Number: 3

--%>
<%@page import="mainPackage.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta name="description" content="Website for online shop application using EJB, entity classes and servlets/JSP/HTML for Distributed Systems Project III">
        <meta name="keywords" content="java distributed systems project online shop application enterprise java beans entity classes servlet jsp html">

        <link rel="stylesheet" type="text/css" href="style.css" />
    </head>
    <body>
        <%
            /**
             * Security sec = new Security(); // Check session ID, or username
             * and password; if it fails, forward to login String[] userInfo =
             * sec.authoriseRequest(request); String isAdmin = userInfo[2]; //
             * Set to more convenient variable
             */
            // Uncomment above and delete below after initial testing!
            String isAdmin = "true";
        %>
        
        <header>
            <span id="logo">Distributed Systems Project III</span>
            <form name="logOut" action="login.jsp" method="POST">
                <input type="hidden" name="log-out" value="true">
                <input type="submit" class="header-button" value="Log Out">
            </form>
            <form name="home" action="index.jsp" method="POST">
                <input type="submit" class="header-button" value="Browse">
            </form>

            <% if (isAdmin == "true") {
            %>
            <form name="newProduct" action="addProduct.jsp" method="POST">
                <input type="submit" class="header-button" value="Add Product">
            </form>
            <% }%>

        </header>
        <form name="search" action="searchResults.jsp" method="POST">
            <table class="searchbar">
                <tr class="searchRow">
                    <td class="searchCell">
                        <textarea class="searchText" name="searchKeywords"></textarea>
                    </td>
                    <td class="searchCell" align="left">
                        Search by:<select name="searchBy">
                            <option value ="ID">ID</option>
                            <option value="name">Name</option>
                        </select>
                        <input id="search-button" type="submit" value="Search">
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>