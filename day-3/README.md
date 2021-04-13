# Day 3

deploy.bicepから以下のリソースを追加。  
個々のリソースはBicepモジュールで定義。

- VNet
- PostgreSQL
- PostgreSQL vnet endpoint
- Private DNS
- Private DNSへのレコード追加

デプロイの際のコマンドは以下の通り

```
az group create --name rg-sample --location japaneast

az deployment group create -f ./deploy.bicep -g rg-sample \
  --parameters adminUser=<admin user name> adminPassword=<password>
```
