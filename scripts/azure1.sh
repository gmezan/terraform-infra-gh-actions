# 1
az group create --name $RG_NAME \
        --location $AZ_REGION

# 2
az storage account create \
        --name $AZ_STAC_NAME \
        --resource-group $RG_NAME \
        --location $AZ_REGION \
        --sku Standard_LRS

# 3
az storage container create \
        --name tfstate \
        --account-name $AZ_STAC_NAME \
        --auth-mode login

# 4
az identity create --name $ID_INFRA_NAME \
        --resource-group $RG_NAME \
        --location $AZ_REGION
