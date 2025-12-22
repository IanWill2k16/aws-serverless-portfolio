# AWS Serverless Portfolio

## Overview

This repository contains a production-style serverless portfolio application deployed on Amazon Web Services (AWS). The project demonstrates how to design, provision, and operate a complete cloud-native workload using infrastructure as code, event-driven compute, and fully automated CI/CD.

The application itself is intentionally simple: a static website with a visitor counter backed by AWS Lambda and DynamoDB. The primary focus of the project is on architecture, automation, security boundaries, and deployment patterns rather than application complexity.

---

## Architecture

**High-level flow:**

1. A static website is hosted in Amazon S3 and delivered globally via CloudFront.
2. Client-side JavaScript calls a public HTTP API exposed through Amazon API Gateway.
3. API Gateway invokes a Python AWS Lambda function.
4. The Lambda function increments and retrieves a counter stored in DynamoDB.
5. The updated count is returned to the frontend and rendered on the page.

All infrastructure is provisioned with Terraform and deployed automatically using GitHub Actions with OIDC authentication.

---

## Components

### Frontend

* Static HTML, CSS, and JavaScript
* Hosted in Amazon S3 and served via CloudFront
* API endpoint injected at deploy time
* CloudFront invalidation triggered on deployment

### Backend API

* Python AWS Lambda function
* Stateless execution model
* Exposed via Amazon API Gateway

### Data Layer

* Amazon DynamoDB
* Simple table storing a global visitor counter
* Composite primary key design for future extensibility

### Infrastructure

* Terraform-managed AWS resources
* Modular Terraform design
* Remote Terraform state stored in S3 with DynamoDB state locking
* Least-privilege IAM roles scoped to individual services

---

## CI/CD

GitHub Actions is used to fully automate provisioning and deployment:

* **Main Branch Pushes**

  * Terraform init, plan, and apply using remote state
  * Frontend API endpoint injected at build time
  * Static site assets synced to S3
  * CloudFront cache invalidation

Authentication to AWS is handled using GitHub Actions OIDC and IAM role assumption. No long-lived AWS credentials or secrets are stored in the repository.

---

## Security Considerations

* No secrets are committed to source control
* AWS authentication uses OIDC with short-lived credentials
* Terraform remote state protected with DynamoDB locking
* IAM permissions scoped per-service following least-privilege principles
* API access restricted via CORS configuration

---

## Repository Structure

```
aws-serverless-portfolio/
├── app/
│   ├── web/            # Static frontend
│   └── api/            # Lambda function (Python)
├── infra/              # Terraform infrastructure
│   └── modules/        # Terraform modules
└── .github/            # GitHub Actions workflows
```

---

## Purpose

This repository serves as a reference implementation demonstrating:

* Serverless application architecture on AWS
* Infrastructure as code using Terraform
* Secure, credential-free CI/CD with GitHub Actions and OIDC
* Practical IAM scoping and service integration
* Clean separation between application logic and infrastructure

The project favors clarity, operational safety, and maintainability over feature depth, and reflects real-world cloud automation patterns rather than tutorial-driven examples.
