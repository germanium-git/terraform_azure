# Scaffold a production-ready Terraform project

Scripts to ease terraform project scaffolding on Azure. It's a modified version of the scrips described in the article [Using Terraform with Azure — the right way](https://medium.com/01001101/using-terraform-with-azure-the-right-way-35af3b51a6b0) with a difference that the service principal account already exists. This has been created for the environment with a limitied permissions where a new SP account can't be created.
The scripts create a new storage blob in Azure to store tfstate file and also Azure keyvault to store credentials that are used by terraform. The credentials are retrieved into environmental variables and used by terraform when it's being initiated.


## How to use the script
Login to Azure in azure cli

![](pictures/az-login.png)

Export the location and the resource group name where the vault and blob storage is to be deployed in environmental variables. Also the subscription ID needs to be exported to the environmental variable to get these resources created.   

```shell
# Specify subscription
export subscriptionId="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# Specify the resource group
export rg="my-resource-group"
# Specify the location
export location="West Europe"
# Specify an existing service principal name
export spName="yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
```

- execute the azure-terraform-init-step1.sh
- execute the azure-terraform-init-step2.sh

Terraform gets initiated with the backend configuration using the blob storage for tfstate file. 
![](pictures/terraform-init.png) 

All secrets are stored in the vault. 
![](pictures/vault_secrets.png)

Continue with defining Azure resources from your project in *.tf file to be deployed in the cloud infra.
