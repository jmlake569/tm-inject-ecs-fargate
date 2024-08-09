# Multi-Project Repository

This repository contains multiple projects related to infrastructure deployment and management using Terraform and GitHub Actions.

## Projects Overview

1. **ECS Cluster Deployment with NGINX**: Deploys an ECS cluster with an NGINX container using Terraform and AWS.
2. **Task Definitions Management with Terraform Scripts**: Manages ECS task definitions using Terraform that calls custom scripts.
3. **Task Definitions Management with GitHub Actions**: Manages ECS task definitions using GitHub Actions with inline code.

## ECS Cluster Deployment with NGINX

### Description

This project deploys an ECS cluster with an NGINX container using Terraform. The workflow is defined in the `deploy_ecs_cluster_with_nginx.yaml` file.

### Workflow File

The workflow file (`deploy_ecs_cluster_with_nginx.yaml`) performs the following tasks:
- Checks out the repository code.
- Configures AWS credentials using an IAM Role.
- Installs Terraform.
- Initializes, validates, plans, and applies the Terraform configuration.

### Setup Instructions

1. **Add GitHub Secrets**:
   - Go to your GitHub repository settings.
   - Add a new secret named `AWS_GH_ROLE_ARN` with the ARN of the IAM Role that GitHub Actions will assume.

2. **Customize the Terraform Configuration**:
   - Modify the Terraform configuration files in the repository to define the infrastructure you want to deploy.

3. **Trigger the Workflow**:
   - Manually trigger the workflow using the `workflow_dispatch` event from the GitHub Actions tab in your repository.

## Task Definitions Management with Terraform Scripts

### Description

This project manages ECS task definitions using Terraform that calls custom scripts. The Terraform configuration is defined in the `main.tf` file.

### Terraform Configuration

The `main.tf` file includes the following resources:
- **AWS Provider**: Configures the AWS provider with the desired region.
- **Fetch Task Definitions**: Runs a script to fetch task definitions.
- **Patch Task Definitions**: Runs a script to patch task definitions.
- **Register Task Definitions**: Runs a script to register patched task definitions.

### Setup Instructions

1. **Ensure Scripts are Executable**:
   - Make sure the scripts in the `scripts` directory are executable. You can run `chmod +x scripts/*.sh` to make them executable.

2. **Customize the Scripts**:
   - Modify the scripts in the `scripts` directory to suit your requirements.

3. **Run Terraform**:
   - Initialize Terraform: `terraform init`
   - Validate the configuration: `terraform validate`
   - Plan the deployment: `terraform plan`
   - Apply the configuration: `terraform apply`

## Task Definitions Management with GitHub Actions

### Description

This project manages ECS task definitions using GitHub Actions with inline code. The workflow is defined in the `deploy_task_definitions.yaml` file.

### Workflow File

The workflow file (`deploy_task_definitions.yaml`) performs the following tasks:
- Checks out the repository code.
- Configures AWS credentials using an IAM Role.
- Fetches, patches, and registers ECS task definitions using inline code.

### Setup Instructions

1. **Add GitHub Secrets**:
   - Go to your GitHub repository settings.
   - Add a new secret named `AWS_GH_ROLE_ARN` with the ARN of the IAM Role that GitHub Actions will assume.

2. **Customize the Inline Code**:
   - Modify the inline code in the workflow file to suit your requirements.

3. **Trigger the Workflow**:
   - Manually trigger the workflow using the `workflow_dispatch` event from the GitHub Actions tab in your repository.

## Common Setup Instructions

1. **Install Terraform**:
   - Follow the instructions on the [Terraform website](https://www.terraform.io/downloads.html) to install Terraform.

2. **Configure AWS CLI**:
   - Ensure the AWS CLI is installed and configured with the necessary credentials.

## License

This project is licensed under the MIT License - see the LICENSE file for details.