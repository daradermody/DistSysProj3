/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package interactionBeans;

import javax.ejb.Stateless;

/**
 *
 * @author root
 */
@Stateless
public class ConverterBean implements ConverterBeanLocal {

    private double gbpRate = 1.18899; // 1GBP = 1.188...€
    private double dollarRate = 0.760098; // 1$ == 0.76...€

    @Override
    public double dollarToEuro(double dollar) {
        return dollar * dollarRate;
    }

    @Override
    public double euroToDollar(double euro) {
        return euro / dollarRate;
    }

    @Override
    public double gbpToEuro(double gbp) {
        return gbp * gbpRate;
    }

    @Override
    public double euroToGBP(double euro) {
        return euro / gbpRate;
    }

}
