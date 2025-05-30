# 🍓 AI Fitness Assistant - Raspberry Pi Deployment

Bu proje, AI destekli fitness asistanınızı Raspberry Pi'da çalıştırmanız ve Cloudflare tunnel ile internete açmanız için hazırlanmıştır.

## 🚀 Hızlı Başlangıç

### Tek Komutla Kurulum
```bash
curl -fsSL https://raw.githubusercontent.com/your-repo/ai-fitness-assistant/main/deploy/quick-start.sh | bash
```

### Manuel Kurulum
```bash
# 1. Projeyi klonlayın
git clone https://github.com/your-repo/ai-fitness-assistant.git
cd ai-fitness-assistant

# 2. Temel kurulum
./deploy/install.sh

# 3. Proje kurulumu
./deploy/setup.sh

# 4. API anahtarlarını yapılandırın
nano .env

# 5. Uygulamayı başlatın
./deploy/start.sh

# 6. Cloudflare tunnel kurun
./deploy/cloudflare-setup.sh
```

## 📋 Gereksinimler

- **Raspberry Pi 4** (2GB+ RAM)
- **Raspberry Pi OS** (64-bit)
- **OpenAI API Key**
- **Tavily API Key**
- **Cloudflare Hesabı**

## 🛠️ Deployment Scriptleri

| Script | Açıklama |
|--------|----------|
| `install.sh` | Sistem bağımlılıklarını kurar |
| `setup.sh` | Projeyi kurar ve yapılandırır |
| `start.sh` | Uygulamayı başlatır |
| `stop.sh` | Uygulamayı durdurur |
| `update.sh` | Uygulamayı günceller |
| `cloudflare-setup.sh` | Cloudflare tunnel kurar |
| `quick-start.sh` | Tek komutla tam kurulum |

## 🌐 Erişim

- **Yerel**: `http://raspberry-pi-ip`
- **İnternet**: `https://your-tunnel.trycloudflare.com`

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

### Yeniden Başlatma
```bash
pm2 restart ai-fitness-backend  # Backend'i yeniden başlat
sudo systemctl restart nginx    # Nginx'i yeniden başlat
sudo systemctl restart cloudflared  # Tunnel'ı yeniden başlat
```

## 🔧 Sorun Giderme

### Backend Çalışmıyor
```bash
# Logları kontrol edin
pm2 logs ai-fitness-backend

# Manuel başlatma
cd backend
source venv/bin/activate
python main.py
```

### Frontend Görünmüyor
```bash
# Nginx durumunu kontrol edin
sudo systemctl status nginx
sudo nginx -t

# Build'i kontrol edin
ls -la frontend/dist/
```

### Cloudflare Tunnel Sorunları
```bash
# Tunnel durumunu kontrol edin
sudo systemctl status cloudflared
cloudflared tunnel list
```

## 📁 Proje Yapısı

```
ai-fitness-assistant/
├── backend/                 # FastAPI backend
│   ├── main.py             # Ana uygulama
│   ├── config.py           # Konfigürasyon
│   └── chatbot_service.py  # AI servis
├── frontend/               # React frontend
│   ├── src/                # Kaynak kodlar
│   └── dist/               # Build çıktısı
├── deploy/                 # Deployment scriptleri
│   ├── install.sh          # Sistem kurulumu
│   ├── setup.sh            # Proje kurulumu
│   ├── start.sh            # Başlatma
│   ├── stop.sh             # Durdurma
│   ├── update.sh           # Güncelleme
│   ├── cloudflare-setup.sh # Tunnel kurulumu
│   └── quick-start.sh      # Hızlı kurulum
├── .env                    # Environment değişkenleri
└── requirements.txt        # Python bağımlılıkları
```

## 🔒 Güvenlik

- Firewall aktif (UFW)
- SSH key-based authentication önerilir
- API anahtarları güvenli şekilde saklanır
- HTTPS otomatik (Cloudflare tunnel)

## 📱 Özellikler

- **AI Fitness Asistanı**: OpenAI GPT ile kişiselleştirilmiş tavsiyeler
- **Web Search**: Tavily API ile güncel bilgi arama
- **Çok Dilli**: Türkçe ve İngilizce destek
- **Responsive**: Mobil ve desktop uyumlu
- **Real-time**: Canlı sohbet deneyimi

## 🆘 Destek

Detaylı rehber için: [`deploy/DEPLOYMENT_GUIDE.md`](deploy/DEPLOYMENT_GUIDE.md)

Sorun yaşadığınızda:
1. Logları kontrol edin
2. Sistem kaynaklarını kontrol edin
3. API anahtarlarını doğrulayın
4. İnternet bağlantısını test edin

## 📝 Notlar

- Raspberry Pi'nın güç kaynağı yeterli olmalı (3A+)
- SD kart hızı önemli (Class 10+)
- Düzenli yedekleme yapın
- Sistem güncellemelerini takip edin

---

**🎯 Hedef**: Raspberry Pi'nızda profesyonel AI fitness asistanı çalıştırın! 