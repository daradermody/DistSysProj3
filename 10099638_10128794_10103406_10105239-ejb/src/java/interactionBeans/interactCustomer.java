/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package interactionBeans;

import dbEntities.Customer;
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
public class interactCustomer {
    @PersistenceContext(unitName = "10099638_10128794_10103406_10105239-ejbPU")
    private EntityManager em;

    /**
     * Get the password matching a given username.
     * @param username The username
     * @return The corresponding password
     */
    public String getPassword(String username){
        Query q = em.createNamedQuery("Customer.findByUsername");
        q.setParameter("username", username);
        
        Customer c = (Customer) q.getSingleResult();
        return c.getPassword();
    }
    
    /**
     * Constructor to create a user with the given username and password. Other
     * attributes are generated.
     *
     * @param usnm the name for the new user
     * @param password the user's password
     * @return Boolean that indicates whether the username and password combination
     * is valid
     */
     public boolean verifyPassword(String usnm, String password) {
        
        return getPassword(usnm).equals(password);
    }


    public void persist(Object object) {
        em.persist(object);
    }
}
