# Deploying Infrastructure to Azure with Terraform and GitHub Actions

1. In your Azure Subscription, create a Resource Group

    ```sh
    az group create --name <Resource-Group-Name> \
        --location <Region>
    ```

1. Create a storage account in the resource group

    ```sh
    az storage account create \
        --name <Storage-Account-Name> \
        --resource-group <Resource-Group-Name> \
        --location <Region> \
        --sku <Sku>
    ```

1. Create a `tfstate` container in the storage account

    ```sh
    az storage container create \
        --name tfstate \
        --account-name <Storage-Account-Name> \
        --auth-mode login
    ```

    This container will be used to store the _tfstate_.

1. Create Managed Identity to login to Azure from Actions

    ```sh
    az identity create --name <id-gh-actions> \
        --resource-group <Resource-Group-Name> \
        --location <Region>
    ```

1. Assign _Contributor_ Role to the managed identity for the subscription

    ```sh
    az role assignment create --assignee <ManagedIdentityServicePrincipal> \
        --role Contributor \
        --scope <Subscription-Id>
    ```

1. Create the following federated credentials

    ```sh
    az identity federated-credential create --identity-name <id-gh-actions> \
                                        --name onPullRequest \
                                        --resource-group <Resource-Group-Name> \
                                        --audiences api://AzureADTokenExchange \
                                        --issuer https://token.actions.githubusercontent.com \
                                        --subject repo:<owner>/<repo>:pull_request

    az identity federated-credential create --identity-name <id-gh-actions> \
                                        --name onBranch \
                                        --resource-group <Resource-Group-Name> \
                                        --audiences api://AzureADTokenExchange \
                                        --issuer https://token.actions.githubusercontent.com \
                                        --subject repo:<owner>/<repo>:ref:refs/heads/main

    az identity federated-credential create --identity-name <id-gh-actions> \
                                        --name onEnvironment \
                                        --resource-group <Resource-Group-Name> \
                                        --audiences api://AzureADTokenExchange \
                                        --issuer https://token.actions.githubusercontent.com \
                                        --subject repo:<owner>/<repo>:environment:azure
    ```

1. Configure credentials in GH. Go to the correspondent GH repo. In _Settings_ > _Secrets and variables_ > _Actions_, create the following secrets with the values corresponding to the created managed identity.
   - `AZURE_CLIENT_ID`
   - `AZURE_SUBSCRIPTION_ID`
   - `AZURE_TENANT_ID`

1. Go to the correspondent repo. In _Settings_ > _Environments_, create the `azure` environment.



Taking inspiration from https://github.com/Azure-Samples/terraform-github-actions/
