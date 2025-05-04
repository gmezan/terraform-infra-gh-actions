resource "random_pet" "rg_name" {
  prefix = "rg"
}

module "resource_group" {
  source = "./module/azure/rg"

  name     = random_pet.rg_name.id
  location = var.location
}

resource "random_pet" "aoai" {
  prefix    = "aoaigm"
  separator = ""
}

module "azure_cognitive_account" {
  source = "./module/azure/ai"

  name     = random_pet.aoai.id
  rg_name  = module.resource_group.name
  location = var.location

  depends_on = [module.resource_group]
}

module "azure_openai_deployment_gpt" {
  source = "./module/azure/aoai_deployment"

  cognitive_account_id = module.azure_cognitive_account.id
  name                 = "gpt-4o-mini"
  model_name           = "gpt-4o-mini"
  rg_name              = module.resource_group.name
  capacity             = 4

  depends_on = [module.resource_group, module.azure_cognitive_account]
}

module "aks" {
  source = "./module/azure/aks"

  rg_name                   = module.resource_group.name
  location                  = var.location
  rbac_enabled              = true
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  node_count                = 1

  depends_on = [module.resource_group]
}