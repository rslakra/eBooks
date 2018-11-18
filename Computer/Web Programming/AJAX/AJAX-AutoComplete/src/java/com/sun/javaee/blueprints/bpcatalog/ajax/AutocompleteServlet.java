/* Copyright 2005 Sun Microsystems, Inc. All rights reserved. You may not modify, use, reproduce, or distribute this software except in compliance with the terms of the License at: http://developer.sun.com/berkeley_license.html  
$Id: AutocompleteServlet.java,v 1.2 2005/04/01 19:20:29 gmurray71 Exp $ */
package com.sun.javaee.blueprints.bpcatalog.ajax;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;

public class AutocompleteServlet extends HttpServlet {
    
    private ServletContext context;
    private HashMap employees = new HashMap();
 
    public void init(ServletConfig config) throws ServletException {
        this.context = config.getServletContext();
        employees.put("1", new EmployeeBean("1","Greg","Murray"));
        employees.put("2", new EmployeeBean("2","Greg","Murphy"));
        employees.put("3", new EmployeeBean("3","George","Murphy"));
        employees.put("4", new EmployeeBean("4","George","Murray"));
        employees.put("5", new EmployeeBean("5","Peter","Jones"));
        employees.put("6", new EmployeeBean("6","Amber","Jones"));
        employees.put("7", new EmployeeBean("7","Amy","Jones"));
        employees.put("8", new EmployeeBean("8","Bee","Jones"));
        employees.put("9", new EmployeeBean("9","Beth","Johnson"));
        employees.put("10", new EmployeeBean("10","Cindy","Johnson"));
        employees.put("11", new EmployeeBean("11","Cindy","Murphy"));
        employees.put("12", new EmployeeBean("12","Duke","Hazerd"));
    }

    public  void doGet(HttpServletRequest request, HttpServletResponse  response)
        throws IOException, ServletException {
        
	    String action = request.getParameter("action");
        String targetId = request.getParameter("id");
        StringBuffer sb = new StringBuffer();
        if (targetId != null) targetId = targetId.trim().toLowerCase();
        boolean namesAdded = false;
		if ("complete".equals(action)) {
            Iterator it = employees.keySet().iterator();
            while (it.hasNext()) {
                String id = (String)it.next();
                EmployeeBean e = (EmployeeBean)employees.get(id);
                // simple matching only for start of first or last name
                if ((targetId != null) && (e.getFirstName().toLowerCase().startsWith(targetId) ||
                    e.getLastName().toLowerCase().startsWith(targetId)) &&
                    !targetId.equals(""))  {
                    sb.append("<employee>");
                    sb.append("<id>" + e.getId() + "</id>");
                    sb.append("<firstName>" + e.getFirstName() + "</firstName>");
                    sb.append("<lastName>" + e.getLastName() + "</lastName>");
                    sb.append("</employee>");
                    namesAdded = true;
                }
            }
		    if (namesAdded) {
			    response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
		        response.getWriter().write("<employees>" + sb.toString() + "</employees>");
			} else {
                //nothing to show
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
            }
	    } if ("lookupbyname".equals(action)) {
            Iterator it = employees.keySet().iterator();
            ArrayList names = new ArrayList();
            while (it.hasNext()) {
                String id = (String)it.next();
                EmployeeBean e = (EmployeeBean)employees.get(id);
                // simple matching only for start of first or last name
                if (e.getFirstName().toLowerCase().startsWith(targetId) ||
                    e.getLastName().toLowerCase().startsWith(targetId))  {
                   names.add(e);
                }
            }
            if (names.size() > 0) {
                request.setAttribute("employees", names);
            }
            context.getRequestDispatcher("/employees.jsp").forward(request, response);
         } else if ("lookup".equals(action)) {
            // put the target employee in the reqeust scope to display 
            if ((targetId != null) && employees.containsKey(targetId.trim())) {
                request.setAttribute("employee", employees.get(targetId));
                context.getRequestDispatcher("/employee.jsp").forward(request, response);
            } else {
                context.getRequestDispatcher("/error.jsp").forward(request, response);
            }
		}
    }
}


