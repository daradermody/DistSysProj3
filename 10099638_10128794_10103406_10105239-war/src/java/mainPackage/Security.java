
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

import interactionBeans.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import org.owasp.html.HtmlPolicyBuilder;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;

/**
 * Class to handle session management and security
 *
 * @author Emma Foley 10105239
 * @author Dara Dermody 10099638
 * @author Niko Flores 10103406
 * @author Patrick O Keeffe 10128794
 */
public class Security {

    //interactCustomerLocal customerBean = lookupinteractCustomerLocal();
    //ConverterBeanLocal converterBean;
    interactCustomerLocal customerBean;
    interactProductLocal productBean;

    private static ArrayList<User> sessionUsers = new ArrayList<>();
    final private static int TIMEOUT = 900;

    public Security() {
        try {
            this.customerBean = (interactCustomerLocal) new InitialContext().lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/interactCustomer!interactionBeans.interactCustomerLocal");
        } catch (NamingException ex) {
            Logger.getLogger(Security.class.getName()).log(Level.SEVERE, null, ex);
        }

        try {
            InitialContext initialContext = new InitialContext();
            productBean = (interactProductLocal) initialContext.lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/interactProduct!interactionBeans.interactProductLocal");
        } catch (NamingException e) {
            System.out.println("Exception: " + e.getMessage());
        }
    }

    /**
     * Checks the validity of the username and corresponding password entered by
     * the user.
     *
     * @param username Username to check
     * @param password Password to check
     * @return Returns true if the user exists and the password is the
     * corresponding password for this user and false otherwise
     */
    public boolean verifyUser(String username, String password) {
        boolean validity = false;

        //Check that there is an input for username, password, and that the user exists
        if (username != null && password != null && customerBean.exists(username)) {
            validity = customerBean.verifyPassword(username, password);
            //validity = UserList.verifyUser(username, password);
        }

        return validity;
    }

    /**
     * Starts the session for the specified user, with the current time and a
     * universally unique ID
     *
     * @param username Username of the user for which the session is to be
     * started
     * @return Returns the unique session ID associated with the user the
     * session was created for; null, otherwise
     */
    public User startSession(String username) {
        boolean exists = false;

        User user = null; // ID value to return; if person already has session, return null


        if (username != null) {

            // Cycle through sessions recorded for existence of user
            for (User userCycle : sessionUsers)
                if (userCycle.getUsername().equals(username)) {
                    exists = true;
                    user = userCycle;
                    break;
                }

            // If no session exists for user, create session ID and add to user sessions list
            if (exists == false) {
                UUID uniqueID = UUID.randomUUID(); // Creates the universally unique session ID
                Integer seconds = (int) (System.currentTimeMillis() / 1000); // Retrieves the current time in milliseconds and converts into an integer

                // Cycle through all user in the list of generated users for user requiring session
                //check that the user exists

                if (customerBean.exists(username)) {
                    //new user with the Customer, ID and Timestamp

                    user = new User(customerBean.findByUsername(username), String.valueOf(uniqueID), seconds);

                    //user.setSessionID(String.valueOf(uniqueID)); // Set new session ID generated
                    //user.setTimestamp(seconds); // Set current timestamp of user
                    sessionUsers.add(user); // Adds the user into the list of logged in users
                }

            }
        }

        return user;
    }

    /**
     * Verifies the session by checking that the user is logged in and that the
     * timer for this user is less than 15 minutes
     *
     * @param sessionID Session ID to be verified
     * @return Returns the username associated with the sessionID if the session
     * exists; null, otherwise
     */
    public User verifySession(String sessionID) {
        User user = null;
        if (sessionID != null) {
            // Cycle through each user to find User object associated with given session ID
            for (User userCycle : sessionUsers) {
                if (userCycle.getSessionID().equals(sessionID)) {
                    // Retrieves the current time in milliseconds and converts into an integer
                    int currentSeconds = (int) (System.currentTimeMillis() / 1000);
                    // Calculates the elapsed time by subtracting the current time (in seconds) from the user's timestamp
                    int elapsedTime = currentSeconds - userCycle.getTimestamp();

                    // If the elapsed time is greater than 15 minutes (15 * 60 seconds = 900)
                    if (elapsedTime <= TIMEOUT) {
                        userCycle.setTimestamp(currentSeconds); // Replaces the old user with the current one, with the new timestamp
                        user = userCycle;
                    } else
                        endSession(sessionID); // Ends the session if the timer is longer than 15 minutes
                }
            }
        }
        return user;
    }

