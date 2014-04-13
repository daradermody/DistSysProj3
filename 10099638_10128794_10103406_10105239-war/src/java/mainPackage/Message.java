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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Emma Foley
 * @author Dara Dermody
 * @author Niko Flores
 * @author Patrick O Keeffen
 */
public class Message {

    private String content;
    private String poster;
    final private String date;
    
    /**
     * Constructor to create a forum message with a given content
     *
     * @param msg content of forum message
     * @param pstr poster of message
     */
    public Message(String msg, String pstr) {
        this.content = msg;
        this.poster = pstr;

        DateFormat dateFormatter = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy");
        this.date = dateFormatter.format(new Date());
    }
   
    /**
     * Returns the content of the forum message
     *
     * @return Content of the forum message
     */
    public String getContent() {
        return this.content;
    }


    /**
     * Returns the content of the forum message
     *
     * @return Content of the forum message
     */
    public String getPoster() {
        return this.poster;
    }

    /**
     * Returns the content of the forum message
     *
     * @return Content of the forum message
     */
    public String getDate() {
        return this.date;
    }

    /**
     * Evaluates whether the forum content contains a given string.
     *
     * @param text String to search for in message content
     * @return true if text is contained in message content, false otherwise
     */
    public boolean contains(String text) {
        return this.content.contains(text);
    }
    
}
