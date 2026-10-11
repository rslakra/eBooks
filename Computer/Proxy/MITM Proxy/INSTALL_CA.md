# MITM Proxy CA Installation Instructions

## Installing the CA Certificate

### macOS
1. Open Keychain Access
2. Go to File > Import Items
3. Select `certs/mitm-ca.crt`
4. Double-click the imported certificate
5. Expand "Trust" section
6. Set "When using this certificate" to "Always Trust"
7. Close the dialog and enter your password

### Windows
1. Double-click `certs/mitm-ca.crt`
2. Click "Install Certificate..."
3. Choose "Current User" or "Local Machine"
4. Select "Place all certificates in the following store"
5. Click "Browse" and select "Trusted Root Certification Authorities"
6. Click "Next" and "Finish"

### Linux (Ubuntu/Debian)
```bash
sudo cp certs/mitm-ca.crt /usr/local/share/ca-certificates/mitm-proxy-ca.crt
sudo update-ca-certificates
```

### Chrome Browser
1. Open Chrome settings
2. Go to Privacy and security > Security > Manage certificates
3. Click "Import" and select `certs/mitm-ca.crt`
4. Choose "Trust this CA to identify websites"
5. Click "OK"

## Verification
After installation, you can verify the CA is trusted by visiting:
- https://mitm.it (should show a certificate warning if CA is not installed)
- Any HTTPS site through the proxy (should work without warnings)

## Security Warning
This CA certificate allows the proxy to intercept HTTPS traffic. Only install it in trusted environments and remove it when not needed.
