# Deploying to Azure with Terraform and GitHub Actions

1. In your Azure Subscription, create a Resource Group

    ```sh
    az group create --name rg-infra-state \
        --location eastus2
    ```

1. Create a storage account in the resource group

    ```sh
    az storage account create \
        --name gmezanterraformghactions \
        --resource-group rg-infra-state \
        --location eastus2 \
        --sku Standard_LRS
    ```

1. Create a `tfstate` container in the storage account

    ```sh
    az storage container create \
        --name tfstate \
        --account-name gmezanterraformghactions \
        --auth-mode login
    ```

    This container will be used to store the _tfstate_.

1. Create Managed Identity to login to Azure from Actions

    ```sh
    az identity create --name id-infra-gh-actions \
        --resource-group rg-infra-state \
        --location eastus2
    ```

    ```sh
    

    az role assignment create --assignee <ManagedIdentityServicePrincipal> \
        --role Contributor \
        --scope <StorageAccount-Id>

    az identity federated-credential create --identity-name id-infra-gh-actions \
                                        --name onPullRequest \
                                        --resource-group rg-infra-state \
                                        --audiences api://AzureADTokenExchange \
                                        --issuer https://token.actions.githubusercontent.com \
                                        --subject repo:gmezan/azure-infra-deployment:pull_request


    ```

1. Configure credentials in GH

   Go to the correspondent GH repo. In _Settings_ > _Secrets and variables_ > _Actions_, create the following secrets with the values corresponding to the created managed identity.
   - `AZURE_CLIENT_ID`
   - `AZURE_SUBSCRIPTION_ID`
   - `AZURE_TENANT_ID`

1. Create the environment

   Go to the correspondent repo. In _Settings_ > _Environments_, create the `azure` environment and add the required reviewers.



taking inspiration from https://github.com/Azure-Samples/terraform-github-actions/