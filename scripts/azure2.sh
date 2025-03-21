# 5
ID_INFRA_SP=""
SUBS_ID=""
az role assignment create --assignee $ID_INFRA_SP \
        --role Contributor \
        --scope $SUBS_ID

# 6
az identity federated-credential create --identity-name $ID_INFRA_NAME \
                                        --name onPullRequest \
                                        --resource-group $RG_NAME \
                                        --audiences api://AzureADTokenExchange \
                                        --issuer https://token.actions.githubusercontent.com \
                                        --subject repo:"$OWNER"/"$REPO":pull_request

az identity federated-credential create --identity-name $ID_INFRA_NAME \
                                        --name onBranch \
                                        --resource-group $RG_NAME \
                                        --audiences api://AzureADTokenExchange \
                                        --issuer https://token.actions.githubusercontent.com \
                                        --subject repo:"$OWNER"/"$REPO":ref:refs/heads/main-azure

az identity federated-credential create --identity-name $ID_INFRA_NAME \
                                        --name onEnvironment \
                                        --resource-group $RG_NAME \
                                        --audiences api://AzureADTokenExchange \
                                        --issuer https://token.actions.githubusercontent.com \
                                        --subject repo:"$OWNER"/"$REPO":environment:azure