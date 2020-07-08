#!/bin/bash
set -e
az account set --subscription $subscriptionId
# customize if needed
export rg=$rg
export sku="Standard_LRS"
export vaultName="tfstate$RANDOM$RANDOM"
export saName="tfstate$RANDOM$RANDOM"
export scName="tfstate$RANDOM$RANDOM"
export credDescr="terraform$RANDOM"
# creates a new resource group which will be used for the vault and tf state file
az group create --name "$rg" \
    --location "$location" \
    --subscription="$subscriptionId"
if test $? -ne 0
then
    echo "resource group couldn't be created..."
 exit
else
    echo "resource group created..."
fi
# creates a vault to store secrets
az keyvault create --name "$vaultName" \
    --resource-group $rg \
    --location "$location" \
    --subscription=$subscriptionId
if test $? -ne 0
then
    echo "vault couldn't be created..."
 exit
else
    echo "vault created..."
fi
# creates storage account used by tf
az storage account create --resource-group $rg \
    --name $saName \
    --sku $sku \
    --encryption-services blob \
    --subscription=$subscriptionId
if test $? -ne 0
then
    echo "storage account couldn't be created..."
 exit
else
    echo "storage account created..."
fi
# gets storage account key
export accountKey=$(az storage account keys list --subscription=$subscriptionId --resource-group $rg --account-name $saName --query [0].value -o tsv )
# creats storage container used by tf
az storage container create --name $scName --account-name $saName --account-key $accountKey
if test $? -ne 0
then
    echo "storage container couldn't be created..."
 exit
else
    echo "storage container created..."
fi
# saves secrets to vault
az keyvault secret set --vault-name $vaultName \
    --name "sa-key" \
    --value "$accountKey"
az keyvault secret set --vault-name $vaultName \
    --name "sa-name" \
    --value "$saName"
az keyvault secret set --vault-name $vaultName \
    --name "sc-name" \
    --value "$scName"
if test $? -ne 0
then
    echo "secrets couldn't be saved..."
 exit
else
    echo "secrets are saved in vault..."
fi

# creates new credentials to the existing service principal used by tf
echo "Creating new credentials for service principal $spName"
export sp=$(az ad sp credential reset --name $spName --years 99 --append --credential-description $credDescr)
if test $? -ne 0
then
    echo "credentials couldn't be created..."
 exit
else
    echo "new credentials $credDescr added..."
fi
# tshoot output
echo $sp
# gets id secret and tenant
# appId
export spId=$(echo $sp | awk '{print $7}')
# password
export spSecret=$(echo $sp | awk '{print $3}')
# tenant
export tnId=$(echo $sp | awk '{print $9}')

echo $spId
echo $spSecret
echo $tnId

# save secrets to vault
az keyvault secret set --vault-name $vaultName --name "sp-id" --value "$spId"
az keyvault secret set --vault-name $vaultName --name "sp-secret" --value "$spSecret"
az keyvault secret set --vault-name $vaultName --name "tn-id" --value "$tnId"

if test $? -ne 0
then
    echo "secrets couldn't be saved..."
 exit
else
    echo "secrets are saved in vault..."
fi
