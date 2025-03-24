# **Node.js Application - End-to-End Overview**  

![GitHub Repo](https://img.shields.io/badge/GitHub-Repository-blue?style=for-the-badge&logo=github)

## **Overview**  
This project is a **Node.js**-based web application deployed on **AWS EKS (Elastic Kubernetes Service)** using **Helm**. It follows a **microservices architecture** and includes a CI/CD pipeline using **Jenkins**.  

### **Key Components**  
- **Backend**: Node.js (Express.js) API handling business logic.  
- **Frontend**: React.js for the user interface.  
- **Database**: MONGODB in ASW DOCUMENTDB if your are using Mysql then use  (AWS RDS).  
- **WebSocket Service**: Handles real-time communication.  
- **Containerization**: Dockerized microservices.  
- **Orchestration**: Kubernetes (EKS) for high availability.  
- **CI/CD Pipeline**: Jenkins automates build, testing, and deployment.  

---

## **Tech Stack**  
| Component     | Technology |
|--------------|------------|
| **Backend**  | Node.js (Express.js) |
| **Frontend** | React.js |
| **Database** | MongoDB in AWS DocunentDB if you are Mysql then use  (AWS RDS) |
| **Containerization** | Docker |
| **Orchestration** | Kubernetes (EKS) |
| **CI/CD** | Jenkins, Helm, AWS ECR |
| **Cloud Provider** | AWS | US-EAST-1 

---

## **Architecture Diagram**  

```
User → React.js Frontend → Node.js Backend → MySQL RDS
       ↓                     ↓
  Kubernetes (EKS) ← Helm ← Jenkins CI/CD
```

---

## **Project Structure**  

```
nodejs-app/
│── backend/           # Node.js (Express.js) API
│── frontend/          # React.js frontend
│── socket/            # WebSocket service
│── k8s/               # Kubernetes YAML manifests
│── helm/              # Helm charts for deployment
│── Jenkinsfile        # CI/CD pipeline automation
│── docker-compose.yaml # Local testing setup
│── README.md          # Project documentation
```

---

## **Deployment Workflow**  

1. **Code Commit & Push**  
   - Developers push changes to the Git repository.  

2. **CI/CD Pipeline (Jenkins)**  
   - Jenkins triggers automated build & tests.  
   - Docker images are built and pushed to AWS ECR.  

3. **Kubernetes Deployment (EKS)**  
   - Helm deploys the application to Kubernetes.  
   - Rolling updates ensure zero downtime.  

4. **Monitoring & Logging**  
   - Prometheus & Grafana for monitoring.  
   - AWS CloudWatch for logs.  

---

## **Installation & Setup**  

### **1. Clone the Repository**  
```bash
git clone https://github.com/vijayrajuyj1/eshop-end-to-end.git
cd nodejs-app
```

### **2. Run Locally using Docker Compose**  
```bash
docker-compose up -d
```

### **3. Build & Push Docker Image**  
```bash
docker build -t your-backend-image:latest ./backend
docker tag your-backend-image:latest <AWS_ECR_URL>/your-backend-image:latest
docker push <AWS_ECR_URL>/your-backend-image:latest
```
**Note: Perform Step3 for Frontend and Socket to create Docker images**

### **4. Deploy to Kubernetes (EKS) using Helm after Helm installation follow the below command **  
```bash
helm install demo2 ./demo1
```

---

## **Environment Variables**  

| Variable Name       | Description                        | Example Value |
|---------------------|-----------------------------------|--------------|
| `DB_HOST`          | Mongodb Database Host               | `MongoDB Url |
| `DB_USER`          | MySQL Username                    | `admin` |
| `DB_PASSWORD`      | MySQL Password                    | `securepassword` |
| `EKS_CLUSTER`      | Kubernetes Cluster Name           | `nodejs-cluster` |
| `AWS_REGION`       | AWS Deployment Region



---

### 📩 Contact

**Vijayaraju DevOps and Cloud Engineer**  
📧 Email: [vijayaraju7360@gmail.com](mailto:vijayaraju7360@gmail.com)
