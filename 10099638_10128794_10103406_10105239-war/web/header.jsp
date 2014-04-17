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
        <script type="text/javascript" src="way2blogging.org-tripleflap.js"></script>
        <script type="text/javascript">
            var twitterAccount = "Koalascense";
            var tweetThisText = "Koalascense - " + window.location.href;
            tripleflapInit();
        </script>
        <a id="tBird" href="https://twitter.com/Koalascense" target="_blank" style="display: block; position: absolute; left: 35px; top: 550px; width: 64px; height: 64px; background-image: url(http://2.bp.blogspot.com/_nDNgmK8FIyI/TTPu1fD8gwI/AAAAAAAAASk/umOvdnb827E/way2blogging.org-twitterbirdsprite.png); background-color: transparent; z-index: 947; background-position: 0px 0px; background-repeat: no-repeat no-repeat;"></a>

        <header>
            <span id="logo">Distributed Systems Project III</span>
            <form name="logOut" action="login.jsp" method="POST">
                <input type="hidden" name="log-out" value="true">
                <input type="submit" class="header-button" value="Log Out">
            </form>
            <form name="home" action="index.jsp" method="POST">
                <input type="submit" class="header-button" value="Browse">
            </form>
            <form name="newThread" action="addProduct.jsp" method="POST">
                <input type="submit" class="header-button" value="Add Product">
            </form>
        </header>

        <table class="searchbar">
            <tr class="searchRow">
                <td class="searchCell">
                    <textarea class="searchText"></textarea>  
                </td>
                <td class="searchCell" align="left">
                    <input id="search-button" type="submit" value="Search">
                </td>
            </tr>
        </table>
    </body>
</html>
