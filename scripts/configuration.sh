RG_NAME=rg-infra-state
AZ_REGION=eastus2

# 1
az group create --name $RG_NAME \
        --location $AZ_REGION

# 2
AZ_STAC_NAME=gmezanterraformghactions

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
ID_INFRA_NAME=id-infra-gh-actions
az identity create --name $ID_INFRA_NAME \
        --resource-group $RG_NAME \
        --location $AZ_REGION

# 5
ID_INFRA_SP=""
SUBS_ID=""
az role assignment create --assignee $ID_INFRA_SP \
        --role Contributor \
        --scope $SUBS_ID

# 6
OWNER=gmezan
REPO=azure-infra-deployment
az identity federated-credential create --identity-name $ID_INFRA_NAME \
                                        --name onPullRequest \
                                        --resource-group $RG_NAME \
                                        --audiences api://AzureADTokenExchange \
                                        --issuer https://token.actions.githubusercontent.com \
                                        --subject repo:$OWNER/$REPO:pull_request

az identity federated-credential create --identity-name $ID_INFRA_NAME \
                                        --name onBranch \
                                        --resource-group $RG_NAME \
                                        --audiences api://AzureADTokenExchange \
                                        --issuer https://token.actions.githubusercontent.com \
                                        --subject repo:$OWNER/$REPO:ref:refs/heads/main

az identity federated-credential create --identity-name $ID_INFRA_NAME \
                                        --name onEnvironment \
                                        --resource-group $RG_NAME \
                                        --audiences api://AzureADTokenExchange \
                                        --issuer https://token.actions.githubusercontent.com \
                                        --subject repo:$OWNER/$REPO:environment:azure
