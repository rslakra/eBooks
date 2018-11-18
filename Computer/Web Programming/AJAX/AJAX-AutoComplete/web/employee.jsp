<%-- Copyright 2005 Sun Microsystems, Inc. All rights reserved. You may not modify, use, reproduce, or distribute this software except in compliance with the terms of the License at: http://developer.sun.com/berkeley_license.html
$Id: employee.jsp,v 1.1 2005/04/01 02:18:40 gmurray71 Exp $ --%>
<html>
<head>
</head>
<body>
 <h1>Employee Information</h1>
 <hr/>
 <p>
  First Name:${requestScope.employee.firstName}.
 </p>
 <p>
  Last Name:${requestScope.employee.lastName}.
 </p>
 <p>
  Id:${requestScope.employee.id}.
 </p>
 <p>
  <a href="index.jsp">Go back to the application home</a>.
 </p>
 </body>
</html>

