# Hacking Lab Terraform Documentation

## Project Overview

This Terraform project provisions a security testing/hacking lab environment in AWS. It creates an EC2 instance running Ubuntu 18.04 and deploys four vulnerable applications as Docker containers for security testing and learning purposes.

## Architecture

### Core Components

1. **EC2 Instance**: Ubuntu 18.04 (t2.large) hosting Docker containers
2. **Security Groups**: Controls access to the vulnerable applications
3. **Docker Containers**: Four vulnerable applications for security testing

### Security Configuration

- Access is restricted to the user's external IP address and an allowed IP whitelist
- SSH access is provided via key-based authentication
- All vulnerable applications are accessible only from authorized IP addresses

### Applications Deployed

| Application | Port | Description |
|-------------|------|-------------|
| Hackazon    | 80   | All-in-one web application with vulnerabilities |
| DVWA        | 81   | Damn Vulnerable Web Application |
| Juice Shop  | 82   | OWASP Juice Shop (vulnerable web app) |
| Shellshock  | 8080 | Container vulnerable to CVE-2014-6271 |

## File Structure

### backend.tf
Configures Terraform Cloud as the backend for state management:
- Organization: `dv_aws_cloud_org`
- Workspace: `sandbox-13`

### get_ami_image.tf
Defines a data source to find the latest Ubuntu 18.04 AMI:
- Uses filters to specify Ubuntu Bionic 18.04 with HVM virtualization
- Owner is Canonical (099720109477)

### get_external_ip.tf
Creates an HTTP data source to get the user's current external IP address:
- Uses the icanhazip.com service

### install_lab.sh
Bash script that runs on instance startup:
- Installs Docker and Git
- Deploys four vulnerable applications as Docker containers
- Configures each container to listen on a specific port

### main.tf
Defines the EC2 instance resource:
- Uses the Ubuntu AMI from the data source
- Attaches the security group
- Uses user data to run the install script on startup
- Includes a local-exec provisioner to output SSH connection command

### provider.tf
Configures the required providers:
- AWS provider with specified region
- Terraform Enterprise (TFE) provider with token
- Sets minimum version requirements

### security_groups.tf
Creates a security group to control access to the lab:
- Uses a local variable to combine the user's IP and whitelist
- Defines ingress rules for:
  * SSH (port 22)
  * Hackazon (port 80)
  * DVWA (port 81)
  * Juice Shop (port 82)
  * Shellshock (port 8080)
- Defines egress rules for HTTP and HTTPS traffic

### terraform.tfvars
Contains variable values for the deployment:
- Region: us-east-1
- Instance type: t2.large
- SSH key details
- IP whitelist (136.226.59.90)
- Terraform token (sensitive)

### variables.tf
Defines input variables with defaults:
- Includes validation for the tf_token variable
- Variables for region, SSH key configuration, instance type, etc.

## Deployment Workflow

1. Terraform initializes and connects to Terraform Cloud
2. The user's external IP is fetched
3. The latest Ubuntu 18.04 AMI is located
4. Security group is created allowing access only from authorized IPs
5. EC2 instance is provisioned with the specified configuration
6. Install script runs on startup to deploy the vulnerable applications
7. Output shows how to connect to the instance via SSH

## Security Considerations

- The lab contains intentionally vulnerable applications and should be used for learning purposes only
- Access is restricted to specific IP addresses through security groups
- All containers are run with the `--rm` flag to ensure they're removed when stopped
- Consider setting a lifecycle policy to destroy the infrastructure when not in use