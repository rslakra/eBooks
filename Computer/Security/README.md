# Security


## How to create the ```self-signed``` certificate?

### Step 1 - Create your self-signed certificate and create .bks file
```
keytool -genkey -alias tjws -keystore tjws.keystore -validity 365
keytool -export -alias tjws -keystore tjws.keystore -file tjws.cer
keytool -import -alias tjws -file tjws.cer -keystore tjws.bks -storetype BKS -providerClass org.bouncycastle.jce.provider.BouncyCastleProvider -providerpath ./BouncyCastle/bcprov-jdk15on-159.jar
```

### Step-2: Put our .keystore file in /androidappdir/res/raw/




## Open SSL

---

- How to create Root (Private) Certificate?
    
  - Generate private key of size 2048 bits
  
  ```shell
    openssl genrsa -aes256 -out private.key 2048
  ```

  - Generate CA Certificate

    ```shell
    openssl req -new -x509 -key private.key -sha256 -day 365 -out domainca.pem
    ```

  - Now you can use this certificate to further issue the subordinate CA.

- 
