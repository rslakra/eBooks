# JAVA

---

## Java

### Working with Java
This describes the Java Runtime Environment, and the use of the Java Certificate Store.

### Installation of JRE
The JRE must be installed on the device, where you wish to run any client application. If the JRE is installed independently, it  is available to multiple applications. Alternatively, you can install a separate copy for each application on your system that required the JRE. The benefit of installing a JRE with each application is that if you remove or update the global JRE, your application does not stop working.

### Java Certificate Store
Java uses a certificate store, which usually consists of a ```cacerts``` file, located in the ```jre/lib/security``` directory of your java installation.

For secure communications, the server provides a certificate, which has been signed by a well known ```Certificate Authority (CA)```.

Proxy servers typically pass HTTPS traffic unaltered so no action is required when accessing the cloud service via a proxy. Some proxy servers, however, decrypt then re-encrypt the data before passing them to the destination.

### Importing a Certificate
To add a certificate to the Java ```cacerts``` file, you can use the ```keytool``` application, which is provided with the java installation, located in the ```jre/bin``` directory.

The following command imports a certificate from the file ```ldap-certificate.cer``` into the ```cacerts``` file:

```shell
keytool –import – trustcacerts –alias ldap-certificate –file ldap-certificate.cer –keystore cacerts
```

**Note**

If you have not changed the keystore password, enter the default password, ```changeit```, when prompted.

If you are using the system JRE and do not want to modify the system ```cacerts``` file, you can create the directory ```application/lib/security``` in the directory where the client is installed, copy the system ```cacerts``` file to ```application/lib/security/schemus-cacerts``` then modify the copy.




---

# Author
- Rohtash Lakra
