/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package interactionBeans;

import dbEntities.Product;
import java.util.ArrayList;
import javax.ejb.Stateful;
import javax.ejb.LocalBean;

/**
 *
 * @author elfie
 */
@Stateful
@LocalBean
public class shoppingCartBean {

    ArrayList<Product> items = new ArrayList<>();
    
    public void addItem(Product p){
        items.add(p);
    }
    
    //removeItem()
    public void removeItem(Product p){
        items.remove(p);
    }
    
    //getTotal()
    public double getTotal(){
        double total = 0;
        Product temp;
        for (int i =0; i<items.size(); i++ ){
            temp = items.get(i);
            total += temp.getPrice();
        }
        return total;
    }
    
   // public boolean checkout(){
        //TODO: code logic
        //transactions?
        //get quantity of each
        //make sure there's enough available?
        //
    //}

}
