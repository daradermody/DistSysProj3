<%-- sadf
    Docum ent   : testPage
    Created on : Apr 22, 2014, 1:31:48 PM
    Author     : daradermody
--%>

<%@page import="interactionBeans.shoppingCartBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="shoppingCartBean" class="interactionBeans.shoppingCartBean" /> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <% // Get shopping cart
            shoppingCartBean a1 = new shoppingCartBean();
            shoppingCartBean cart = (shoppingCartBean) session.
                    getAttribute("cart");
            // If the user has no cart, create a new one
            if (cart == null) {
                cart = new shoppingCartBean();
                session.setAttribute("cart", cart);
            }
        %> 
    </body>
</html>
