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
package mainPackage;

import java.util.ArrayList;

/**
 * A container for the products in the shop. Deals with creating and managing
 * shop products.
 *
 * @author Emma Foley 10105239
 * @author Dara Dermody 10099638
 * @author Niko Flores 10103406
 * @author Patrick O Keeffe 10128794
 */
@Deprecated
public class ShopListing {

    private static ArrayList<ShopProduct> products = new ArrayList<ShopProduct>();

    /**
     * Returns a product by index.
     *
     * @param index Index of the sought product
     * @return index-th product in the database if index <= number of products,
 null otherwise.
     */
    public static ShopProduct getProduct(int index) {
        return products.get(index);
    }

    /**
     * Create a new product, with the given title, and add it to the "board".
     *
     * @param title The name of the new product
     * @return the number of products in the board
     */
    public static int addProduct(String title) {
        products.add(new ShopProduct(title));
        return products.size();
    }

    public static int addProduct(ShopProduct t) {
        products.add(t);
        return products.size();
    }

    /**
     * Get the number of products
     *
     * @return number of products in a forum
     */
    public static int getNumberOfProducts() {
        return products.size();
    }

}
