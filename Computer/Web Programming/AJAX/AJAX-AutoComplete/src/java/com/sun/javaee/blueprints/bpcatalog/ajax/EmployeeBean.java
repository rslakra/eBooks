/* Copyright 2005 Sun Microsystems, Inc. All rights reserved. You may not modify, use, reproduce, or distribute this software except in compliance with the terms of the License at: http://developer.sun.com/berkeley_license.html  
$Id: EmployeeBean.java,v 1.1 2005/04/01 02:18:39 gmurray71 Exp $ */
package com.sun.javaee.blueprints.bpcatalog.ajax;

public class EmployeeBean {

    private String id;
    private String firstName;
    private String lastName;
    
    public EmployeeBean (String id, String firstName, String lastName) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
    }
    
    public String getId() {
        return id;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
}


