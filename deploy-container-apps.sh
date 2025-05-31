#!/bin/bash

# Azure Container Apps Deployment Script
# Ücretsiz ve güvenilir backend deployment

set -e

# Renkli output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Kullanıcıdan bilgi al
read -p "Resource group adı (varsayılan: rg-fitchat-assistant): " RESOURCE_GROUP
RESOURCE_GROUP=${RESOURCE_GROUP:-rg-fitchat-assistant}

read -p "Container App adı (varsayılan: fitchat-backend): " APP_NAME
APP_NAME=${APP_NAME:-fitchat-backend}

read -p "Azure region (varsayılan: West Europe): " LOCATION
LOCATION=${LOCATION:-"West Europe"}

print_info "Container Apps deployment başlatılıyor..."
print_info "Resource Group: $RESOURCE_GROUP"
print_info "App Name: $APP_NAME"
print_info "Location: $LOCATION"

# Container Apps extension kontrolü
if ! az extension show --name containerapp &> /dev/null; then
    print_info "Container Apps extension kuruluyor..."
    az extension add --name containerapp --upgrade
fi

# Container Apps environment oluştur
ENV_NAME="fitchat-env"
print_info "Container Apps Environment oluşturuluyor: $ENV_NAME"

az containerapp env create \
    --name "$ENV_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --output table

# Container App oluştur
print_info "Container App oluşturuluyor: $APP_NAME"

az containerapp create \
    --name "$APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --environment "$ENV_NAME" \
    --image "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest" \
    --target-port 8000 \
    --ingress 'external' \
    --query "properties.configuration.ingress.fqdn" \
    --output table

# App URL al
APP_URL=$(az containerapp show \
    --name "$APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "properties.configuration.ingress.fqdn" \
    --output tsv)

print_success "Container App oluşturuldu!"
print_success "App URL: https://$APP_URL"

print_warning "Sonraki adımlar:"
echo "1. GitHub Actions ile otomatik deployment kurulacak"
echo "2. Environment variables eklenecek"
echo "3. Docker image build edilip deploy edilecek"

print_info "GitHub Actions workflow'u güncellenecek..." 