# VPN with BGP peering between Azure and Juniper SRX

- Create a copy of terraform.tfvars.gittemplate and name it terraform.tfvars
- **Make sure terraform.tfvars won't leak to git repository before filling in sensitive data**
- Update both sensitive variables in terraform.tfvars and other variables in variables.tf

```
terraform init
terraform apply
```