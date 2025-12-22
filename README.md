# Azure Serverless Portfolio

## Overview

This repository contains a small, production-style serverless portfolio application deployed on Microsoft Azure. The project demonstrates how to provision and operate a complete cloud-native workload using infrastructure as code, event-driven compute, and automated CI/CD.

The application itself is intentionally simple: a static website with a visitor counter backed by an Azure Function and Cosmos DB. The focus of the project is on architecture, automation, security boundaries, and deployment patterns rather than application complexity.

---

## Architecture

**High-level flow:**

1. A static website is hosted using Azure Storage Static Website hosting.
2. Client-side JavaScript calls a public HTTP-triggered Azure Function.
3. The Azure Function increments and retrieves a counter stored in Cosmos DB (Table API).
4. The updated count is returned to the frontend and rendered on the page.

All infrastructure is provisioned with Terraform and deployed automatically using GitHub Actions with OIDC authentication.

---

## Components

### Frontend

* Static HTML, CSS, and JavaScript
* Hosted on Azure Storage Static Website
* API endpoint injected at deploy time
* Light/dark theme toggle with local preference storage

### Backend API

* Python Azure Function (HTTP trigger)
* Stateless function execution
* Cosmos DB Table API used for simple key-value persistence

### Data Layer

* Azure Cosmos DB (Serverless, Table API)
* Single table storing a global visitor counter
* Designed for low operational overhead

### Infrastructure

* Terraform-managed Azure resources
* Modular Terraform design
* Remote Terraform state stored in Azure Storage
* Azure-managed identities used for resource access

---

## CI/CD

GitHub Actions is used to fully automate provisioning and deployment:

* **Pull Requests**

  * Terraform init, validate, and plan
  * Terraform plan output posted as a PR comment

* **Main Branch Pushes**

  * Terraform apply to provision or update infrastructure
  * Frontend assets uploaded to Azure Storage
  * Azure Function packaged and deployed

Authentication to Azure is handled using OIDC. No static cloud credentials are stored in the repository.

---

## Security Considerations

* No secrets are committed to source control
* Azure authentication uses OIDC and Managed Identities
* Sensitive Terraform outputs are marked appropriately
* CORS restrictions limit API access to the deployed static site

---

## Repository Structure

```
azure-serverless-portfolio/
├── app/
│   ├── web/            # Static frontend
│   └── api/            # Azure Function (Python)
├── infra/              # Terraform infrastructure
│   └── modules/        # Reusable Terraform modules
└── .github/            # GitHub Actions workflows
```

---

## Purpose

This repository is intended as a reference implementation demonstrating:

* Serverless application architecture on Azure
* End-to-end automation using Terraform and GitHub Actions
* Secure, credential-free CI/CD with OIDC
* Clean separation between application code and infrastructure

The project favors clarity, safety, and maintainability over feature depth.
