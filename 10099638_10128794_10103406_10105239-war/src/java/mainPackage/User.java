/* 
 * Group:       Dara Dermody (10099638), Emma Foley (10105239), Niko Flores (10103406), Patrick O'Keeffe (10128794)
 * Module:      Distributed Systems 2
 *      Code:   CE4208
 * Lecturer:    Reiner Dojen
 * Date:        07 April 2014
 *
 * Project:     Secure Authentication and Session Management System for a Web Application
 */
package mainPackage;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

/**
 * A User data type, containing the details of one user.
 * @author Emma Foley
 * @author Dara Dermody
 * @author Niko Flores
 * @author Patrick O Keeffe
 */
public class User {
    private final String username;
    private String sessionID; //for security class
    private final String creationDate; // for Security class
    private int sessionTime;
    private final int salt;
    private final String pwdHash;
    
    /**
     * Constructor to create a user with the given username and password.
     * Other attributes are generated.
     * @param usnm the name for the new user 
     * @param password the user's password
     */
    protected User(String usnm, String password) {
        this.username = usnm;
        
        DateFormat dateFormatter = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy");
        this.creationDate = dateFormatter.format(new Date());
  
        Random r = new Random();
        this.salt = r.nextInt();
        this.pwdHash = hash(salt+password);
        
        sessionID = null; // for default
        sessionTime = 0; // for default
    }
    
    /**
     * Getter for username attribute
     * @return the username
     */
    protected String getUsername(){
        return this.username;
    }
    
    /**
     * Getter for the creationDate attribute
     * @return the date/time the user joined the site
     */
    protected String getCreationDate(){
        return this.creationDate;
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
     * getter for the salt attribute
     * @return the salt used for the password hashing
     */
    protected int getSalt(){
        return this.salt;
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
        return this.pwdHash;
    }
    
    /**
     * Hash a plain test salt+password
     * @param plain the string to be hashed (salt+password)
     * @return 
     */
    protected static String hash(String plain){    
        String cipher = null;
         
        if(plain == null) return null;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA");
            //Update input string in message digest
            digest.update(plain.getBytes(), 0, plain.length());
 
            //Converts message digest value in base 16 (hex)
            cipher = new BigInteger(1, digest.digest()).toString(16);
        } catch (NoSuchAlgorithmException e) { 
            System.out.println("The specified algorithm is not supported.");
        }
        return cipher;
    }
    
    /**
     * Return a String representation of the object
     * @return the object string
     */
    @Override
    public String toString(){
        return(String.format("%s, %s, %s, %s", this.username, this.pwdHash, this.salt, this.creationDate));
    }
    
}
