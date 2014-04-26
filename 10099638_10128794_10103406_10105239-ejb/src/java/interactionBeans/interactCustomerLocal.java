/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interactionBeans;

import dbEntities.Customer;
import java.util.List;
import javax.ejb.*;

/**
 *
 * @author root
 */
@Local
public interface interactCustomerLocal {

    /**
     * Get the password matching a given username.
     *
     * @param username The username
     * @return The corresponding password
     */
    public String getPassword(String username);

    /**
     * Constructor to create a user with the given username and password. Other
     * attributes are generated.
     *
     * @param username the name for the new user
     * @param password the user's password
     * @return Boolean that indicates whether the username and password
     * combination is valid
     */
    public boolean verifyPassword(String username, String password);

    /**
     * Returns list of all customers in database
     *
     * @return List of all Customer objects in database
     */
    public List<Customer> findAllCustomers();

    public boolean exists(String username);

    public Customer findByUsername(String username);

    public void persist(Object object);
}
