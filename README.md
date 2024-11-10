# Networkslab-assignment: Docker Installation on EC2 using Ansible

This project demonstrates how to use Ansible with GitHub Actions to configure an AWS EC2 instance by installing Docker and setting up dependencies. The setup is automated through a CI/CD pipeline that triggers on pushes to the main branch.

## Project Structure

NETWORKLAB-ASSIGNMENT/ 
├── ec2_key.pem # Private key file for SSH access to the EC2 instance (add this to GitHub secrets)
├── Ansible/ 
    ├── inventory.ini # Inventory file with the EC2 host details 
    │ 
    └── docker-install.yml # Ansible playbook for Docker installation on EC2 
└── .github/ 
    └── workflows/  
        └── aws_cicd.yml # GitHub Actions workflow to deploy python code to EC2 Instance 
        └── install_docker.yml # GitHub Actions workflow to trigger the Ansible playbook
└── docker/ 
    └── app/  
        └── app.py #python code for displaying message (Networks Project Completed !!!!! )
    └── Dockerfile #Docker file for building the docker image of the python code

## Prerequisites

- **AWS EC2 Instance**: Ensure that have an EC2 instance running and accessible with an SSH key.
- **GitHub Secrets**:
  - `EC2_SSH_KEY`: Add the private key `ec2_key.pem` as a GitHub secret for secure access to the EC2 instance.
- **Permissions**: Ensure the EC2 instance's security group allows inbound SSH (port 22) and Docker traffic if needed.

## File Descriptions

### 1. `inventory.ini`

Defines the EC2 host with SSH connection details. Update the IP address as per your EC2 instance.

```ini
[arya]
52.49.140.87 ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa

