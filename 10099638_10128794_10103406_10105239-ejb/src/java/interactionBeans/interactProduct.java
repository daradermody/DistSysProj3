/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package interactionBeans;

import dbEntities.Comments;
import dbEntities.Product;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.ejb.LocalBean;
import javax.persistence.EntityManager;
import javax.persistence.NamedQuery;
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
    
    //add item
    //admin only -- front-end needs to check that
    public void addProduct(String title, String description, int quantity, int price, String imagepath, String summary){
        Product p = new Product(title, description, quantity, price, imagepath, summary);
        persist(p);
    }
    
    //remove item
    //@NamedQuery(name = "Product.removeByID", query = "DELETE FROM Product p WHERE p.id=:id")
    public void removeProduct(int id){
        Query q = em.createNamedQuery("Product.removeByID");
        q.setParameter("id", id);
    }
    
    public Product searchByID(int pid){
        //@NamedQuery(name = "Product.findById", query = "SELECT p FROM Product p WHERE p.id = :id"),
        Query q = em.createNamedQuery("Product.findById");
        q.setParameter("id", pid);
        
        return (Product) q.getSingleResult();
    }
    
    //update quantity
    /**
     * Updates the quantity of a product
     * @param pid The productID
     * @param diff The number of items (+ve for buying, -ve for adding stock)
     * @return True if the update was successful, false if there was insufficient stock.
     */
    public boolean updateQuantity(int pid, int diff){
        //First, check if the quanitity
        Query q = em.createNamedQuery("Product.findQuantityByID");
        q.setParameter("pid", pid);
        int quantity = q.getFirstResult();
        // the quantity must be greater than the requested amount
        //requested amount is -ve => adding stock
        // POSSIBLE BUG double -ve (--) becomes comment
        if (quantity >= diff || diff<0){
        //@NamedQuery(name = "Product.updateStock", query = "UPDATE Product SET quantity=(SELECT quantity FROM PRODUCT WHERE EMMA.PRODUCT.ID=:pid)-:amount WHERE id=:pid")
            Query q2 = em.createNamedQuery("Product.updateStock");
            q2.setParameter("pid", pid);
            q2.setParameter("amt", diff);
            return true;
        }
        else return false; // insufficient stock
    }
    
    
    //search
        //search whole table
        //search in title, description and summary 
    
    //addComment
    
    
    // @NamedQuery(name = "Comments.findByProduct", query = "SELECT c FROM Comments c WHERE c.product = :id"),
    public List<Comments> getComments(int pid){
        Query q = em.createNamedQuery("Comments.findByProduct");
        q.setParameter("pid", pid);
        
        return q.getResultList();
    }

    public void persist(Object object) {
        em.persist(object);
    }
    
    
}
