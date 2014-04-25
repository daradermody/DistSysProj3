/*
 * Servlet to demonstrate use of EJBContext lookup (lookup takes place in
 * the injected bean ConverterLookupBean).
 */
package mainPackage;

import java.io.*;
import javax.ejb.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import interactionBeans.*;

/**
 *
 * @author reiner.dojen
 */
public class ConverterServletEJBContext extends HttpServlet {

    // use dependency injection to obtain reference to ConverterBean
    @EJB
    ConverterBeanLocal converterBean;
    
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Currency Converter</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<form action=ConverterServletEJBContext method=POST>");
        out.println("<table>");
        out.println("<tr><td>Dollar to Euro:</td><td><input type=text name=dollar2euro value=0></td></tr>");
        out.println("<tr><td>Euro to Dollar:</td><td><input type=text name=euro2dollar value=0></td></tr>");
        out.println("<tr><td>GBP to Euro:</td><td><input type=text name=gbp2euro value=0></td></tr>");
        out.println("<tr><td>Euro to GBP:</td><td><input type=text name=euro2gbp value=0></td></tr>");
        out.println("<tr><td colspan=2><input type=submit></td></tr>");
        out.println("</table></form>");
        out.println("</body>");
        out.println("</html>");
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // get parameter from request
        double dollar = Double.parseDouble(request.getParameter("dollar2euro"));
        double euro4dollar = Double.parseDouble(request.getParameter("euro2dollar"));
        double gbp = Double.parseDouble(request.getParameter("gbp2euro"));
        double euro4gbp = Double.parseDouble(request.getParameter("euro2gbp"));
        
        // use EJB to obtain results
        double dollar2euroResult = converterBean.dollarToEuro(dollar);
        double euro2dollarResult = converterBean.euroToDollar(euro4dollar);
        double gbp2euroResult = converterBean.gbpToEuro(gbp);
        double euro2gbpResult = converterBean.euroToGBP(euro4gbp);
        
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Servlet ConverterServlet</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h2>On 12.03.2012 the following rates applied: </h2>");
        out.println("<table>");
        out.println("<tr><td>Dollar to Euro:</td><td>$" + dollar + " = &euro;" + dollar2euroResult+ "</td></tr>");
        out.println("<tr><td>Euro to Dollar:</td><td>&euro;" + euro4dollar + " = $" + euro2dollarResult + "</td></tr>");
        out.println("<tr><td>GBP to Euro:</td><td>&pound;" + gbp + " = &euro;" + gbp2euroResult + "</td></tr>");
        out.println("<tr><td>Euro to GBP:</td><td>&euro;" + euro4gbp + " = &pound;" + euro2gbpResult + "</td></tr>");
        out.println("</table>");
        out.println("</body>");
        out.println("</html>");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
