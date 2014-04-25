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
import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

/**
 * EJB for interacting with the Customer DB entity, calls named queries and checks password.
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
     * @param username The username
     * @return The corresponding password
     */
    @Override
    public String getPassword(String username) {
        String password = null;
        
        Query q = em.createNamedQuery("Customer.findByUsername");
        q.setParameter("username", username);
        
        try {
            Customer c = (Customer) q.getSingleResult();
            password = c.getPassword();
        } catch(NoResultException e) {
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
     * @return Boolean that indicates whether the username and password combination
     * is valid
     */
    @Override
     public boolean verifyPassword(String username, String password) {
        return password.equals(getPassword(username));
    }
     
    /**
     * Returns list of all customers in database
     * @return List of all Customer objects in database
     */
    @Override
    public List<Customer> findAllCustomers() {
        Query q = em.createNamedQuery("Customer.findAll");
        return q.getResultList();
    }

    @Override
    public boolean exists(String username){
        Query q = em.createNamedQuery("Customer.findByUsername");
        q.setParameter("username", username);
        
        return q.getResultList().size()==1;
    }
    
    @Override
    public Customer findByUsername(String username){
        Query q = em.createNamedQuery("Customer.findByUsername");
        q.setParameter("username", username);
        
        Customer c = null;
        try {
            c = (Customer) q.getSingleResult();
        } catch(NoResultException e) {
            e.printStackTrace();
        }
        return c;
        
    }

    @Override
    public void persist(Object object) {
        em.persist(object);
    }
}
