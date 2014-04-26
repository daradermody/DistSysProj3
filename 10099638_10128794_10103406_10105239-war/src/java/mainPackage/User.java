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
package mainPackage;

import dbEntities.Customer;
import interactionBeans.shoppingCartBean;

/**
 * A User data type, containing the details of one user.
 *
 * @author Emma Foley 10105239
 * @author Dara Dermody 10099638
 * @author Niko Flores 10103406
 * @author Patrick O Keeffe 10128794
 */
public class User {

    private final Customer details;
    private String sessionID; //for security class
    private int sessionTime;
    private final boolean isAdmin;
    private shoppingCartBean shoppingCart;
    
    /**
     * Constructor to create a logged on user.
     *
     * An "isAdmin" boolean is not needed!
     *
     * @param c The "base" customer that will be associated with other user
     * attributes.
     * @param sessionID A session ID
     * @param sessionTime A session time
     */
    protected User(Customer c, String sessionID, int sessionTime) {
        this.shoppingCart = null;
        this.details = c;
        this.sessionID = sessionID;
        this.sessionTime = sessionTime;
        this.isAdmin = this.details.getIsadmin();
    }

    
    protected User() {
        this.details = null;
        this.sessionID = null;
        this.sessionTime = 0;
        this.isAdmin = false;
        this.shoppingCart = null;
    }
    

    /**
     * Getter for isAdmin attribute
     *
     * @return the boolean for administrative privileges
     */
    public boolean getIsAdmin(){

        return this.details.getIsadmin();
    }

    /**
     * Getter for username attribute
     *
     * @return the username
     */
    public String getUsername(){

        return this.details.getUsername();
    }

    /**
     * getter for the sessionTime attribute
     *
     * @return the sessionTime or null id the user is not logged in
     */
    public int getTimestamp() {
        return this.sessionTime;
    }

    /**
     * setter for the sessionTime attribute
     *
     * @param st
     */
    public void setTimestamp(int st) {
        this.sessionTime=st;

    }

    /**
     * getter for the sessionID attribute
     *
     * @return the session id or "" if the user is not logged in
     */
    public String getSessionID(){

        return this.sessionID;
    }

    /**
     * Setter for the sessionID
     *
     * @param id the session ID
     */
    public void setSessionID(String id){
        this.sessionID=id;

    }

    /**
     * Getter for the password hash.
     *
     * @return the hashed password.
     */

    public String getPwdHash(){
        return this.details.getPassword();
    }
}
