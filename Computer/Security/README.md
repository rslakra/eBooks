# Security


## How to create the ```self-signed``` certificate?

### Step 1 - Create your self-signed certificate and create .bks file
```
keytool -genkey -alias tjws -keystore tjws.keystore -validity 365
keytool -export -alias tjws -keystore tjws.keystore -file tjws.cer
keytool -import -alias tjws -file tjws.cer -keystore tjws.bks -storetype BKS -providerClass org.bouncycastle.jce.provider.BouncyCastleProvider -providerpath ./BouncyCastle/bcprov-jdk15on-159.jar
```

### Setp-2: Put our .keystore file in /androidappdir/res/raw/
