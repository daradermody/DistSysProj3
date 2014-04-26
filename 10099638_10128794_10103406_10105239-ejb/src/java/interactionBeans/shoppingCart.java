/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package interactionBeans;

import dbEntities.Product;
import java.util.HashMap;
import javax.ejb.Remove;

/**
 *
 * @author root
 */
public interface shoppingCart {
    /**
     * Add an item to the cart. Modified from samples.
     *
     * @param p The product to add
     * @param quantity
     */
    public void addItem(Product p, int quantity);

    /**
     * Remove an item from the cart. Modified from the examples.
     *
     * @param p The item to be removed
     * @param quantity The quantity of the item to be removed.
     */
    public void removeItem(Product p, int quantity);

    /**
     * Updates the quantity of a product. Required (admin) action.
     *
     * @param pid The productID
     * @param diff The number of items (+ve for buying, -ve for adding stock)
     * @return True if the update was successful, false if there was
     * insufficient stock.
     */
    public boolean updateQuantity(int pid, int diff);
    
    
    @Remove
    public void cancel();
    
    /**
     * Prints a list of items and quantities in the shopping Cart.
     * @return 
     */
    public String printItemList();

    /**
     * Method to return (up to) 5 items from the shopping cart.
     * @return HashMap of the chosen items.
     */
    public HashMap<Product,Integer> get5Items();
    
    /**
     * Get the total value of goods in cart.
     *
     * @return The total price of the goods
     */
    public double getTotal();

    public HashMap<Product, Integer> getItems();

    @Remove
    //TODO: Update tables
    public String checkout();

    public void persist(Object object);
}
