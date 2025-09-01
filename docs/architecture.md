# AWS Landing Zone: Architectural Overview & Design Decisions

This document provides a comprehensive overview of the architectural principles, design patterns, and core components used in this AWS Landing Zone. The goal of this architecture is to establish a secure, scalable, cost-efficient, and operationally excellent foundation for deploying all workloads on AWS.

## 1. Guiding Principles

This architecture is founded on four core principles, aligned with the AWS Well-Architected Framework:

- **Security by Design:** Security is not an afterthought. It is built into the foundation by using dedicated security accounts, proactive policy enforcement, centralized logging, and a network model that defaults to strict isolation.
- **Scalability through Modularity:** The entire platform is built from reusable, version-controlled modules (Terraform). This allows for the consistent and repeatable creation of new accounts and environments as the organization grows.
- **Governance via Automation:** Human error is minimized by enforcing all infrastructure changes through an automated CI/CD pipeline. Proactive policy checks (Sentinel) prevent misconfigurations before they are ever deployed, ensuring continuous compliance.
- **Cost Optimization:** The architecture provides mechanisms for visibility, control, and optimization of cloud spending from day one through mandatory tagging, centralized budget alerts, and right-sizing policies.

## 2. Multi-Account Strategy (AWS Organizations)

A multi-account environment is the cornerstone of a secure and scalable cloud platform. We use **AWS Organizations** to centrally manage and govern our accounts, which are structured into logical groups called Organizational Units (OUs). This strategy provides the highest level of resource and billing isolation.

### Organizational Unit (OU) Structure

- `Security OU`: This OU contains accounts dedicated to security and auditing. It has the strictest preventative guardrails (Service Control Policies - SCPs) applied to it.

    - `Log Archive Account`: The designated home for immutable, centralized logs from across the entire organization (e.g., AWS CloudTrail, VPC Flow Logs, AWS Config history). Access is highly restricted, even for administrators.
    - `Security Tooling Account`: Hosts organization-wide security services like Amazon GuardDuty, AWS Security Hub, and IAM Access Analyzer. This allows our security team to have centralized visibility without needing administrative access to every account.

- `Infrastructure OU`: Manages shared services for the entire organization.

    - `Network Account`: Contains the core networking components, including the AWS Transit Gateway hub and centralized internet egress/ingress points.

- `Workloads OU`: This is where business applications reside. It can be further subdivided (e.g., Prod, Dev, Test) to isolate environments and apply different policies to each.
- `Sandbox OU`: Provides a space for developers to experiment with AWS services. These accounts have loose permissions but are isolated from the rest of the network and have strict spending limits enforced by AWS Budgets.

## 3. Identity and Access Management (IAM Identity Center)

We avoid the use of persistent, long-lived IAM users. Instead, access is managed centrally and based on the principle of least privilege.

- **Federated Access:** AWS IAM Identity Center (formerly AWS SSO) is the single entry point for all human access to AWS accounts. It is integrated with our corporate Identity Provider (e.g., Azure AD, Okta), allowing users to log in with their existing company credentials.
- **Centralized Permissions:** We define Permission Sets (e.g., `Administrator`, `PowerUser`, `ViewOnly`) centrally in IAM Identity Center. These permission sets are then assigned to corporate user groups. This decouples user management from permission management, making it highly scalable. An employee joining the "DevOps" group in Azure AD automatically gets the `Administrator` permission set across the development accounts.

## 4. Network Architecture (Hub-and-Spoke Model)

To avoid the complexity and cost of a mesh network, we implement a **Hub-and-Spoke** topology using **AWS Transit Gateway (TGW)**.

- **The Hub (Network Account):** The TGW resides in the central Network account. This account acts as the cloud network router. All centralized services are deployed here, including:

    - NAT Gateways for controlled internet egress.
    - AWS Network Firewall or third-party firewall appliances for traffic inspection.
    - VPN and Direct Connect endpoints.

- **The Spokes (Workload Accounts):** Each VPC in a workload account is a "spoke." It attaches to the central TGW.
- **Traffic Flow & Isolation:**

    - By default, spokes cannot communicate with each other. Routing is explicitly enabled in the TGW route tables, ensuring strict network segmentation (e.g., Dev cannot talk to Prod).
    - All traffic destined for the internet from a private subnet in a spoke VPC is routed through the TGW to the central NAT Gateways in the hub. This centralizes egress control and monitoring.

