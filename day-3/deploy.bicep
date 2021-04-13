param appName string = 'bicep-sample'
param vnetName string = '${appName}-vnet'
param subnetName string = 'computing'

param dbName string = '${appName}-db'
param pgAdminUser string
param pgAdminPassword string

var tags = {
  app: appName
  mode: 'experimental'
}

module vn 'vnet.bicep' = {
  name: 'deploy-${vnetName}-${subnetName}'
  params: {
    virtualNetworkName: vnetName
    subnetName: subnetName
    tags: tags
  }
}

module pgsql 'postgresql.bicep' = {
  name: 'deploy-${dbName}'
  params: {
    name: dbName
    skuTier: 'GeneralPurpose'
    adminUser: pgAdminUser
    adminPassword: pgAdminPassword
  }
}

var postgresDomainName = 'privatelink.postgres.database.azure.com'
var endpointName = '${dbName}-endpoint'

module endpoint 'private-endpoint.bicep' = {
  name: 'deploy-${endpointName}'
  params: {
    name: endpointName
    subnetId: vn.outputs.subnetIds[0].id
    linkServiceConnections: [
      {
        serviceId: pgsql.outputs.id
        groupIds: [
          'postgresqlServer'
        ]
      }
    ]
  }
}

module dns 'private-dns.bicep' = {
  name: 'deploy-dns-${postgresDomainName}'
  params: {
    name: postgresDomainName
    vnId: vn.outputs.id
  }
}

module dnsGroup 'private-zone-groups.bicep' = {
  name: 'deploy-dns-group-${postgresDomainName}'
  params: {
    name: '${endpointName}/default'
    zoneIds: [
      {
        zoneName: postgresDomainName
        zoneId: dns.outputs.id
      }
    ]
  }
  dependsOn: [
    pgsql
    endpoint
  ]
}
