/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package mainPackage;

import dbEntities.Customer;

/**
 * A User data type, containing the details of one user.
 * @author Emma Foley
 * @author Dara Dermody
 * @author Niko Flores
 * @author Patrick O Keeffe
 */
public class User {
    private final Customer details;
    private String sessionID; //for security class
    //private final String creationDate; // for Security class
    private int sessionTime;
    private boolean isAdmin;
    
    /**
     * Constructor to create a logged on user.
     * 
     * @param c The "base" customer that will be associated with other user attributes.
     * @param sessionID A session ID 
     * @param sessionTime A session time
     */
    protected User(Customer c, String sessionID, int sessionTime, boolean isAdmin) {
        this.details = c;
        
        //DateFormat dateFormatter = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy");
        //this.creationDate = dateFormatter.format(new Date());
          
        this.sessionID = sessionID;
        this.sessionTime = sessionTime; 
        this.isAdmin = isAdmin;
    }
    
    /**
     * Getter for username attribute
     * @return the username
     */
    protected String getUsername(){
        return this.details.getUsername();
    }
    
    /**
     * getter for the sessionTime attribute
     * @return the sessionTime or null id the user is not logged in
     */
    protected int getTimestamp() {
        return this.sessionTime;
    }
    
    /**
     * setter for the sessionTime attribute
     * @param st 
     */
    protected void setTimestamp(int st) {
        this.sessionTime=st;
    }
    
    /**
     * getter for the sessionID attribute
     * @return the session id or "" if the user is not logged in
     */
    protected String getSessionID(){
        return this.sessionID;
    }
    
    /**
     * Setter for the sessionID
     * @param id the session ID
     */
    protected void setSessionID(String id){
        this.sessionID=id;
    }
    
    /**
     * Getter for the password hash.
     * @return the (salt) hashed password.
     */
    protected String getPwdHash(){
        return this.details.getPassword();
    }
}
