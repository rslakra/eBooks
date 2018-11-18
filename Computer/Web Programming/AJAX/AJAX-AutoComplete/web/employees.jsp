<%-- Copyright 2005 Sun Microsystems, Inc. All rights reserved. You may not modify, use, reproduce, or distribute this software except in compliance with the terms of the License at: http://developer.sun.com/berkeley_license.html
$Id: employees.jsp,v 1.1 2005/04/01 02:18:40 gmurray71 Exp $ --%>

<%@ taglib prefix="c" uri="/WEB-INF/c.tld" %>

<html>
<head>
</head>
<body>
 <h1>Search Results</h1>
 <hr/>
 
<c:choose>
 <c:when test="${requestScope.employees == null}">
  <p><font size="+2" color="red">Unable to locate any employees.</font></p>
 </c:when>
 <c:otherwise>
   <c:forEach var="employee" begin="0" items="${requestScope.employees}">
   <p><a href="autocomplete?action=lookup&id=${employee.id}">${employee.firstName} ${employee.lastName}</a></p>
  </c:forEach>
 </c:otherwise>
</c:choose>
<br/>
 <p>
  <a href="index.jsp">Go back to the application home</a>.
 </p>
 </body>
</html>

