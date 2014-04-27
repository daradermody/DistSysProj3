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
import javax.ejb.*;

/**
 * Enterprise JavaBean interface used for interacting with customer data in database
 *
 * @author Emma Foley 10105239
 * @author Dara Dermody 10099638
 * @author Niko Flores 10103406
 * @author Patrick O Keeffe 10128794
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

    /**
     * Method that checks if the user with the user specified username exists
     *
     * @param username Username to search for
     * @return Return boolean value indicating existence of user with specified username in database
     */
    public boolean exists(String username);

    /**
     * Method that gets the customer based on a given username
     *
     * @param username Username to search with
     * @return Customer object with same username as given username
     */
    public Customer findByUsername(String username);

    /**
     * Method that persists the object given
     *
     * @param object Object to persist
     */
    public void persist(Object object);
}
