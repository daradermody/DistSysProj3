/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interactionBeans;

import java.util.Map;
import javax.ejb.Local;

/**
 *
 * @author daradermody
 */
@Local
public interface shoppingCartBeanTestLocal {

    public void addItem(String id, int quantity);

    public void removeItem(String id, int quantity);

    public Map<String, Integer> getItems();

    public void checkout(int paymentId);

    public void cancel();
}
