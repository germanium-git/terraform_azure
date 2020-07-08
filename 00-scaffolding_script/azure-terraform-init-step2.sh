#!/bin/bash

# sets subscription;
az account set --subscription $subscriptionId

# get vault
export vaultName=$(az keyvault list --subscription=$subscriptionId -g $rg --query '[0].{name:name}' -o tsv)

## extracts and exports secrets
export saKey=$(az keyvault secret show --subscription=$subscriptionId --vault-name="$vaultName" --name sa-key --query value -o tsv)
export saName=$(az keyvault secret show --subscription=$subscriptionId --vault-name="$vaultName" --name sa-name --query value -o tsv)
export scName=$(az keyvault secret show --subscription=$subscriptionId --vault-name="$vaultName" --name sc-name --query value -o tsv)
export spSecret=$(az keyvault secret show --subscription=$subscriptionId --vault-name="$vaultName" --name sp-secret --query value -o tsv)
export spId=$(az keyvault secret show --subscription=$subscriptionId --vault-name="$vaultName" --name sp-id --query value -o tsv)
export tenantId=$(az keyvault secret show --subscription=$subscriptionId --vault-name="$vaultName" --name tn-id --query value -o tsv)

# exports secrets
export ARM_SUBSCRIPTION_ID=$subscriptionId
export ARM_TENANT_ID=$tenantId
export ARM_CLIENT_ID=$spId
export ARM_CLIENT_SECRET=$spSecret

# runs Terraform init
terraform init -input=false \
  -backend-config="access_key=$saKey" \
  -backend-config="storage_account_name=$saName" \
  -backend-config="container_name=$scName"
