<%-- 
 
   Group:       Niko Flores (10103406), Emma Foley (10105239), Dara Dermody (10099638), Patrick O'Keeffe (10128794)
   Module:      Distributed Systems 2
        Code:   CE4208
   Lecturer:    Reiner Dojen
   Date:        25 April 2014
 
   Project:     Online Shop Application using Enterprise JavaBeans and Entity Classes
        Number: 3

--%>

<%@page import="mainPackage.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="/errorPage.jsp" %>
<jsp:include page="/header.jsp" />

<!DOCTYPE html>
<html>
    <head>
        <title>New Product</title>
        <link rel="stylesheet" type="text/css" href="style.css" />
    </head>

    <body>


        <div class="main-body">
            <form name="newProduct" method="POST" action="index.jsp">
                <div class="big-wrapper message-container">
                    <table>
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td>
                                            <div id="product-name-container">
                                                Name: <input type="text" id="product-title" name="productName">
                                            </div>
                                        </td>
                                        <td>
                                            <div id="product-price-container">
                                                Price: <input type="number" id="product-price" name="productPrice">
                                            </div>
                                        </td>
                                        <td>
                                            <div id="product-amount-container">
                                                Amount: <input type="number" id="product-amount" name="productAmount">
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <form action="upload" method="POST" enctype="multipart/form-data"/>
                                <input type="file" name="productImage">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="product-summary-container">
                                    Summary: <input type="text" id="product-summary" name="productSummary">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="product-description-container">
                                    Description: <textarea class="product-description" name="productDescription"></textarea>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <input id="submit-button" type="submit" value="Add Product">
            </form>
        </div>
    </body>
</html>
