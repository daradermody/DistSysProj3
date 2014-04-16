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
        <img src="images/Pokeball.gif" alt="Pokeball" width="64" height="50">
    </body>
</html>
