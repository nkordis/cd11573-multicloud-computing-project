data "azurerm_resource_group" "udacity" {
  //name     = "Regroup_4gKqrgD_cn"
  name = "Regroup_9peEuUpMCkYEv31"
}

resource "azurerm_container_group" "udacity" {
  name                = "udacity-continst"
  location            = data.azurerm_resource_group.udacity.location
  resource_group_name = data.azurerm_resource_group.udacity.name
  ip_address_type     = "Public"
  dns_name_label      = "udacity-nikosko-azure"
  os_type             = "Linux"

  container {
    name   = "azure-container-app"
    image  = "docker.io/tscotto5/azure_app:1.0"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
      "AWS_S3_BUCKET"       = "udacity-nikosko-aws-s3-bucket",
      "AWS_DYNAMO_INSTANCE" = "udacity-nikosko-aws-dynamodb"
    }
    ports {
      port     = 3000
      protocol = "TCP"
    }
  }
  tags = {
    environment = "udacity"
  }
}

####### Your Additions Will Start Here ######

resource "azurerm_storage_account" "example" {
  name                     = "examplesa"
  resource_group_name      = data.azurerm_resource_group.udacity.name
  location                 = data.azurerm_resource_group.udacity.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "example" {
  name                         = "example-sqlserver"
  resource_group_name          = data.azurerm_resource_group.udacity.name
  location                     = data.azurerm_resource_group.udacity.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_resource_group.udacity.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "example" {
  name                = "example"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_resource_group.udacity.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}