    /**
     * Ends the session with the specified session ID
     *
     * @param sessionID Session ID of the session to be ended
     * @return Returns true of the session was properly closed; false, if not
     */
    public static boolean endSession(String sessionID) {
        boolean success = false;

        if (sessionID != null) {
            for (Iterator<User> iter = sessionUsers.iterator(); iter.hasNext();) {
                User user = iter.next();
                if (user.getSessionID().equals(sessionID)) { // User found
                    iter.remove(); // Removes the user session with the specified session ID
                    System.out.printf("Removed user:\t%s | %s", user.getUsername(), user.getSessionID());
                    success = true;
                }
            }
        }

        return success;
    }

    /**
     * Function that performs the necessary authentication of user. Called at on
     * each JSP page to ensure the user is valid; this is done by checking the
     * ID or, failing that, verifying the username and password possibly
     * included.
     *
     * @param request HTTPServletRequest object that contains all the necessary
     * information to verify the user and the user's request.
     * @return String array of username and ID. if invalid, one of the elements
     * is null.
     */
    public User authoriseRequest(HttpServletRequest request) {
        // User information array setup to package returned information
        User user = null;
//        int USER = 0; // Constant index for username
//        int ID = 1; // Constant index for session ID]
//        int ADMINSTAT = 2; // Constant index for isAdmin boolean value as String
//        String userInfo[] = {null, null, null}; // User information array

        // Check for ID in cookies
        Cookie[] cookies = request.getCookies(); // Fetch Cookie array
        if (cookies != null) // Cycle through each cookie in Cookie array to find one with name "id"
            for (Cookie cookie : cookies)
                if (cookie.getName().equals("id")) {
                    user = new User();
                    user.setSessionID(sanitise(cookie.getValue(), false)); // Get and sanitise string value
                }

        // If no session cookie, check for session parameter in URL
        String idParam;
        if (user == null) {
            idParam = sanitise(request.getParameter("id"), false);
            if(!idParam.equals("")) {
                user = new User();
                user.setSessionID(idParam);
            }
        }
        
        if(user != null)
            user = verifySession(user.getSessionID()); // Get username from ID (null if invalid)
        
        if(user == null) { // If no session ID, check for username and password details
            // Get username and password parameters from user request and sanitise each
            String username = sanitise(request.getParameter("username"), false);
            String password = sanitise(request.getParameter("password"), false);

            // Set username to <none> if username and password were not attempted (to 
            // determine whether or not to display 'invalid attempt' message on login page
            if (password.equals(""))
                username = "<none>";

            // Verified username and password, and start session if valid
            if (verifyUser(username, password)) {
                user = startSession(username);
                System.out.printf("Login attempt:\t%s | %s\n\tSession ID:\t%s\n",
                        user.getUsername(), password, user.getSessionID());
            } else if (!username.equals("<none>")) // Notify invalid attempt
                System.out.printf("Login attempt: %s | %s\n\t>>> LOGIN FAILURE <<<\n",
                        username, password);
        }

        // Return array containing username ("<none>" if not attempted) and session ID
        if(user == null)
            return null;
        else
            return user;
    }

    /**
     * Function that sanitises a string by removing many characters sequences
     * that might lead to a scripting attack; some formatting tags (i.e. b, i,
     * etc.) and links (a href="") are allowed according to the user policy.
     *
     * @param str String to sanitise (i.e. remove dangerous substrings)
     * @param allowFormattingAndLinks Paremeter that determins if formatting and
     * link tags are allowed (b, i ,u, a href, etc.)
     * @return String with dangerous substrings removed (i.e. clean and safe)
     */
    public static String sanitise(String str, boolean allowFormattingAndLinks) {
        String sanitisedStr; // String that will hold sanitised string

        /* Example of building custom policy object:
         HtmlPolicyBuilder policyBuilder1 = new HtmlPolicyBuilder()
         .allowElements("a")
         .allowUrlProtocols("https")
         .allowAttributes("href").onElements("a")
         .requireRelNofollowOnLinks();
        
         PolicyFactory policy = policyBuilder1.toFactory();
         policy.sanitize(inputString);
         */
        // Initialise policy to convert html-unsafe characters to safe characters
        PolicyFactory policy1 = new HtmlPolicyBuilder().toFactory();

        if (allowFormattingAndLinks) // Use pre-made policy that allows some formatting tags (i, b, u, etc.) and links (a href)
        {
            policy1 = Sanitizers.FORMATTING.and(Sanitizers.LINKS);
        }

        sanitisedStr = policy1.sanitize(str); // Sanitise string (remove dangerous substrings)

        return sanitisedStr;
    }
//
//    private interactCustomerLocal lookupinteractCustomerLocal() {
//        try {
//            Context c = new InitialContext();
//            return (interactCustomerLocal) c.lookup("java:global/10099638_10128794_10103406_10105239/10099638_10128794_10103406_10105239-ejb/interactCustomer!interactionBeans.interactCustomerLocal");
//        } catch (NamingException ne) {
//            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
//            throw new RuntimeException(ne);
//        }
//    }

}
