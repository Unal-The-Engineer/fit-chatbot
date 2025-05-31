# Azure Static Web Apps Deployment Guide

Bu rehber AI Fitness Assistant projesini Azure Static Web Apps'e deploy etmek için gerekli adımları içerir.

## Ön Gereksinimler

1. **Azure CLI kurulumu**
   ```bash
   # macOS için
   brew install azure-cli
   
   # Windows için
   winget install Microsoft.AzureCLI
   
   # Linux için
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```

2. **Azure hesabına giriş**
   ```bash
   az login
   ```

3. **Static Web Apps extension kurulumu**
   ```bash
   az extension add --name staticwebapp
   ```

## Deployment Adımları

### 1. Resource Group Oluşturma

```bash
# Resource group oluştur
az group create \
  --name "rg-fitchat-assistant" \
  --location "West Europe"
```

### 2. Static Web App Oluşturma

```bash
# Static Web App oluştur
az staticwebapp create \
  --name "fitchat-assistant" \
  --resource-group "rg-fitchat-assistant" \
  --source "https://github.com/YOUR_USERNAME/ai-fitness-assistant" \
  --location "West Europe" \
  --branch "main" \
  --app-location "frontend/dist" \
  --api-location "api" \
  --login-with-github
```

### 3. GitHub Repository Hazırlığı

1. **GitHub'da yeni repository oluşturun:**
   - Repository adı: `ai-fitness-assistant`
   - Public veya Private (tercihinize göre)

2. **Local repository'yi GitHub'a push edin:**
   ```bash
   # Git repository'yi başlat (eğer henüz başlatmadıysanız)
   git init
   
   # Dosyaları stage'e ekle
   git add .
   
   # İlk commit
   git commit -m "Initial commit: AI Fitness Assistant for Azure Static Web Apps"
   
   # GitHub remote ekle
   git remote add origin https://github.com/YOUR_USERNAME/ai-fitness-assistant.git
   
   # Main branch'e push et
   git branch -M main
   git push -u origin main
   ```

### 4. GitHub Secrets Konfigürasyonu

GitHub repository'nizde aşağıdaki secrets'ları ekleyin:

1. **Repository Settings > Secrets and variables > Actions** bölümüne gidin

2. **Aşağıdaki secrets'ları ekleyin:**
   - `AZURE_STATIC_WEB_APPS_API_TOKEN`: Azure Static Web App deployment token
   - `OPENAI_API_KEY`: OpenAI API anahtarınız
   - `TAVILY_API_KEY`: Tavily API anahtarınız

### 5. Azure Static Web App Token Alma

```bash
# Static Web App deployment token'ını al
az staticwebapp secrets list \
  --name "fitchat-assistant" \
  --resource-group "rg-fitchat-assistant" \
  --query "properties.apiKey" \
  --output tsv
```

Bu token'ı GitHub secrets'a `AZURE_STATIC_WEB_APPS_API_TOKEN` olarak ekleyin.

### 6. Environment Variables Konfigürasyonu

Azure Portal'da Static Web App'inize gidin ve Configuration bölümünde aşağıdaki environment variables'ları ekleyin:

- `OPENAI_API_KEY`: OpenAI API anahtarınız
- `TAVILY_API_KEY`: Tavily API anahtarınız

### 7. Custom Domain (Opsiyonel)

Eğer custom domain kullanmak istiyorsanız:

```bash
# Custom domain ekle
az staticwebapp hostname set \
  --name "fitchat-assistant" \
  --resource-group "rg-fitchat-assistant" \
  --hostname "your-domain.com"
```

## Deployment Doğrulama

1. **GitHub Actions'ı kontrol edin:**
   - Repository'nizde Actions sekmesine gidin
   - Workflow'un başarıyla çalıştığını kontrol edin

2. **Azure Portal'da kontrol edin:**
   - Azure Portal > Static Web Apps > fitchat-assistant
   - URL'yi kopyalayın ve tarayıcıda açın

3. **API endpoint'lerini test edin:**
   ```bash
   # Health check
   curl https://your-app-url.azurestaticapps.net/api/health
   
   # Initial chat message
   curl -X POST https://your-app-url.azurestaticapps.net/api/chat/initial \
     -H "Content-Type: application/json" \
     -d '{"language": "tr"}'
   ```

## Troubleshooting

### Build Hataları
- GitHub Actions logs'unu kontrol edin
- Frontend build komutlarının doğru çalıştığından emin olun
- Node.js version uyumluluğunu kontrol edin

### API Hataları
- Environment variables'ların doğru set edildiğini kontrol edin
- Azure Functions logs'unu kontrol edin
- CORS ayarlarını kontrol edin

### Deployment Hataları
- Azure Static Web Apps API token'ının doğru olduğunu kontrol edin
- GitHub repository permissions'ını kontrol edin

## Useful Commands

```bash
# Static Web App durumunu kontrol et
az staticwebapp show \
  --name "fitchat-assistant" \
  --resource-group "rg-fitchat-assistant"

# Logs'ları görüntüle
az staticwebapp logs show \
  --name "fitchat-assistant" \
  --resource-group "rg-fitchat-assistant"

# Environment variables'ları listele
az staticwebapp appsettings list \
  --name "fitchat-assistant" \
  --resource-group "rg-fitchat-assistant"

# Environment variable ekle
az staticwebapp appsettings set \
  --name "fitchat-assistant" \
  --resource-group "rg-fitchat-assistant" \
  --setting-names "KEY=VALUE"
```

## Sonraki Adımlar

1. Custom domain konfigürasyonu
2. SSL sertifikası kurulumu
3. Monitoring ve analytics kurulumu
4. Performance optimizasyonu
5. Security headers konfigürasyonu

## Notlar

- Azure Static Web Apps ücretsiz tier'da 100GB bandwidth ve 0.5GB storage sağlar
- API Functions için 1 milyon request/ay ücretsiz
- Custom domain ve SSL sertifikası ücretsiz
- GitHub Actions otomatik olarak her push'da deployment yapar 