- **Resource Sharing:** The Transit Gateway is created in the Network account and shared with the other accounts in the organization using **AWS Resource Access Manager (RAM)**.

## 5. Security & Compliance

Security is implemented in layers throughout the landing zone.

- **Encryption:** Data is encrypted at rest and in transit by default.

    - *At Rest:* We enforce the encryption of EBS volumes, S3 buckets, and RDS databases, primarily using AWS-managed keys (KMS) for ease of use, with the option for Customer-Managed Keys for sensitive workloads.
    - *In Transit:* All communication between VPCs over the Transit Gateway is on the private AWS backbone. We enforce TLS 1.2 or higher for all public-facing endpoints.

- **Centralized Logging:** As described in the `Security OU`, all API calls (CloudTrail), network flows (VPC Flow Logs), and configuration changes (AWS Config) are shipped to the Log Archive S3 bucket. This bucket is configured with Object Lock (WORM model) to make logs immutable for forensic and compliance purposes.
- **Threat Detection:** Amazon GuardDuty is enabled organization-wide and managed from the Security Tooling account. It continuously monitors for malicious activity and unauthorized behavior.

- **Compliance Monitoring:** AWS Security Hub is also enabled organization-wide to provide a single pane of glass for security and compliance. It aggregates findings from GuardDuty, IAM Access Analyzer, and AWS Config, and automatically runs checks against standards like the CIS AWS Foundations Benchmark.

## 6. Cost Management

Proactive cost management is integrated into the landing zone's governance model.

- **Tagging Enforcement:** A Sentinel policy (`enforce-tags.sentinel`) integrated into our CI/CD pipeline requires that all core resources are deployed with `cost-center` and `owner` tags. This is critical for accurate cost allocation.
- **Budgetary Controls:** AWS Budgets are automatically deployed in every new account via the aws-account-bootstrap module. They are configured to send alerts to designated stakeholders when forecasted or actual spending exceeds predefined thresholds.
- **Centralized Visibility:** AWS Cost Explorer is enabled at the organization level, allowing the finance and cloud center of excellence teams to analyze cost and usage data across the entire multi-account environment from the management account.

## 7. Governance and CI/CD Workflow (GitOps)

All infrastructure is code, and all changes follow a structured, automated GitOps workflow. This repository is the single source of truth.

1. **Pull Request:** A developer makes infrastructure changes on a feature branch and opens a pull request against the main branch.
2. **Plan & Proactive Check (CI):** This automatically triggers the terraform-plan GitHub Action.

    - It runs `terraform plan` to generate a preview of the changes.
    - It then runs `sentinel apply` on the plan output. Sentinel is our Policy as Code engine that enforces rules like "no public S3 buckets" or "all EC2 instances must be of an approved type."
    - The plan output and Sentinel results are posted as a comment in the PR. A policy violation will fail the build and block the merge.

3. **Review:** The team reviews the secure, compliant, and cost-effective plan within the pull request.
4. **Merge & Apply (CD):** Once the PR is approved and merged, the terraform-apply GitHub Action is triggered.

    - It checks out the code from the `main` branch.
    - It runs `terraform apply -auto-approve` to deploy the validated changes to AWS.

## 8. Onboarding New AWS Accounts

The modular design allows for a streamlined and automated process for creating and configuring new AWS accounts.

- **Account Creation:** A new member account is created in AWS Organizations and placed in the appropriate OU. This can be done via the AWS Console or programmatically.
- **Bootstrap:** The `aws-account-bootstrap` module is applied to the new account. This is a one-time operation that creates the `CICD-Pipeline-Role` necessary for the GitHub Actions pipeline to manage its resources.
- **Define in `live`:** A new configuration directory is created under `terraform/live/workloads/` (e.g., `new-app-prod`).
- **Deploy via PR:** The configuration, calling standard modules like `aws-networking-spoke`, is added to the new directory. A pull request is opened, and upon merging, the CI/CD pipeline automatically provisions the VPC and other baseline resources in the new account, ensuring it is compliant and connected from the start.


