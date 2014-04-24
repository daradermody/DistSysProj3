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

import java.util.ArrayList;

/**
 * Collection of users, and associated methods for data management
 *
 * @author Emma Foley 10105239
 * @author Dara Dermody 10099638
 * @author Niko Flores 10103406
 * @author Patrick O Keeffe 10128794
 */

@Deprecated
public class UserList {

    private static ArrayList<User> users = new ArrayList<User>() {
        {
            //add(new User("dara", "5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8"));
            //add(new User("emma", "efdb8f7f2fe9c47e34dfe1fb7c491d0638ec2d86"));
            //add(new User("patrick", "cbb7353e6d953ef360baf960c122346276c6e320"));
            //add(new User("niko", "a6ae6cf14935b977dc000a8624f9d66f90b41da0"));
        }
    };

    
    //
    /**
     * Find a user, given the username.
     * Replaced by interactCustomer.findByUsername(String)
     * @param username
     * @return the user object matching the username, or null
     */
    @Deprecated
    protected static User findUser(String username) {
        User user = null;
        loop:
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUsername().equals(username)) {
                user = users.get(i);
                break loop;
            }
        }
        return user;
    }

    /**
     * Determines whether the username exists.
     *
     * @param username
     * @return the user object matching the username, or null
     */
    @Deprecated
    protected static boolean contains(String username) {
        Boolean exists = false;
        if (users.isEmpty()) {
            return false;
        }
        loop:
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUsername().equals(username)) {
                exists = true;
                break loop;
            }
        }
        return exists;
    }

    /**
     * Get the entire user list
     *
     * @return the users stored in the list
     */
    @Deprecated
    protected static ArrayList<User> getUserList() {
        return users;
    }

    /**
     * verify that the password matches the user
     * Replaced with interactCustomer.verifyPassword(String username, String password)
     * @param username
     * @param password
     * @return true if the username and password match, false otherwise
     */
    @Deprecated
    protected static boolean verifyUser(String username, String password) {
        User user = findUser(username);
        /*if (user != null) {
            return (user.getPwdHash().equals(User.hash(user.getSalt() + password)));
        } else {
            return false;
        }*/
        return false;
    }

    /**
     * Add a new user to the UserList
     * Not replaced
     * @param username
     * @param password
     */
    @Deprecated
    protected void addUser(String username, String password) {
        if (!contains(username)) {
            //users.add(new User(username, password));
        }
    }
    
}
