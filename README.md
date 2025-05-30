# 🤖 AI Fitness Assistant

AI destekli kişiselleştirilmiş fitness ve beslenme asistanı. OpenAI GPT ve web search teknolojileri ile güçlendirilmiş, Raspberry Pi'da çalışabilen modern web uygulaması.

## 🌟 Özellikler

- **🤖 AI Fitness Asistanı**: OpenAI GPT ile kişiselleştirilmiş beslenme ve egzersiz tavsiyeleri
- **🔍 Web Search**: Tavily API ile güncel fitness ve beslenme bilgileri
- **🌍 Çok Dilli**: Türkçe ve İngilizce destek
- **📱 Responsive**: Mobil ve desktop uyumlu modern arayüz
- **💬 Real-time Chat**: Canlı sohbet deneyimi
- **🍓 Raspberry Pi Ready**: Raspberry Pi'da çalışmaya optimize edilmiş

## 🏗️ Teknoloji Stack

### Backend
- **FastAPI** - Modern Python web framework
- **OpenAI API** - GPT-4 ile AI sohbet
- **Tavily API** - Web search ve güncel bilgi
- **Uvicorn** - ASGI server

### Frontend
- **React 18** - Modern UI framework
- **TypeScript** - Type-safe JavaScript
- **Tailwind CSS** - Utility-first CSS framework
- **Vite** - Hızlı build tool
- **Lucide React** - Modern icon library

### Deployment
- **Nginx** - Web server ve reverse proxy
- **PM2** - Process manager
- **Cloudflare Tunnel** - Secure internet access
- **Systemd** - Service management

## 🚀 Hızlı Başlangıç

### Raspberry Pi'da Deployment

```bash
# Repository'yi klonlayın
git clone https://github.com/Unal-The-Engineer/fit-chatbot.git
cd fit-chatbot

# Tek komutla kurulum
./deploy/quick-start.sh
```

### Yerel Development

```bash
# Repository'yi klonlayın
git clone https://github.com/Unal-The-Engineer/fit-chatbot.git
cd fit-chatbot

# Backend kurulumu
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r ../requirements.txt

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

### Raspberry Pi Deployment
- **Raspberry Pi 4** (2GB+ RAM önerilir)
- **Raspberry Pi OS** (64-bit)
- **Cloudflare Hesabı** - [Cloudflare](https://cloudflare.com/)

## 🛠️ Deployment Scriptleri

| Script | Açıklama |
|--------|----------|
| `deploy/install.sh` | Sistem bağımlılıklarını kurar |
| `deploy/setup.sh` | Projeyi kurar ve yapılandırır |
| `deploy/start.sh` | Uygulamayı başlatır |
| `deploy/stop.sh` | Uygulamayı durdurur |
| `deploy/update.sh` | Uygulamayı günceller |
| `deploy/cloudflare-setup.sh` | Cloudflare tunnel kurar |
| `deploy/quick-start.sh` | Tek komutla tam kurulum |

## 📁 Proje Yapısı

```
fit-chatbot/
├── backend/                 # FastAPI backend
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
├── deploy/                 # Deployment scriptleri
│   ├── install.sh          # Sistem kurulumu
│   ├── setup.sh            # Proje kurulumu
│   ├── start.sh            # Başlatma
│   ├── stop.sh             # Durdurma
│   ├── update.sh           # Güncelleme
│   ├── cloudflare-setup.sh # Tunnel kurulumu
│   ├── quick-start.sh      # Hızlı kurulum
│   └── README.md           # Deployment rehberi
├── .env                    # Environment değişkenleri
├── requirements.txt        # Python bağımlılıkları
└── RASPBERRY_PI_DEPLOYMENT.md # Raspberry Pi rehberi
```

## 🌐 Erişim

- **Yerel Development**: `http://localhost:5173`
- **Raspberry Pi Yerel**: `http://raspberry-pi-ip`
- **İnternet (Cloudflare Tunnel)**: `https://your-tunnel.trycloudflare.com`

## 📊 Yönetim

### Durum Kontrolü
```bash
pm2 status                    # Backend durumu
sudo systemctl status nginx  # Web server durumu
sudo systemctl status cloudflared  # Tunnel durumu
```

### Loglar
```bash
pm2 logs ai-fitness-backend   # Backend logları
sudo tail -f /var/log/nginx/access.log  # Web server logları
sudo journalctl -u cloudflared -f  # Tunnel logları
```

## 🔧 Konfigürasyon

### Environment Variables (.env)
```env
# OpenAI API Key
OPENAI_API_KEY=sk-your-openai-api-key

# Tavily API Key
TAVILY_API_KEY=tvly-your-tavily-api-key

# Server Configuration
HOST=0.0.0.0
PORT=8000
DEBUG=false

# Frontend URL
FRONTEND_URL=https://your-domain.trycloudflare.com
```

## 🔒 Güvenlik

- **HTTPS**: Cloudflare tunnel ile otomatik SSL
- **CORS**: Güvenli cross-origin ayarları
- **API Keys**: Environment variables ile güvenli saklama
- **Firewall**: UFW ile port güvenliği

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 🆘 Destek

- **Detaylı Rehber**: [Raspberry Pi Deployment](RASPBERRY_PI_DEPLOYMENT.md)
- **Deployment Rehberi**: [deploy/README.md](deploy/README.md)
- **Issues**: [GitHub Issues](https://github.com/Unal-The-Engineer/fit-chatbot/issues)

## 📝 Changelog

### v1.0.0
- ✨ İlk sürüm
- 🤖 OpenAI GPT entegrasyonu
- 🔍 Tavily web search
- 🌍 Türkçe/İngilizce destek
- 🍓 Raspberry Pi deployment
- ☁️ Cloudflare tunnel desteği

---

**🎯 Hedef**: Raspberry Pi'nızda profesyonel AI fitness asistanı çalıştırın! 