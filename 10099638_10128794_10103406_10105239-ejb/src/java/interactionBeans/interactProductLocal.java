/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package interactionBeans;

import dbEntities.Comments;
import dbEntities.Customer;
import dbEntities.Product;
import java.util.List;

/**
 *
 * @author root
 */
public interface interactProductLocal {
    /**
     * Facility to fulfill the required user action of adding a product. (Admin
     * only -- which will be taken care of front-end)
     *
     * @param title The product name
     * @param description The product description
     * @param quantity An initial quantity of the product
     * @param price The price for which the product will be sold
     * @param imagepath A path to an image of the product.
     * @param summary A brief summary of the item.
     */
    public void addProduct(String title, String description, int quantity, int price, String imagepath, String summary);

    /**
     * Removes the given product from the database. 
     * The product can be uniquely identified by it's id, <br />
     * ensuring that only one item will be deleted at a time. <br />
     * The removeByID query is used.
     *
     * @param id The id of the product that is to be removed.
     */
    public void removeProduct(int id);

    /**
     * Searches a product by its ID. Required user action.
     *
     * @param pid The product ID
     * @return The product with the given ID.
     */
    public Product searchByID(int pid);


    /**
     * Returns list of all products in database
     * @return List of all Product objects in database
     */
    public List<Product> findAllProducts();

    /**
     * Increases quantity of products in store for particular product
     * @param pid Identification of product to increase quantity of
     * @param amount Increase value of quantity
     * @return Boolean value that indicates if operation was successful
     */
    public boolean increaseQuantity(int pid, int amount);

    /**
     * Wrapper method for reducing the available number of items.
     * Calls the updateQuantity() method to subtract from the total quantity. 
     * @param pid
     * @param amount
     * @return True if the action was successful, false if there is insufficient stock.
     */
    public boolean reduceQuantity(int pid, int amount);

    /**
     * Updates the quantity of a product. Required (admin) action.
     *
     * @param pid The productID
     * @param diff The number of items (+ve for buying, -ve for adding stock)
     * @return True if the update was successful, false if there was
     * insufficient stock.
     */
    public boolean updateQuantity(int pid, int diff);

    /**
     * Returns products matching the description. Allows the user to search for
     * a product based on a keyword. The Product(s) returned contain the keyword
     * in their description, summary or title.
     *
     * @param kw Keyword string to search for
     * @return A list of products matching the keywords
     */
    public List<Product> searchProductByKeyword(String kw);

    /**
     * Add a comment using references (Product, Customer objects)
     *
     * @param prod The Product that the comment is about
     * @param cust the Customer that posted the Comment
     * @param content The content of the post.
     */
    public void addComment(Product prod, Customer cust, String content);

    /**
     * Returns a List of Comments associated with the product.
     * Calls the Comments.findByProduct named query.
     * @param pid
     * @return Comments for the Product
     */
    public List<Comments> getComments(int pid);

    /**
     * Wrapper for the enitity manager persist method which basically adds an object to the database.
     * @param object 
     */
    public void persist(Object object);
    
    /**
     * Returns the total number of Products in the database.
     * @return The number of entries in the table database 
     */
    public int getNumberOfProducts();
}
