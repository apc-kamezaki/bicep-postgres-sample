@description('Name for postgreSQL')
param name string
@description('resource location')
param location string = resourceGroup().location
@description('Administrator user name')
@secure()
param adminUser string
@description('Administrator user password')
@secure()
param adminPassword string
@description('allow public access')
param allowPublicAccess bool = false
@description('SKU tier')
@allowed([
  'Basic'
  'GeneralPurpose'
  'MemoryOptimized'
])
param skuTier string = 'Basic'
@description('The family of hardware')
param skuFamily string = 'Gen5'
@description('The scale up/out capacity')
param skuCapacity int = skuTier == 'Basic' ? 2 : 4
@description('Tag information')
param tags object = {}

var skuNamePrefix = skuTier == 'GeneralPurpose' ? 'GP' : (skuTier == 'Basic' ? 'B' : 'OM')
var skuName = '${skuNamePrefix}_${skuFamily}_${skuCapacity}'

resource pgsql 'Microsoft.DBForPostgreSQL/servers@2017-12-01' = {
  name: name
  location: location
  sku: {
    name: skuName
    tier: skuTier
    family: skuFamily
    capacity: skuCapacity
  }
  properties: {
    createMode: 'Default'
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
    administratorLogin: adminUser
    administratorLoginPassword: adminPassword
  }
  tags: tags
}

output id string = pgsql.id
