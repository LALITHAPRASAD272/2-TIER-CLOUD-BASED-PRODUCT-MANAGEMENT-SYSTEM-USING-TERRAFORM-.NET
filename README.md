# 🚀 Terraform-Based 2-Tier Product Management System (.NET + AWS)

## 📌 Overview
This project demonstrates the deployment of a scalable **2-tier cloud architecture** on AWS using **Infrastructure as Code (IaC)** with Terraform.

The application is built using **.NET 8 Web API** and deployed on an EC2 instance, while the database layer is managed using **Amazon RDS (MySQL)**.

---

## 🏗️ Architecture


User → EC2 (.NET Web API) → RDS (MySQL Database)


### 🔹 Layers:
- **Application Layer** → EC2 Instance running .NET API
- **Database Layer** → Amazon RDS MySQL

---

## ⚙️ Technologies Used

- .NET 8 Web API  
- Entity Framework Core (EF Core)  
- Pomelo MySQL Provider  
- Terraform (IaC)  
- AWS EC2  
- AWS RDS (MySQL)  
- Amazon Linux 2023  
- REST API  

---

## 📂 Project Structure


terraform-dotnet/
│
├── provider.tf
├── vpc.tf
├── subnet.tf
├── sg.tf
├── ec2.tf
├── rds.tf
├── variables.tf
├── outputs.tf
├── userdata.sh


---

## 🚀 Features

- Full CRUD operations for products  
- Automated infrastructure provisioning  
- Secure communication between EC2 and RDS  
- Database auto-creation using EF Core  
- Fully automated application deployment  

---

## 🔐 Security Configuration

### EC2 Security Group
- Port 22 → SSH Access  
- Port 5001 → Application Access  

### RDS Security Group
- Port 3306 → Allowed only from EC2  

✔ Database is not publicly accessible  
✔ Follows least privilege principle  

---

## ⚡ Deployment Steps

### 1. Initialize Terraform
```bash
terraform init
2. Apply Infrastructure
terraform apply
3. Access Application
http://<EC2_PUBLIC_IP>:5001/api/products

🔄 API Endpoints
Method	Endpoint	Description
GET	/api/products	Get all products
GET	/api/products/{id}	Get product
POST	/api/products	Create product
PUT	/api/products/{id}	Update product
DELETE	/api/products/{id}	Delete product

🧠 Key Learnings
Infrastructure as Code (Terraform)
AWS Networking (VPC, Subnets, Security Groups)
EC2 provisioning with user_data
RDS database integration
Debugging cloud-init and deployment issues
.NET API deployment in cloud

⚠️ Challenges & Solutions
Challenges
user_data script failures
Package compatibility issues
.NET environment configuration
Solutions
Used templatefile() for user_data
Fixed Amazon Linux package issues
Configured environment variables (HOME)
Added logging for debugging

🎯 Outcome
Successfully deployed a 2-tier architecture using Terraform
Fully automated application provisioning
Secure and scalable cloud-based API system

📈 Future Enhancements
Add Load Balancer (ALB)
Auto Scaling Group
Docker containerization
CI/CD pipeline (GitHub Actions)
