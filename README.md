# Hello Logger App

A containerised logging platform with backend and frontend apps deployed to Azure Container Apps. This project demonstrates infrastructure provisioning and deployment automation using Terraform and GitHub Actions on Azure.

---

## Project Overview

This project consists of a Node.js & Express backend API to receive and store log messages, and a frontend UI to send logs and view a real-time dashboard of received logs. The backend and frontend run as containerized apps deployed to Azure Container Apps, with all Azure infrastructure provisioned via Terraform.

---

## Technology Stack

- **Azure Container Apps Environment** — Managed environment for hosting containerized applications  
- **Azure Log Analytics Workspace** — Centralised monitoring and diagnostics for container apps  
- **Azure Container Registry (ACR)** — Container registry for backend and frontend images  
- **Azure Resource Group** — Logical container for all Azure resources  
- **Terraform** — Infrastructure as Code to provision Azure resources  
- **GitHub Actions** — CI/CD pipeline for building, pushing Docker images, and deploying container apps  
- **Node.js & Express** — Backend API to handle log messages 
- **JavaScript, HTML, CSS** — Frontend UI for sending logs  

---

## Features

- Receive and store logs in memory via REST API  
- Real-time logs dashboard with auto-refresh and clear functionality  
- Backend and frontend deployed as scalable container apps on Azure  
- Infrastructure provisioning fully automated with Terraform  
- CI/CD pipeline automatically builds, pushes, and deploys Docker images on push to main branch via Github Actions  

---

## Setup & Deployment

### Prerequisites

- Azure subscription with permissions to create Container Apps, ACR, Log Analytics, etc.
- Azure CLI installed and logged in  
- Terraform CLI (version 1.5 or later recommended)  
- Docker installed locally  
- GitHub repository with GitHub Actions enabled and configured secrets:  
  - `AZURE_CREDENTIALS` (service principal JSON)  
  - `ACR_LOGIN_SERVER`  
  - `RESOURCE_GROUP`  
  - `BACKEND_CONTAINER_NAME`  
  - `FRONTEND_CONTAINER_NAME`

### Infrastructure Provisioning

Terraform provisions the following Azure resources:  
- Resource Group  
- Azure Container Apps Environment  
- Azure Log Analytics Workspace  
- Azure Container Registry (ACR)  
- Backend and Frontend Azure Container Apps  

### CI/CD Pipeline

- On push to `main` branch, GitHub Actions:  
  - Checks out code  
  - Logs in to Azure and ACR  
  - Builds and pushes backend and frontend Docker images  
  - Deploys updated images to Azure Container Apps  
  - Activates latest revisions  

### How to Use

- Use the frontend UI to send logs with different levels (info, debug, warning, error)  
- View received logs and statistics on the real-time dashboard  
- Clear logs via the dashboard interface as needed  

---

## Challenges & Learnings

- Managing Terraform remote state with Azure Blob Storage ensured safe multi-user state management  
- Integrating Azure Log Analytics allowed real-time monitoring of container apps  
- Automating Docker build and deployment through GitHub Actions streamlined delivery  
- Handling in-memory log storage requires consideration for persistence and scaling in production  

---

## License

This project is for educational purposes and is not intended for open-source use.

---

## Contact

For questions or contributions, please create an issue or contact the maintainer via the repository.

