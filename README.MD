# Boba - temp project

## Description
This project utilizes Jenkins for CI/CD and Terraform for infrastructure management on Google Cloud Platform (GCP).

- **Automated Build and Deployment Pipeline**
- **Infrastructure as Code with Terraform**
- **Deployment to Google Cloud Platform**

## CI/CD Pipeline
This project includes CI/CD automation using Jenkins:

- **Jenkinsfile** - is used for the overall pipeline
- **Checkout Stage:** Checks out the source code from the repository.
- **Terraform Init Stage:** Initializes Terraform.
- **Terraform Apply Stage:** Applies Terraform configuration to provision infrastructure.
- **Build Stage:** Installs dependencies using `npm install` and builds the project using `npm run build`.
- **Deploy Stage:** Authenticates with Google Cloud and syncs the built application to a Cloud Storage bucket.

- **Jenkinsfile-destroy** - is used to destroy the project
- **Checkout Stage:** Checks out the source code from the repository.
- **Manual Approval:** Provide a manual approval before completely destroying.
- **Terraform Destroy Stage:** Destroys the provisioned infrastructure on Google Cloud.

## Terraform Configuration
Infrastructure is managed using Terraform:

- **main.tf:**
  - **Google Cloud Storage Bucket:** Creates a storage bucket for static files.
  - **Google Cloud IAM Policy Binding:** Grants permissions to the storage bucket.
  - **Google Cloud Storage Bucket Object:** Uploads built application files to the storage bucket.
  - **Google Cloud Static IP Address:** Creates a static IP address for the application.
  - **Google Cloud Load Balancer:** Configures a load balancer to distribute traffic.
  - **Google Cloud URL Map and Backend Service:** Sets up URL mappings and backend services.
  - **Google Cloud Forwarding Rules:** Defines forwarding rules for traffic routing.

- **provider.tf:** Configures the Google Cloud provider specifies the backend for storing Terraform state files.

### Running Terraform
1. **Initialize Terraform:**
    ```sh
    terraform init
    ```
2. **Apply the configuration:**
    ```sh
    terraform apply -auto-approve
    ```

