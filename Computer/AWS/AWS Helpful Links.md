# AWS Helpful Links

## Table of Contents

- [Databases (Aurora)](#databases-aurora)
- [Networking and Content Delivery](#networking-and-content-delivery)
  - [Load Balancing](#load-balancing)
  - [VPC](#vpc)
  - [Route 53](#route-53)
  - [CloudFront](#cloudfront)
- [Messaging (SQS)](#messaging-sqs)
- [Storage (S3)](#storage-s3)
- [Security (IAM)](#security-iam)

---

## Databases (Aurora)

| Topic | Link |
| --- | --- |
| Aurora serverless configuration | <https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html> |
| Aurora failover details | <https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.AuroraHighAvailability.html> |

## Networking and Content Delivery

### Load Balancing

| Topic | Link |
| --- | --- |
| ALB traffic management | <https://aws.amazon.com/elasticloadbalancing/application-load-balancer/?nc=sn&loc=2&dn=2> |

### VPC

**Q: Can you mix an S3 gateway endpoint (s3gw) with an internet gateway (igw) for S3 access from a private instance? What is the precedence?**

- Reference: <https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html>

### Route 53

| Topic | Link |
| --- | --- |
| Geoproximity routing | <https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-geoproximity.html> |
| Map an external domain to a static website in S3 | <https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/RoutingToS3Bucket.html> |

### CloudFront

| Topic | Link |
| --- | --- |
| Origin groups (origin failover) | <https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/high_availability_origin_failover.html> |

## Messaging (SQS)

| Topic | Link |
| --- | --- |
| Dead-letter queue (DLQ) setup | <https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-configure-dead-letter-queue.html> |

## Storage (S3)

| Topic | Link |
| --- | --- |
| S3 Transfer Acceleration cost | <https://aws.amazon.com/s3/pricing/> |
| Check access patterns of data (storage class analysis) | <https://docs.aws.amazon.com/AmazonS3/latest/userguide/analytics-storage-class.html> |

**Q: For S3 Glacier expedited retrieval, is it milliseconds to the first byte or to the entire object?**

- The implication is that it is the first byte.
- From the docs: "For all but the largest archived objects (250 MB+), data that is accessed using expedited retrievals is typically made available within 1–5 minutes."
- Reference: <https://docs.aws.amazon.com/AmazonS3/latest/userguide/restoring-objects-retrieval-options.html>

## Security (IAM)

**Q: Are there any tools for debugging why a user or resource does not have permissions?**

- Use the IAM policy simulator in the IAM console. It shows permissions for different users.

**Q: Can I, as a user, change permissions in a way that would lock me out of something?**

- Yes, if you have sufficient permissions (admin access, for example) to change permissions on yourself.
- For instance, you could set a permissions boundary that restricts your ability to remove that boundary in the future.
- Be very careful setting permissions on yourself.

**Q: Can a user check their own permissions?**

- Use the IAM policy simulator in the IAM console, but the user must have an IAM permissions policy that allows access to it.


# Author

---

- [Rohtash Lakra](https://github.com/rslakra)
