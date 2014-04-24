/* 
 * Group:       Niko Flores (10103406), Emma Foley (10105239), Dara Dermody (10099638), Patrick O'Keeffe (10128794)
 * Module:      Distributed Systems 2
 *      Code:   CE4208
 * Lecturer:    Reiner Dojen
 * Date:        25 April 2014
 *
 * Project:     Online Shop Application using Enterprise JavaBeans and Entity Classes
 *      Number: 3
 */
package interactionBeans;

import dbEntities.Product;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import javax.ejb.Remove;

/**
 * Shopping Cart EJB based off module code example.
 * 
 * @author reiner
 * @author Emma Foley 10105239
 * @author Dara Dermody 10099638
 * @author Niko Flores 10103406
 * @author Patrick O Keeffe 10128794
 */
public class shoppingCartBean {

    private HashMap<Product, Integer> items = new HashMap<>();

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

    /**
     * Prints a list of items and quantities in the shopping Cart.
     * @return 
     */
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
     * Method to return (up to) 5 items from the shopping cart.
     * @return HashMap of the chosen items.
     */
    public HashMap<Product,Integer> get5Items(){
        if (items.size() <= 5){
            return items;
        }
        else{
            HashMap<Product,Integer> hm = new HashMap<>();
            Set<Product> keys = items.keySet();
            Iterator<Product> it = keys.iterator();
            Product p;

            while (hm.size()<5 ){
                p = it.next();
                hm.put(p,items.get(p));
            }
            return hm; 
       }
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
