# 🤖 AI Fitness Assistant

AI destekli kişiselleştirilmiş fitness ve beslenme asistanı. OpenAI GPT ve web search teknolojileri ile güçlendirilmiş, Azure Static Web Apps'te çalışan modern web uygulaması.

## 🌟 Özellikler

- **🤖 AI Fitness Asistanı**: OpenAI GPT ile kişiselleştirilmiş beslenme ve egzersiz tavsiyeleri
- **🔍 Web Search**: Tavily API ile güncel fitness ve beslenme bilgileri
- **🌍 Çok Dilli**: Türkçe ve İngilizce destek
- **📱 Responsive**: Mobil ve desktop uyumlu modern arayüz
- **💬 Real-time Chat**: Canlı sohbet deneyimi
- **☁️ Azure Ready**: Azure Static Web Apps'te çalışmaya optimize edilmiş

## 🏗️ Teknoloji Stack

### Backend
- **FastAPI** - Modern Python web framework
- **Azure Functions** - Serverless backend hosting
- **OpenAI API** - GPT-4 ile AI sohbet
- **Tavily API** - Web search ve güncel bilgi

### Frontend
- **React 18** - Modern UI framework
- **TypeScript** - Type-safe JavaScript
- **Tailwind CSS** - Utility-first CSS framework
- **Vite** - Hızlı build tool
- **Lucide React** - Modern icon library

### Deployment
- **Azure Static Web Apps** - Modern cloud hosting
- **GitHub Actions** - CI/CD pipeline
- **Azure Functions** - Serverless API

## 🚀 Hızlı Başlangıç

### Azure Static Web Apps Deployment

```bash
# Repository'yi klonlayın
git clone https://github.com/YOUR_USERNAME/ai-fitness-assistant.git
cd ai-fitness-assistant

# Azure CLI ile deployment
./deploy-to-azure.sh
```

**Veya Manuel Deployment:**

1. **Azure CLI kurulumu ve giriş:**
   ```bash
   # Azure CLI kur
   brew install azure-cli  # macOS
   # veya
   winget install Microsoft.AzureCLI  # Windows
   
   # Azure'a giriş yap
   az login
   
   # Static Web Apps extension kur
   az extension add --name staticwebapp
   ```

2. **Azure Static Web App oluştur:**
   ```bash
   az staticwebapp create \
     --name "fitchat-assistant" \
     --resource-group "rg-fitchat-assistant" \
     --source "https://github.com/YOUR_USERNAME/ai-fitness-assistant" \
     --location "West Europe" \
     --branch "main" \
     --app-location "frontend/dist" \
     --api-location "api"
   ```

3. **GitHub Secrets ekle:**
   - `AZURE_STATIC_WEB_APPS_API_TOKEN`
   - `OPENAI_API_KEY`
   - `TAVILY_API_KEY`

### Yerel Development

```bash
# Repository'yi klonlayın
git clone https://github.com/YOUR_USERNAME/ai-fitness-assistant.git
cd ai-fitness-assistant

# Backend kurulumu (yerel test için)
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r ../api/requirements.txt

# .env dosyası oluşturun
cp .env.example .env
# API anahtarlarınızı .env dosyasına ekleyin

# Backend'i başlatın
python main.py

# Yeni terminal'de frontend kurulumu
cd frontend
npm install
npm run dev
```

## 📋 Gereksinimler

### API Anahtarları
- **OpenAI API Key** - [OpenAI Platform](https://platform.openai.com/api-keys)
- **Tavily API Key** - [Tavily](https://tavily.com/)

### Azure Deployment
- **Azure Hesabı** - [Azure Portal](https://portal.azure.com/)
- **GitHub Hesabı** - [GitHub](https://github.com/)

## 🛠️ Deployment Dosyaları

| Dosya | Açıklama |
|--------|----------|
| `deploy-to-azure.sh` | Azure'a otomatik deployment |
| `azure-deployment-guide.md` | Detaylı Azure rehberi |
| `.github/workflows/azure-static-web-apps.yml` | GitHub Actions workflow |
| `staticwebapp.config.json` | Azure Static Web Apps config |

## 📁 Proje Yapısı

```
ai-fitness-assistant/
├── api/                    # Azure Functions API
│   ├── __init__.py         # Azure Functions entry point
│   ├── function.json       # Function configuration
│   ├── host.json           # Host configuration
│   ├── requirements.txt    # Python dependencies
│   ├── config.py           # Configuration
│   └── chatbot_service.py  # AI service
├── backend/                # FastAPI backend (yerel development)
│   ├── main.py             # Ana uygulama
│   ├── config.py           # Konfigürasyon
│   └── chatbot_service.py  # AI servis
├── frontend/               # React frontend
│   ├── src/                # Kaynak kodlar
│   │   ├── components/     # React bileşenleri
│   │   ├── context/        # Context providers
│   │   ├── types/          # TypeScript tipleri
│   │   └── config/         # Konfigürasyon
│   └── dist/               # Build çıktısı
├── .github/workflows/      # GitHub Actions
│   └── azure-static-web-apps.yml
├── staticwebapp.config.json # Azure Static Web Apps config
├── deploy-to-azure.sh      # Azure deployment script
├── azure-deployment-guide.md # Azure rehberi
└── .env                    # Environment değişkenleri
```

## 🌐 Erişim

- **Azure Static Web Apps**: `https://your-app.azurestaticapps.net`
- **Yerel Development**: `http://localhost:5173`

## 📊 Yönetim

### Azure Static Web Apps
```bash
# App durumunu kontrol et
az staticwebapp show --name "fitchat-assistant" --resource-group "rg-fitchat-assistant"

# Logs görüntüle
az staticwebapp logs show --name "fitchat-assistant" --resource-group "rg-fitchat-assistant"

# Environment variables listele
az staticwebapp appsettings list --name "fitchat-assistant" --resource-group "rg-fitchat-assistant"
```

## 🔧 Konfigürasyon

### Environment Variables

**Azure Static Web Apps:**
- Azure Portal > Static Web Apps > Configuration bölümünde ayarlayın
- GitHub Secrets'ta deployment için gerekli

**Yerel Development (.env):**
```env
# OpenAI API Key
OPENAI_API_KEY=sk-your-openai-api-key

# Tavily API Key
TAVILY_API_KEY=tvly-your-tavily-api-key

# Server Configuration
HOST=0.0.0.0
PORT=8000
DEBUG=false
```

## 🔒 Güvenlik

- **HTTPS**: Azure Static Web Apps ile otomatik SSL
- **CORS**: Güvenli cross-origin ayarları
- **API Keys**: Environment variables ile güvenli saklama
- **Azure Functions**: Serverless güvenlik

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 🆘 Destek

- **Azure Rehberi**: [Azure Deployment Guide](azure-deployment-guide.md)
- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/ai-fitness-assistant/issues)

## 📝 Changelog

### v2.0.0
- ☁️ Azure Static Web Apps desteği
- 🚀 GitHub Actions CI/CD
- 🔧 Azure Functions backend
- 📦 Otomatik deployment script

### v1.0.0
- ✨ İlk sürüm
- 🤖 OpenAI GPT entegrasyonu
- 🔍 Tavily web search
- 🌍 Türkçe/İngilizce destek 