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

import dbEntities.Customer;
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
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

/**
 * EJB for interacting with the Customer DB entity, calls named queries and
 * checks password.
 *
 * @author Emma Foley 10105239
 * @author Dara Dermody 10099638
 * @author Niko Flores 10103406
 * @author Patrick O Keeffe 10128794
 */
@Stateless
public class interactCustomer implements interactCustomerLocal {

    @PersistenceContext(unitName = "10099638_10128794_10103406_10105239-ejbPU")
    private EntityManager em;

    /**
     * Get the password matching a given username.
     *
     * @param username The username of the user
     * @return The corresponding password of the user
     */
    @Override
    public String getPassword(String username) {
        String password = null;

        // Create query to find customer object
        Query q = em.createNamedQuery("Customer.findByUsername");
        q.setParameter("username", username);

        try {
            // Get result of customer search and get associated password
            Customer c = (Customer) q.getSingleResult();
            password = c.getPassword();
        } catch (NoResultException e) {
            e.printStackTrace();
        }

        return password;
    }

    /**
     * Constructor to create a user with the given username and password. Other
     * attributes are generated.
     *
     * @param username the name for the new user
     * @param password the user's password
     * @return Boolean that indicates whether the username and password
     * combination is valid
     */
    @Override
    public boolean verifyPassword(String username, String password) {
        // Return a comparison between the password given and the password of the username given
        return password.equals(getPassword(username));
    }

    /**
     * Returns list of all customers in database
     *
     * @return List of all Customer objects in database
     */
    @Override
    public List<Customer> findAllCustomers() {
        // Create query to find all customers
        Query q = em.createNamedQuery("Customer.findAll");
        return q.getResultList();
    }

    /**
     * Method that checks if the user with the user specified username exists
     *
     * @param username Username to search for
     * @return Return boolean value indicating existence of user with specified username in database
     */
    @Override
    public boolean exists(String username) {
        // Create query to find customer with given username
        Query q = em.createNamedQuery("Customer.findByUsername");
        q.setParameter("username", username);

        // Return true if result list is not empty
        return !q.getResultList().isEmpty();
    }

    /**
     * Method that finds customer based on user supplied username
     *
     * @param username Username of the customer object being searched for
     * @return Customer object that has the username given
     */
    @Override
    public Customer findByUsername(String username) {
        // Create query for searching by username
        Query q = em.createNamedQuery("Customer.findByUsername");
        q.setParameter("username", username);

        Customer c = null;
        
        try {
            // Get results of database search
            c = (Customer) q.getSingleResult();
        } catch (NoResultException e) {
            e.printStackTrace();
        }
        return c;

    }

    /**
     * Method that persists the object given
     *
     * @param object Object to persist
     */
    @Override
    public void persist(Object object) {
        em.persist(object);
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
