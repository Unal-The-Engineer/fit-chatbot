#!/bin/bash

# Azure Static Web Apps Deployment Script
# AI Fitness Assistant projesini Azure'a deploy eder

set -e

# Renkli output için
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonksiyonlar
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Kullanıcıdan bilgi al
read -p "GitHub username'inizi girin: " GITHUB_USERNAME
read -p "Resource group adı (varsayılan: rg-fitchat-assistant): " RESOURCE_GROUP
RESOURCE_GROUP=${RESOURCE_GROUP:-rg-fitchat-assistant}

read -p "Static Web App adı (varsayılan: fitchat-assistant): " APP_NAME
APP_NAME=${APP_NAME:-fitchat-assistant}

read -p "Azure region (varsayılan: West Europe): " LOCATION
LOCATION=${LOCATION:-"West Europe"}

print_info "Deployment başlatılıyor..."
print_info "GitHub Username: $GITHUB_USERNAME"
print_info "Resource Group: $RESOURCE_GROUP"
print_info "App Name: $APP_NAME"
print_info "Location: $LOCATION"

# Azure CLI kontrolü
if ! command -v az &> /dev/null; then
    print_error "Azure CLI bulunamadı. Lütfen Azure CLI'yi kurun."
    exit 1
fi

# Azure'a giriş kontrolü
if ! az account show &> /dev/null; then
    print_warning "Azure'a giriş yapılmamış. Giriş yapılıyor..."
    az login
fi

# Static Web Apps extension kontrolü
if ! az extension show --name staticwebapp &> /dev/null; then
    print_info "Static Web Apps extension kuruluyor..."
    az extension add --name staticwebapp
fi

# Resource Group oluştur
print_info "Resource Group oluşturuluyor: $RESOURCE_GROUP"
az group create \
    --name "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --output table

# Frontend build
print_info "Frontend build ediliyor..."
cd frontend
npm ci
npm run build
cd ..

# Static Web App oluştur
print_info "Static Web App oluşturuluyor: $APP_NAME"
GITHUB_REPO="https://github.com/$GITHUB_USERNAME/ai-fitness-assistant"

az staticwebapp create \
    --name "$APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --source "$GITHUB_REPO" \
    --location "$LOCATION" \
    --branch "main" \
    --app-location "frontend/dist" \
    --api-location "api" \
    --login-with-github \
    --output table

# Deployment token al
print_info "Deployment token alınıyor..."
DEPLOYMENT_TOKEN=$(az staticwebapp secrets list \
    --name "$APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "properties.apiKey" \
    --output tsv)

# App URL al
APP_URL=$(az staticwebapp show \
    --name "$APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "defaultHostname" \
    --output tsv)

print_success "Deployment tamamlandı!"
print_success "App URL: https://$APP_URL"
print_info "Deployment Token (GitHub Secrets için): $DEPLOYMENT_TOKEN"

echo ""
print_warning "Sonraki adımlar:"
echo "1. GitHub repository'nizi oluşturun: $GITHUB_REPO"
echo "2. Kodu GitHub'a push edin"
echo "3. GitHub Secrets'a aşağıdaki değerleri ekleyin:"
echo "   - AZURE_STATIC_WEB_APPS_API_TOKEN: $DEPLOYMENT_TOKEN"
echo "   - OPENAI_API_KEY: <your-openai-api-key>"
echo "   - TAVILY_API_KEY: <your-tavily-api-key>"
echo "4. Azure Portal'da environment variables'ları ekleyin"

# GitHub repository oluşturma yardımı
echo ""
read -p "GitHub repository'yi şimdi oluşturmak ister misiniz? (y/n): " CREATE_REPO

if [[ $CREATE_REPO =~ ^[Yy]$ ]]; then
    print_info "GitHub repository oluşturuluyor..."
    
    # Git repository başlat
    if [ ! -d ".git" ]; then
        git init
    fi
    
    # Dosyaları ekle
    git add .
    git commit -m "Initial commit: AI Fitness Assistant for Azure Static Web Apps" || true
    
    # GitHub CLI kontrolü
    if command -v gh &> /dev/null; then
        print_info "GitHub CLI ile repository oluşturuluyor..."
        gh repo create ai-fitness-assistant --public --source=. --remote=origin --push
        print_success "GitHub repository oluşturuldu ve kod push edildi!"
    else
        print_warning "GitHub CLI bulunamadı. Manuel olarak repository oluşturun:"
        echo "1. https://github.com/new adresine gidin"
        echo "2. Repository adı: ai-fitness-assistant"
        echo "3. Aşağıdaki komutları çalıştırın:"
        echo "   git remote add origin $GITHUB_REPO.git"
        echo "   git branch -M main"
        echo "   git push -u origin main"
    fi
fi

print_success "Deployment script tamamlandı!"
print_info "Detaylı rehber için azure-deployment-guide.md dosyasını inceleyin." 