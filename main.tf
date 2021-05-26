#import group ressource
resource "azurerm_resource_group" "we-slb-rg-lab-dfpenttest-01" {
name = "we-slb-rg-lab-dfpenttest-01"
location = "west europe"
}

#create sql server
resource "azurerm_sql_server" "sqlserver" {
  name                         = "mysqlservertestdiego"
  resource_group_name          = azurerm_resource_group.we-slb-rg-lab-dfpenttest-01.name
  location                     = azurerm_resource_group.we-slb-rg-lab-dfpenttest-01.location
  version                      = "12.0"
  administrator_login          = var.login
  administrator_login_password = var.login_password
}

#
resource "azurerm_storage_account" "storage" {
  name                     = "storagetestdiego"
  resource_group_name      = azurerm_resource_group.we-slb-rg-lab-dfpenttest-01.name
  location                 = azurerm_resource_group.we-slb-rg-lab-dfpenttest-01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#
resource "azurerm_sql_database" "sqldatabase" {
  name                = "sqldatabasetestdiego"
  resource_group_name = azurerm_resource_group.we-slb-rg-lab-dfpenttest-01.name
  location            = azurerm_resource_group.we-slb-rg-lab-dfpenttest-01.location
  server_name         = azurerm_sql_server.sqlserver.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.storage.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.storage.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
}
