/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interactionBeans;

import dbEntities.Product;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import javax.ejb.Remove;

/**
 *
 * @author elfie
 * @author reiner
 */
public class shoppingCartBean {

    private HashMap<Product, Integer> items = new HashMap<Product, Integer>();

    /**
     * Add an item to the cart. Modified from samples.
     *
     * @param p The product to add
     * @param quantity
     */
    public void addItem(Product p, int quantity) {
        // obtain current number of items in cart
        Integer orderQuantity = items.get(p);
        if (orderQuantity == null) {
            orderQuantity = 0;
        }
        // adjust quantity and put back to cart
        orderQuantity += quantity;
        items.put(p, orderQuantity);
    }

    /**
     * Remove an item from the cart. Modified from the examples.
     *
     * @param p The item to be removed
     * @param quantity The quantity of the item to be removed.
     */
    public void removeItem(Product p, int quantity) {
        // obtain current number of items in cart
        Integer orderQuantity = items.get(p);
        if (orderQuantity == null) {
            orderQuantity = 0;
        }
        // adjust quantity and put back to cart
        orderQuantity -= quantity;
        if (orderQuantity <= 0) {
            // final quantity less equal 0 - remove from cart
            items.remove(p);
        } else {
            // final quantity > 0 - adjust quantity
            items.put(p, orderQuantity);
        }

    }

    @Remove
    public void cancel() {
        // no action required - annotation @Remove indicates
        // that calling this method should remove the EJB which will
        // automatically destroy instance variables
    }

    public String printItemList() {
        String message = "";
        Set<Product> keys = items.keySet();
        Iterator<Product> it = keys.iterator();
        Product k;
        while (it.hasNext()) {
            k = it.next();
            message += k.getTitle() + ", quantity: " + items.get(k) + "\n<br>";
        }
        return message;
    }

    /**
     * Get the total value of goods in cart.
     *
     * @return The total price of the goods
     */
    public double getTotal() {
        double total = 0;
        Set<Product> keys = items.keySet();
        Iterator<Product> it = keys.iterator();
        Product curr;
        while (it.hasNext()) {
            curr = it.next();
            total = curr.getPrice() * items.get(curr);
        }

        return total;
    }

    public HashMap<Product, Integer> getItems() {
        return this.items;
    }

    @Remove
    //TODO: Update tables
    public String checkout() {
        // dummy checkout method that just returns message for successful
        // checkout
        String message = "You checked out the following items:\n<br />"
                + printItemList() + "<br />Total cost is: " + getTotal();
        return message;
    }

}
