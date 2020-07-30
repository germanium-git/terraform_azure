$vaultname = "myvaultname"
$subscriptionId="mysubscriptionid"

$tnId = (Get-AzKeyVaultSecret -VaultName $vaultname -Name tn-id).SecretValueText
$spId = (Get-AzKeyVaultSecret -VaultName $vaultname -Name sp-id).SecretValueText
$spSecret = (Get-AzKeyVaultSecret -VaultName $vaultname -Name sp-secret).SecretValueText
$scName = (Get-AzKeyVaultSecret -VaultName $vaultname -Name sc-name).SecretValueText
$saName = (Get-AzKeyVaultSecret -VaultName $vaultname -Name sa-name).SecretValueText
$saKey = (Get-AzKeyVaultSecret -VaultName $vaultname -Name sa-key).SecretValueText

Write-Output "The storage account name is - $saName"
Write-Output "The storage account key is - $saKey"
Write-Output "The container name is - $scName"
Write-Output "The Service principal secret is - $spSecret"
Write-Output "The Service principal ID is - $spId"
Write-Output "The tenanant ID is - $tnId"

$env:ARM_SUBSCRIPTION_ID=$subscriptionId
$env:ARM_CLIENT_ID=(Get-AzKeyVaultSecret -VaultName $vaultname -Name sp-id).SecretValueText.Trim('"')
$env:ARM_CLIENT_SECRET=(Get-AzKeyVaultSecret -VaultName $vaultname -Name sp-secret).SecretValueText.Trim('"')
$env:ARM_TENANT_ID=(Get-AzKeyVaultSecret -VaultName $vaultname -Name tn-id).SecretValueText.Trim('"')

# Run Terraform init
terraform init -input=false -backend-config="access_key=$saKey" -backend-config="storage_account_name=$saName" -backend-config="container_name=$scName"