#  Strapi Deployment using Terraform, Docker & AWS ALB

##  Project Overview

This project demonstrates an end-to-end deployment of a **Strapi CMS application** using:

* **Terraform** for Infrastructure as Code
* **Docker** for containerization
* **AWS EC2** for compute
* **AWS Application Load Balancer (ALB)** for traffic routing

The Strapi application is containerized, pushed to Docker Hub, deployed on EC2, and accessed via ALB.

---

##  Architecture

```
User → Application Load Balancer → Target Group → EC2 → Docker → Strapi
```

---

##  Tech Stack

* AWS EC2
* AWS ALB
* AWS Target Groups
* AWS VPC
* Terraform
* Docker
* Docker Hub
* Strapi (Node.js CMS)

---

##  Project Structure

```
terraform-strapi-docker/
│
├── modules/
│   ├── vpc/
│   ├── security/
│   ├── alb/
│   └── ec2-strapi/
│
├── environments/
│   ├── dev.tfvars
│   └── prod.tfvars
│
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
└── .gitignore
```

---

##  Prerequisites

Make sure you have installed:

* Terraform
* AWS CLI
* Docker
* Git

Configure AWS credentials:

```bash
aws configure
```

---

##  Docker Image Build & Push

Build Strapi image:

```bash
docker build -t <dockerhub-username>/strapi:latest .
```

Push to Docker Hub:

```bash
docker push <dockerhub-username>/strapi:latest
```

---

## ☁️ Terraform Deployment Steps

### 1️ Initialize Terraform

```bash
terraform init
```

---

### 2️ Validate

```bash
terraform validate
```

---

### 3️ Plan

```bash
terraform plan -var-file=environments/dev.tfvars
```

---

### 4️ Apply

```bash
terraform apply -var-file=environments/dev.tfvars
```

Type:

```
yes
```

Terraform will create:

* VPC
* Subnets
* Security Groups
* ALB
* Target Group
* EC2 Instance
* Docker-based Strapi container

---

##  Access Strapi

After deployment, get ALB DNS from Terraform output or AWS console.

Open:

```
http://<ALB-DNS>/admin
```

Create admin user and log in.

---


##  Security Implementation

* Security Groups control inbound traffic
* ALB handles public access
* EC2 runs Docker container securely
* SSH restricted (if configured)

---

## 📚 Key Learnings

* Infrastructure as Code (IaC)
* Containerized deployments
* AWS Load Balancing
* Terraform modular design
* Docker image lifecycle
* Production-style architecture

---

##  Cleanup

To destroy infrastructure:

```bash
terraform destroy -var-file=environments/dev.tfvars
```

---



Give it a star on GitHub ⭐
