Overview:
* AWS credentials stored in home folder
* keypair path and name stored in terraform.tfvars

Instructions:
1. terraform plan -var-file terraform.tfvars
2. terraform apply -var-file terraform.tfvars

Issues:
* Web server has 22 open to world instead of behind bastion. public.tf:30

Chef Server Setup:
1. cd ~
2. wget https://packages.chef.io/files/stable/chef-server/12.17.3/ubuntu/16.04/chef-server-core_12.17.3-1_amd64.deb
3. sudo dpkg -i chef-server-core_*.deb
4. Change Hostname
  * vi /etc/hostname and replace with Public DNS name ec2-52-3-69-XXX.compute-1.amazonaws.com
5. Reboot
6. Create Certificate and Keys
  * mkdir ~/cert_and_keys; cd ~/cert_and_keys
7. Generate Private Key
  * openssl genrsa -des3 -out server.key 1024
8. Generate a CSR (using ec2-52-3-69-XXX.compute-1.amazonaws.com as hostname)
  * openssl req -new -key server.key -out server.csr
9. Remove Passphrase from Key
  * cp server.key server.key.org
  * openssl rsa -in server.key.org -out server.key
10. Generate a Self-signed Certificate
  * openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
11. vi /etc/opscode/chef-server.rb
```
server_name = "ec2-52-3-69-XXX.compute-1.amazonaws.com"
api_fqdn "ec2-52-3-69-XXX.compute-1.amazonaws.com"
bookshelf['vip'] = server_name
nginx['url'] = "https://#{server_name}"
nginx['ssl_certificate'] = "~/cert_and_keys/server.crt"
nginx['ssl_certificate_key'] = "~/cert_and_keys/server.key"
```
12. sudo chef-server-ctl reconfigure
13. sudo chef-server-ctl user-create ${chef_server_admin_username} ${chef_server_admin_firstname} ${chef_server_admin_lastname} ${chef_server_admin_email} ${chef_server_admin_password} -f ${chef_server_admin_username}.pem
14. sudo chef-server-ctl org-create ${chef_server_org_shortname} \"${chef_server_org_longname}\" --association_user ${chef_server_admin_username} -f ${chef_server_org_shortname}-validator.pem
