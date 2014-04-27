
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
import java.util.Queue;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.Remove;
import javax.ejb.Stateful;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.QueueConnection;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueReceiver;
import javax.jms.QueueSender;
import javax.jms.QueueSession;
import javax.jms.TextMessage;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.transaction.UserTransaction;

/**
 * Shopping Cart EJB based off module code example.
 *
 * @author reiner
 * @author Emma Foley 10105239
 * @author Dara Dermody 10099638
 * @author Niko Flores 10103406
 * @author Patrick O Keeffe 10128794
 */

@Stateful
public class shoppingCartBean implements shoppingCart {

    @PersistenceContext(unitName = "10099638_10128794_10103406_10105239-ejbPU")
    private EntityManager em;

    private HashMap<Product, Integer> items = new HashMap<>();

    /**
     * Add an item to the cart. Modified from samples.
     *
     * @param p The product to add
     * @param quantity
     */
    @Override
    public void addItem(Product p, int quantity) {
        // obtain current number of items in cart
        Integer orderQuantity = items.get(p);
        if (orderQuantity == null) {
            orderQuantity = 0;
        }
        // adjust quantity and put back to cart
        orderQuantity += quantity;
        items.put(p, orderQuantity);
        //sendRecvAsync("Adding item"); stop(); // MESSAGE DRIVEN BEAN COMMENTED OUT
    }

    /**
     * Remove an item from the cart. Modified from the examples.
     *
     * @param p The item to be removed
     * @param quantity The quantity of the item to be removed.
     */
    @Override
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
        
        //sendRecvAsync("Removing item"); stop(); // MESSAGE DRIVEN BEAN COMMENTED OUT

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
        int quantity = (int) q.getSingleResult();
        // the quantity must be greater than the requested amount
        //requested amount is +ve => adding stock -> no theoretical limit
        
        if ((quantity + diff) > 0) {
            //Select the query 
            Query q2 = em.createNamedQuery("Product.updateStock");
            //set the parameters
            q2.setParameter("pid", pid);
            q2.setParameter("amt", quantity+diff);
            q2.executeUpdate();
            //The query was run!
            success = true;
        }
        //sendRecvAsync("Updating quantity"); stop(); // MESSAGE DRIVEN BEAN COMMENTED OUT
        
        return success;
    }

    /**
     * Method that is used to logout user and remove items in shopping cart
     */
    @Remove
    @Override
    public void logout(){
        cancel(); //empty the cart and destroy when the user logs out
        //sendRecvAsync("Loging out"); stop(); // MESSAGE DRIVEN BEAN COMMENTED OUT
    }
    
    /**
     * Method that removes products from the shopping cart and restores the 
     * quantity values in the database of products
     *
     */
    @Override
    public void cancel() {
        // no action required - annotation @Remove indicates
        // that calling this method should remove the EJB which will
        // automatically destroy instance variables
        Set<dbEntities.Product> setOfKeys = items.keySet();
        Iterator<dbEntities.Product> iter = setOfKeys.iterator();
        dbEntities.Product prod;

        while (iter.hasNext()) {
            prod = iter.next(); //gets teh product in the cart
            int amountInCart = items.get(prod);//gets the quantity of prod that were in the cart
            //productNamesDumped.add(prod.getTitle());
            //add the items back to the database
            updateQuantity(prod.getId(), amountInCart);
            System.out.println("Product ID: " + prod.getId());
            System.out.println("Amount in Cart: " + amountInCart);
            items.remove(prod);
            
        }
        //sendRecvAsync("Cancelling"); stop(); // MESSAGE DRIVEN BEAN COMMENTED OUT
    }

    /**
     * Prints a list of items and quantities in the shopping Cart.
     *
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
        //sendRecvAsync("Printing item list"); stop(); // MESSAGE DRIVEN BEAN COMMENTED OUT
        return message;
    }

    /**
     * Method to return (up to) 5 items from the shopping cart.
     *
     * @return HashMap of the chosen items.
     */
    @Override
    public HashMap<Product,Integer> get5Items(){
        if (items.size() <= 5){

            return items;
        } else {
            HashMap<Product, Integer> hm = new HashMap<>();
            Set<Product> keys = items.keySet();
            Iterator<Product> it = keys.iterator();
            Product p;

            while (hm.size() < 5) {
                p = it.next();
                hm.put(p, items.get(p));
            }
            //sendRecvAsync("Getting five items in cart"); stop(); // MESSAGE DRIVEN BEAN COMMENTED OUT
            return hm;
        }
    }

    /**
     * Get the total value of goods in cart.
     *
     * @return The total price of the goods
     */
    @Override
    public double getTotal() {
        double total = 0;
        Set<Product> keys = items.keySet();
        Iterator<Product> it = keys.iterator();
        Product curr;
        while (it.hasNext()) {
            curr = it.next();
            total += curr.getPrice() * items.get(curr);
        }
        //sendRecvAsync("Getting total cost"); stop(); // MESSAGE DRIVEN BEAN COMMENTED OUT
        return total;
    }

    /**
     * Method that returns items in the shopping cart
     *
     * @return Map (product:quantity) of products in shopping cart
     */
    @Override
    public HashMap<Product, Integer> getItems() {
        return this.items;
        //sendRecvAsync("Getting items in cart"); stop(); // MESSAGE DRIVEN BEAN COMMENTED OUT
    }

    /**
     * Checkout method that just returns message for successful checkout
     *
     * @return
     */
    @Override
    public String checkout() {
        // Create message to return
        String message = "You checked out the following items:\n<br />"
                + printItemList() + "<br />Total cost is: " + getTotal();

        Set<dbEntities.Product> keys = items.keySet();
        Iterator<dbEntities.Product> it = keys.iterator();
        dbEntities.Product p;

        // Cycle through all products in shopping cart and remove items from database
        for (int i = 0; i < items.size(); i++) {
            p = it.next();
            removeItem(p, p.getQuantity());
        }
        //sendRecvAsync("checking out"); stop(); // MESSAGE DRIVEN BEAN COMMENTED OUT
        return message;
    }

    /**
     * Persist method
     *
     * @param object Object to persist
     */
    @Override
    public void persist(Object object) {
        /* Add this to the deployment descriptor of this module (e.g. web.xml, ejb-jar.xml):
         * <persistence-context-ref>
         * <persistence-context-ref-name>persistence/LogicalName</persistence-context-ref-name>
         * <persistence-unit-name>10099638_10128794_10103406_10105239-ejbPU</persistence-unit-name>
         * </persistence-context-ref>
         * <resource-ref>
         * <res-ref-name>UserTransaction</res-ref-name>
         * <res-type>javax.transaction.UserTransaction</res-type>
         * <res-auth>Container</res-auth>
         * </resource-ref> */
        try {
            Context ctx = new InitialContext();
            UserTransaction utx = (UserTransaction) ctx.lookup("java:comp/env/UserTransaction");
            utx.begin();
            em = (EntityManager) ctx.lookup("java:comp/env/persistence/LogicalName");
            em.persist(object);
            utx.commit();
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", e);
            throw new RuntimeException(e);
        }
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
