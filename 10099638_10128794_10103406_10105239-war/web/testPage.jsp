<%-- 
    Document   : testPage
    Created on : Apr 22, 2014, 1:31:48 PM
    Author     : daradermody
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="shoppingCartBeanTest" class="interactionBeans.shoppingCartBeanTest" /> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <% // Get shopping cart
            shoppingCartBean.cancel();
            shoppingCartBeanTest a1 = new shoppingCartBeanTest();
            ShoppingCart cart = (ShoppingCart) session.
                    getAttribute("cart");
            // If the user has no cart, create a new one
            if (cart == null) {
                cart = new ShoppingCart();
                session.setAttribute("cart", cart);
            }
        %> 
    </body>
</html>
