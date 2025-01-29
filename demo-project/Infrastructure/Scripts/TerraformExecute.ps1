$ARM_ACCESS_KEY=$(az storage account keys list --resource-group rg-common --account-name sacommonwesteu01 --query '[0].value' -o tsv)
terraform init 
terraform plan --var-file=$PSScriptRoot/../vars/development.tfvars

 
$confirmation = Read-Host "Do you want launch terraform apply? (y/n)"

if ($confirmation -eq "y") {
    Write-Host "Applying Terraform"
    terraform apply --var-file=$PSScriptRoot/../vars/development.tfvars -auto-approve
} else {
    Write-Host "Exiting"
    exit
}