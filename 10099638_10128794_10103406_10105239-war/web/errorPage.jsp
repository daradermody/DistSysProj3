<%-- 
 
   Group:       Dara Dermody (10099638), Emma Foley (10105239), Niko Flores (10103406), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        07 April 2014
 
   Project:     Secure Authentication and Session Management System for a Web Application

--%>
<%@page import="mainPackage.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isErrorPage="true" %>
<html>
    <head>
        <title>Show Error Page</title>
    </head>
    <body>
        <h1>The computer says no!</h1>
        <table width="100%" border="1">
            <tr valign="top">
                <td width="40%"><b>Error:</b></td>
                <td>${pageContext.exception}</td>
            </tr>
            <tr valign="top">
                <td><b>URI:</b></td>
                <td>${pageContext.errorData.requestURI}</td>
            </tr>
            <tr valign="top">
                <td><b>Status code:</b></td>
                <td>${pageContext.errorData.statusCode}</td>
            </tr>      
        </table>
    </body>
</html>