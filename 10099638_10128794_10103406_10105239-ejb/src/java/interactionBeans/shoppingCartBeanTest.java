/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interactionBeans;

import java.util.HashMap;
import java.util.Map;
import javax.ejb.Remove;
import javax.ejb.Stateful;

/**
 *
 * @author daradermody
 */
@Stateful
public class shoppingCartBeanTest implements shoppingCartBeanTestLocal {

    // Add business logic below. (Right-click in editor and choose
    // "Insert Code > Add Business Method")
    private HashMap<String, Integer> items = new HashMap<String, Integer>();

    @Override
    public void addItem(String item, int quantity) {
        Integer orderQuantity = items.get(item);
        if (orderQuantity == null) {
            orderQuantity = 0;
        }
        orderQuantity += quantity;
        items.put(item, orderQuantity);
    }
    // ... Other method implementations ... 
    
    @Remove
    @Override
    public void checkout(int paymentId) {
        // store items to database
        // ... 
    }

    @Remove
    @Override
    public void cancel() {
    }

    @Override
    public void removeItem(String id, int quantity) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Map<String, Integer> getItems() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
