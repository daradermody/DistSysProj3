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
import javax.ejb.Stateless;
import javax.ejb.LocalBean;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

/**
 *
 * @author elfie
 */
@Stateless
@LocalBean
public class interactProduct {

    @PersistenceContext(unitName = "10099638_10128794_10103406_10105239-ejbPU")
    private EntityManager em;

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
    public void addProduct(String title, String description, int quantity, int price, String imagepath, String summary) {
        Product p = new Product(title, description, quantity, price, imagepath, summary);
        persist(p);
    }

    /**
     * Removes the given product from the database. The product can be uniquely
     * identified by it's id, <br />
     * ensuring that only one item will be deleted at a time. <br />
     * The removeByID query is used.
     *
     * @param id The id of the product that is to be removed.
     */
    public void removeProduct(int id) {
        Query q = em.createNamedQuery("Product.removeByID");
        q.setParameter("id", id);
    }

    /**
     * Searches a product by its ID. Required user action.
     *
     * @param pid The product ID
     * @return The product with the given ID.
     */
    public Product searchByID(int pid) {
        //@NamedQuery(name = "Product.findById", query = "SELECT p FROM Product p WHERE p.id = :id"),
        Query q = em.createNamedQuery("Product.findById");
        q.setParameter("id", pid);

        return (Product) q.getSingleResult();
    }

    //@NamedQuery(name = "Product.findAll", query = "SELECT p FROM Product p"),
    /**
     * Returns list of all products in database
     * @return List of all Product objects in database
     */
    public List<Product> findAllProducts() {
        Query q = em.createNamedQuery("Product.findAll");
        return q.getResultList();
    }

    /**
     * Increases quantity of products in store for particular product
     * @param pid Identification of product to increase quantity of
     * @param amount Increase value of quantity
     * @return Boolean value that indicates if operation was successful
     */
    public boolean increaseQuantity(int pid, int amount) {
        return updateQuantity(pid, amount);
    }

    /**
     * Wrapper method for reducing the available number of items.
     * Calls the updateQuantity() method to subtract from the total quantity. 
     * @param pid
     * @param amount
     * @return True if the action was successful, false if there is insufficient stock.
     */
    public boolean reduceQuantity(int pid, int amount) {
        return updateQuantity(pid, 0 - amount);

    }

    /**
     * Updates the quantity of a product. Required (admin) action.
     *
     * @param pid The productID
     * @param diff The number of items (+ve for buying, -ve for adding stock)
     * @return True if the update was successful, false if there was
     * insufficient stock.
     */
    public boolean updateQuantity(int pid, int diff) {
        boolean success = false; // Variable that holds satus of operation completion
        
        //First, check if the quanitity
        Query q = em.createNamedQuery("Product.findQuantityByID");
        q.setParameter("pid", pid);
        int quantity = q.getFirstResult();
        // the quantity must be greater than the requested amount
        //requested amount is +ve => adding stock -> no theoretical limit
        if (quantity >= Math.abs(diff) || diff > 0) {
            //Select the query 
            Query q2 = em.createNamedQuery("Product.updateStock");
            //set the parameters
            q2.setParameter("pid", pid);
            q2.setParameter("amt", diff);
            //The query was run!
            success = true;
        }
        
        return success;
    }

    /**
     * Returns products matching the description. Allows the user to search for
     * a product based on a keyword. The Product(s) returned contain the keyword
     * in their description, summary or title.
     *
     * @param kw Keyword string to search for
     * @return A list of products matching the keywords
     */
    public List<Product> searchProductByKeyword(String kw) {
        Query q = em.createNamedQuery("Product.findByKeyword");
        q.setParameter("kw", kw);

        return q.getResultList();
    }

    //TODO: Verify (peer review) addition calls of comment to product
    /**
     * Add a comment using references (Product, Customer objects)
     *
     * @param prod The Product that the comment is about
     * @param cust the Customer that posted the Comment
     * @param content The content of the post.
     */
    public void addComment(Product prod, Customer cust, String content) {

        Comments comm = new Comments(prod, cust, content);
        em.persist(comm);
        //not needed because of table relations
        //Product c1 = searchByID(prod.getId());
        //this is not needed: 
        //c1.addToCommentsCollection(comm);
    }

    // @NamedQuery(name = "Comments.findByProduct", query = "SELECT c FROM Comments c WHERE c.product = :id"),
    public List<Comments> getComments(int pid) {
        Query q = em.createNamedQuery("Comments.findByProduct");
        q.setParameter("pid", pid);

        return q.getResultList();
    }

    public void persist(Object object) {
        em.persist(object);
    }
    
    public int getNumberOfProducts(){
        Query q = em.createNamedQuery("Product.countAll");
        return q.getFirstResult();
    }

}
