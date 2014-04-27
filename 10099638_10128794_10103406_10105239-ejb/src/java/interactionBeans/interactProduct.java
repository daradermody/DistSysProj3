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

import dbEntities.Comments;
import dbEntities.Customer;
import dbEntities.Product;
import java.util.List;
import java.util.Queue;
import javax.ejb.Stateless;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.QueueConnection;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueReceiver;
import javax.jms.QueueSender;
import javax.jms.QueueSession;
import javax.jms.TextMessage;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

/**
 * EJB for Product interaction
 *
 * Main EJB used, as the application is focused on browsing products. Calls
 * named queries and retrieves information about products.
 *
 * @author Emma Foley 10105239
 * @author Dara Dermody 10099638
 * @author Niko Flores 10103406
 * @author Patrick O Keeffe 10128794
 */
@Stateless
public class interactProduct implements interactProductLocal {
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
    @Override
    public void addProduct(String title, String description, int quantity, int price, String imagepath, String summary) {
        // Create query to count all products in database
        Query q = em.createNamedQuery("Product.countAll");
        
        // Convert result to integer
        int id = Integer.valueOf(q.getSingleResult().toString());
        // Find ID that is not in use
        while( idExists(id) ){
            id +=1;
        }
        
        // Create product and set parameters with ID that is not being used
        Product p = new Product(id, title, quantity);
        p.setDescription(description);
        p.setPrice((long) price);
        p.setImage(imagepath);
        p.setSummary(summary);

        persist(p); // Persist created product
    }

    /**
     * Method that checks if the given ID links to a product (i.e. the product 
     * exists in the database
     *
     * @param id ID to search database with
     * @return Boolean value indicating existence of product with given ID
     */
    @Override
    public boolean idExists(int id){
        // Create query to find product by ID
        Query q  = em.createNamedQuery("Product.findById");
        q.setParameter("id", id);
        return !q.getResultList().isEmpty();
    }
    
    /**
     * Removes the given product from the database. The product can be uniquely
     * identified by it's id, <br />
     * ensuring that only one item will be deleted at a time. <br />
     * The removeByID query is used.
     *
     * @param id The id of the product that is to be removed.
     */
    @Override
    public void removeProduct(int id) {
        // Create query to remove product
        Query q = em.createNamedQuery("Product.removeByID");
        q.setParameter("pid", id);
        
        q.executeUpdate(); // Execute query
    }

    /**
     * Searches a product by its ID. Required user action.
     *
     * @param pid The product ID
     * @return The product with the given ID.
     */
    @Override
    public Product searchByID(int pid) {
        List<Product> results;
        //@NamedQuery(name = "Product.findById", query = "SELECT p FROM Product p WHERE p.id = :id"),
        Query q = em.createNamedQuery("Product.findById");
        q.setParameter("id", pid);
        
        results = q.getResultList(); // Get results of query
        
        // Return the product with the given ID, or null if it is not found
        return (results.size() > 0) ? (Product) q.getResultList().get(0) : null;
    }

    /**
     * Returns list of all products in database
     *
     * @return List of all Product objects in database
     */
    @Override
    public List<Product> findAllProducts() {
        // Create query to return all products
        Query q = em.createNamedQuery("Product.findAll");
        return q.getResultList(); // Return list of all products
    }

    /**
     * Increases quantity of products in store for particular product
     *
     * @param pid Identification of product to increase quantity of
     * @param amount Increase value of quantity
     * @return Boolean value that indicates if operation was successful
     */
    @Override
    public boolean increaseQuantity(int pid, int amount) {
        return updateQuantity(pid, amount); // Call update quantity
    }

    /**
     * Wrapper method for reducing the available number of items. Calls the
     * updateQuantity() method to subtract from the total quantity.
     *
     * @param pid
     * @param amount
     * @return True if the action was successful, false if there is insufficient
     * stock.
     */
    @Override
    public boolean reduceQuantity(int pid, int amount) {
        return updateQuantity(pid, 0 - amount); // Call update quentity with minus value

    }

