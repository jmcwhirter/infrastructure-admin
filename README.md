Overview:
* AWS credentials stored in home folder
* keypair path and name stored in terraform.tfvars

Instructions:
1. terraform plan -var-file terraform.tfvars
2. terraform apply -var-file terraform.tfvars

Issues:
* Web server has 22 open to world instead of behind bastion. public.tf:30