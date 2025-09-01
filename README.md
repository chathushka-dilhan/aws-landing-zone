# AWS Landing Zone using Terraform

This project uses Terraform to build and manage a secure, multi-account AWS environment based on best practices.

- [Architectural Overview & Design Decisions](./docs/architecture.md)

## ✨ Core Features

- **Multi-Account Structure:** Uses AWS Organizations to isolate workloads into Security, Networking, and Application accounts.
- **Secure Networking:** A central "hub-and-spoke" network model using AWS Transit Gateway.
- **Automated Governance:** Sentinel policies are automatically checked on every pull request to prevent misconfigurations.
- **CI/CD Automation:** GitHub Actions automate the entire plan and apply cycle. All changes are managed through Git.

## 🚀 How It Works: The Workflow

1. **Create a Branch:** Start a new branch for your infrastructure change.
2. **Write Code:** Modify the Terraform configurations in the terraform/live directory.
3. **Open a Pull Request:** When you open a PR, a GitHub Action automatically runs terraform plan and checks your code against the Sentinel policies. The plan output is posted as a comment.
4. **Merge to Deploy:** After the PR is reviewed and approved, merge it into the main branch. A second GitHub Action will automatically run terraform apply to deploy your changes.

## 📂 Repository Structure

- `/.github/workflows/`: Contains the CI/CD automation for planning and applying Terraform changes.
- `/sentinel/`: Holds all Policy-as-Code files for security and governance checks.
- `/terraform/modules/`: Contains the reusable building blocks of our infrastructure (like a VPC or a security group).
- `/terraform/live/`: Contains the specific configurations for each of our AWS accounts (management, networking, workloads). This is where you'll make most of your changes.

## 🛠️ Initial Setup

Before you begin, you need to set up the remote backend for Terraform. This is a one-time command.

```bash
# 1. Configure your AWS credentials
export AWS_REGION="us-east-1"

# 2. Initialize and apply the bootstrap configuration
cd terraform/live/_bootstrap
terraform init
terraform apply
```

After this, all other deployments are handled through the GitHub Pull Request workflow.

