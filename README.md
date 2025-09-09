Terraform modules to set up and a highly available, fault-tolerant, secure, and scalable 3-tier infrastructure on AWS.
Each environment has over 100 resources to support your App.

Cloud Environment: AWS
IaC: Terraform
CI/CD pipeline: Git Actions

-> tflint for automatic script examinination to identify potential issues, errors, and deviations from best practices.

-> tfsec for static security analysis and scanning

\*ALL SECURITY GROUP PING RULES ARE FOR TESTING CONNECTIVITY

The setup is as follows:
Frontend: NGINX + NodeJS (React)
Backend: React + MySQL
DB: Aurora MySQL

It runs no real application.
To test your connection, launch an EC2 instance in internal ALB Security group, and another EC2 instance in external ALB security group. Then ping the IP address of EC2 instances in web and app subnets respectively.

Be sure to replace the following values in your envs/dev/variables.tf file
Region: ca-central-1
AZs : ca-central-1a, ca-central-1b, ca-central-1d
App name: Ruby
Your email address to receive notifications
Your S3 bucket name

Components created

1. VPC
2. Internet gateway
3. NAT gateway x 3
4. EIP x 3
5. subnets x 9 = web x 3, app x 3, db x 3
6. security groups x 5
7. RDS subnet group
8. Multi-AZ RDS (Aurora MySQL) \*uncomment RDS module block in envs/dev/main.tf
9. S3 buckets x 3
10. SNS topics and subscription
11. IAM policies and policy documents
12. AMI
13. Launch templates x 2
14. Target groups x 2
15. Load balancers x 2
16. ASG x 2
17. Route53 hosted zone
18. CloudTrail
19. CloudWatch Alarms
20. Secrets Manager, etc

Trade offs

1. CloudFront - you may include CloudFront CDN to host cached versions of your app in select locations
2. SSL/TLS certificate - you may include a SSL/TLS certificate to secure your external load balancer
