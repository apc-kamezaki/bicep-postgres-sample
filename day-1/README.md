# Day 1 & Day 2

内容は [入門Azure Bicep 1 Bicepとは](https://techblog.ap-com.co.jp/entry/2021/04/06/102010) 、[入門Azure Bicep 2 Bicep Step by Step](https://techblog.ap-com.co.jp/entry/2021/04/11/181454) 参照。


デプロイの際のコマンドは以下の通り

```
az group create --name rg-sample --location japaneast

az deployment group create -f ./postgresql.bicep -g rg-sample \
  --parameters name=bicep-sample-db adminUser=<admin user name> adminPassword=<password>
```
