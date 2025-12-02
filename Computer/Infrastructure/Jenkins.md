# Jenkins

---


## Jenkins

---

The Jenkins helps to automate the build creation process (the CI/CD process).

- Jenkins Host
        - Jenkin

    - GitHub/BitBucket
        - WebDemoRepo

    - AWS
        - S3 Bucket
        - AWS S3 Policy
        ```json
        {
            "Statement": [
                {
                    "Action": [
                        "s3:PutObject"
                    ],
                    "Effect": "Allow",
                    "Resource": "arn:aws:s3:::jenkins-s3-bucket/*",
                    "Principal": {
                        "AWS": [
                            "000000000000"
                        ]
                    }
                }
            ]
        }
        ```
      
        - AWS Commands
        ```shell
        # Deploy .war File
        aws deploy push --application-name APP_NAME.war --region us-west-2 --s3-location s3://jenkins-s3-bucket/APP_NAME.war --ignore-hidden-files

        # Push to S3 Bucket
        aws push --region us-west-2 --s3-location s3://jenkins-s3-bucket/APP_NAME.war --ignore-hidden-files

        # Copy .war File to S3 Bucket
        aws s3 cp target/APP_NAME.war s3://jenkins-s3-bucket

        # List S3 Bucket Objects
        aws s3 ls s3://jenkins-s3-bucket

        # Push .war to S3 Bucket and Deploy
        aws deploy push \
        --application-name AppBaseName \
        --description "Lakra Webapp Deployment" \
        --ignore-hidden-files \
        --s3-location s3://jenkins-s3-bucket/APP_NAME.war \
        --source target/APP_NAME.war \
        --region us-west-2
        ```
      - AWS Deployment Policy
        ```shell
        arn:aws:iam::000000000000:role/CodeDeploy
        ```
      - Get ARN Info
        ```shell
        aws iam get-role --role-name CodeDeploy --query "Role.Arn" --output text
        ```

## Jenkin Setup Steps

1. Host Running
2. Download Jenkins
3. Download OpenJDK 11/21 and Install
```shell
# Install JDK
sudo yum install java-21-openjdk
```
4. Install Jenkins
4.1 Prerequisite: JDK
```shell
# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.org/redhat/jenkins.repo
sudo yum install jenkins
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install jenkins -y
sudo service jenkins start
sudo chkconfig jenkins on
sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service

# Setup jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
sudo service jenkins restart

# Grant Jenkins user Admin Permission
sudo chmod 644 /etc/sudoers
sudo vim /etc/sudoers
# Add the following line at the end of the file
jenkins ALL=(ALL) NOPASSWD: ALL
```
5. Login on Jenkins (as admin)
6. Install Dependencies
    - ```sudo apt-get install git```
    - 
7. Install Plugins
    - Blue Ocean
    - Pipeline AWS Steps
8. 


## Jenkin Dependencies
- JDK
- GitHub/BitBucket
```shell
#Jenkin Job Config

#Configure SSH Keys
sudo su jenkins
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
cat ~/.ssh/id_rsa
# GitHub/BitBucket IP add in the Jenkins
```
- Maven
- Gradle
- Node
- Repo Specific Dependencies (like ```tidy``` for html)


# Author

---

- Rohtash Lakra