    /**
     * Updates the quantity of a product. Required (admin) action.
     *
     * @param pid The productID
     * @param diff The number of items (+ve for buying, -ve for adding stock)
     * @return True if the update was successful, false if there was
     * insufficient stock.
     */
    @Override
    public boolean updateQuantity(int pid, int diff) {
        boolean success = false; // Variable that holds satus of operation completion

        //First, check if the quanitity
        Query q = em.createNamedQuery("Product.findQuantityByID");
        q.setParameter("pid", pid);
        
        // Get result of query
        int quantity = (int) q.getSingleResult();

        // Check if resulting quantity of operation is valid (greater than zero)
        if ((quantity + diff) >= 0) {
            //Select the query 
            Query q2 = em.createNamedQuery("Product.updateStock");
            //set the parameters
            q2.setParameter("pid", pid);
            q2.setParameter("amt", quantity+diff);
            q2.executeUpdate(); //The query is executed
            
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
    @Override
    public List<Product> searchProductByKeyword(String kw) {
        // Create query to find customer object with given keyword
        Query q = em.createNamedQuery("Product.findByKeyword");
        q.setParameter("kw", "%"+kw+"%");

        return q.getResultList(); // Return list of results
    }

    /**
     * Add a comment using references (Product, Customer objects)
     *
     * @param prod The Product that the comment is about
     * @param cust the Customer that posted the Comment
     * @param content The content of the post.
     */
    @Override
    public void addComment(Product prod, Customer cust, String content) {
        // Create query to count all products in database
        Query q = em.createNamedQuery("Comments.countAll");
        
        // Get result and convert to integer
        int id = Integer.valueOf(q.getSingleResult().toString());
        
        // Find ID that is not currently in use
        while( commentIdExists(id) ){
            id +=1;
        }
        
        // Create comment object with ID that is not already used
        Comments comm = new Comments(id, content, cust.getUsername(), prod.getId());
        em.persist(comm); // Persist comment object
    }

    /**
     * Method that checks if a comment with the user specified ID exists in the 
     * database
     *
     * @param id ID of comment to look for
     * @return Boolean value indicating the existence of the comment with the 
     * given ID
     */
    @Override
    public boolean commentIdExists(int id){
        // Create query for looking for comment with specified ID in database
        Query q  = em.createNamedQuery("Comments.findById");
        q.setParameter("id", id);
        return !q.getResultList().isEmpty();
    }
    
    /**
     * Returns a List of Comments associated with the product. Calls the
     * Comments.findByProduct named query.
     *
     * @param pid Product ID of the product to get comments for
     * @return Comments for the Product
     */
    @Override
    public List<Comments> getComments(int pid) {
        // Create query for finding comments with specific product ID
        Query q = em.createNamedQuery("Comments.findByProduct");
        q.setParameter("product", pid);

        return q.getResultList(); // Return list of comments produced by the query
    }


    /**
     * Returns the total number of Products in the database.
     *
     * @return The number of entries in the table database
     */
    @Override
    public int getNumberOfProducts() {
        // Create query that counts all products
        Query q = em.createNamedQuery("Product.countAll");
        return q.getFirstResult(); // Return number of products in database
    }

    /**
     * Wrapper for the enitity manager persist method which basically adds an object to the database.
     * 
     * @param object 
     */
    @Override
    public void persist(Object object) {
        em.persist(object); // persist given object
    }
    
    
    /******************************************************************\
     *                    Message-Driven Bean Methods                  |
    \******************************************************************/
    
    /* COMMENTED OUT DUE TO CAUSATION OF ERRORS

    static final int N = 10;

    QueueConnection conn;
    QueueSession session;
    Queue queA;
    Queue queB;
    
    public void setupPTP() {
        try {
            InitialContext iniCtx = new InitialContext();
            Object tmp = iniCtx.lookup("ConnectionFactory");
            QueueConnectionFactory qcf = (QueueConnectionFactory) tmp;
            conn = qcf.createQueueConnection();
            queA = (Queue) iniCtx.lookup("queue/A");
            queB = (Queue) iniCtx.lookup("queue/B");
            session = conn.createQueueSession(false, QueueSession.AUTO_ACKNOWLEDGE);
            conn.start();
        } catch(JMSException | NamingException e) {
            System.out.println("JMS or NamingException: ");
            e.printStackTrace();
        }
    }
    
    public void sendRecvAsync(String textBase) {
        
        System.out.println("Begin sendRecvAsync");

        // Setup the PTP connection, session
        setupPTP();

        try {
            // Set the async listener for queA
            QueueReceiver recv = session.createReceiver((javax.jms.Queue) queA);
            recv.setMessageListener(new MessageBean());

            // Send a few text msgs to queB
            QueueSender send = session.createSender((javax.jms.Queue) queB);

            for(int m = 0; m < 10; m ++) {
                TextMessage tm = session.createTextMessage(textBase+"#"+m);
                tm.setJMSReplyTo((Destination) queA);
                send.send(tm);
                System.out.println("sendRecvAsync, sent text=" + tm.getText());
            }
        } catch(JMSException e) {
            System.out.println("JMS Exception: ");
            e.printStackTrace();
        }
        
        System.out.println("End sendRecvAsync");
    }
    
    public void stop() {
        try {
            conn.stop();
            session.close();
            conn.close();
        } catch(JMSException e) {
            System.out.println("JMS Exception: ");
            e.printStackTrace();
        }
    }
    */
    
}

