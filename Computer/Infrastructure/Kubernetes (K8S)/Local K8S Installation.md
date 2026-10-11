# Local K8S Installation Instructions

## Installing minikube

### macOS
1. Install Minikube
```shell
brew install minikube
```

2. Install Docker
```shell
docker --version
```

3. Minikube run as Docker container
```shell
minikube start --driver docker
```

Output:
```text
kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

4. Check minikube status
```shell
minikube status
```

Output:
```text
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

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

### Mongo Configuration
1. ConfigMap
2. Secret

Secrets are base64 encoded (instead of plain text)

How to encode with base64 on macOS?
```shell
echo -n <plain text> | base64

i.e.
echo -n mongouser | base64
bW9uZ291c2Vy


echo -n mongopassword | base64
bW9uZ29wYXNzd29yZA==
```


3. Click "Import" and select `certs/mitm-ca.crt`
4. Choose "Trust this CA to identify websites"
5. Click "OK"

## Verification
After installation, you can verify the CA is trusted by visiting:
- https://mitm.it (should show a certificate warning if CA is not installed)
- Any HTTPS site through the proxy (should work without warnings)

## Reference
- [Documentation/Get Started!](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download)
- [Docker](https://docs.docker.com)

