#!/bin/sh
#Docker image on dockerhub
DOCKER_IMAGE="anonymized"

INTERNALNAME="$(date +%Y%m%d%H%M%S)"
# Change these four parameters as needed
# Resource group name
ACI_PERS_RESOURCE_GROUP="labsfl20221114_$INTERNALNAME"
# Storage account name
ACI_PERS_STORAGE_ACCOUNT_NAME=labstorage$INTERNALNAME
# Location
ACI_PERS_LOCATION=eastus
# Share name
ACI_PERS_SHARE_NAME=container

#Create the resource group
az group create \
    -l $ACI_PERS_LOCATION \
    -n "$ACI_PERS_RESOURCE_GROUP"

# Create the storage account with the parameters
az storage account create \
    --resource-group "$ACI_PERS_RESOURCE_GROUP" \
    --name "$ACI_PERS_STORAGE_ACCOUNT_NAME" \
    --location $ACI_PERS_LOCATION \
    --sku Standard_LRS

# Create the file share
az storage share create \
  --name $ACI_PERS_SHARE_NAME \
  --account-name "$ACI_PERS_STORAGE_ACCOUNT_NAME"

# Get Storage Key
STORAGE_KEY=$(az storage account keys list --resource-group "$ACI_PERS_RESOURCE_GROUP" --account-name "$ACI_PERS_STORAGE_ACCOUNT_NAME" --query "[0].value" --output tsv)

az container create \
    --resource-group "$ACI_PERS_RESOURCE_GROUP" \
    --name "labsfl20221114-${INTERNALNAME}" \
    --image $DOCKER_IMAGE \
    --dns-name-label "labsfl20221114-${INTERNALNAME}-aci" \
    --azure-file-volume-account-name "$ACI_PERS_STORAGE_ACCOUNT_NAME" \
    --azure-file-volume-account-key "$STORAGE_KEY" \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /labsfl20221114/test/ \
    --environment-variables 'REPEAT'='10' \
    --restart-policy Never \
	--cpu 2 \
	--memory 8
