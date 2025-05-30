# Raspberry Pi Deployment Guide

Bu rehber AI Fitness Assistant uygulamasını Raspberry Pi Ubuntu üzerinde deploy etmek için hazırlanmıştır.

## Sistem Gereksinimleri

- Raspberry Pi 4 (4GB+ RAM öneriliyor)
- Ubuntu 20.04+ veya Raspberry Pi OS
- İnternet bağlantısı
- Sudo yetkisi

## Kurulum Seçenekleri

### 1. Sanal Ortam ile Kurulum (Önerilen - Test için)

#### Hızlı Kurulum
```bash
# Tek komutla kurulum
curl -sSL https://raw.githubusercontent.com/Unal-The-Engineer/fit-chatbot/main/deploy/quick-venv-setup.sh | bash
```

#### Manuel Kurulum
```bash
# 1. Repository'yi klonla
git clone https://github.com/Unal-The-Engineer/fit-chatbot.git
cd fit-chatbot

# 2. Sanal ortam kurulumu
./deploy/venv-setup.sh

# 3. API anahtarlarını ayarla
nano .env

# 4. Uygulamayı başlat
./deploy/venv-start.sh
```

#### Sanal Ortam Yönetimi
```bash
# Uygulamayı başlat
./deploy/venv-start.sh

# Uygulamayı durdur
./deploy/venv-stop.sh

# Uygulamayı yeniden başlat
./deploy/venv-restart.sh

# Logları görüntüle
./deploy/venv-logs.sh
```

### 2. Docker ile Kurulum (Production için)

#### Hızlı Docker Kurulumu
```bash
# Tek komutla kurulum
curl -sSL https://raw.githubusercontent.com/Unal-The-Engineer/fit-chatbot/main/deploy/quick-start.sh | bash
```

#### Manuel Docker Kurulumu
```bash
# 1. Repository'yi klonla
git clone https://github.com/Unal-The-Engineer/fit-chatbot.git
cd fit-chatbot

# 2. Docker kurulumu
./deploy/docker-setup.sh

# 3. API anahtarlarını ayarla
nano .env

# 4. Docker ile başlat
./deploy/docker-start.sh
```

## API Anahtarları Ayarlama

`.env` dosyasını düzenleyin:

```bash
nano .env
```

Gerekli anahtarları ekleyin:
```env
# OpenAI API Key
OPENAI_API_KEY=sk-your-openai-api-key-here

# Tavily API Key  
TAVILY_API_KEY=tvly-your-tavily-api-key-here

# Backend Settings
HOST=0.0.0.0
PORT=8001

# Frontend API URL
VITE_API_BASE_URL=http://localhost:8001

# Debug mode
DEBUG=true
```

## Python Sürüm Uyumluluğu

### Python 3.13 Sorunu
Eğer Python 3.13 kullanıyorsanız, pydantic-core uyumluluk sorunu yaşayabilirsiniz. Script otomatik olarak Python 3.11 kuracaktır.

### Manuel Python 3.11 Kurulumu
```bash
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.11 python3.11-venv python3.11-dev
```

## Erişim Adresleri

### Sanal Ortam
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8001
- **API Docs**: http://localhost:8001/docs

### Docker
- **Uygulama**: http://localhost
- **Backend API**: http://localhost/api
- **API Docs**: http://localhost/api/docs

## Cloudflare Tunnel (İsteğe Bağlı)

İnternet üzerinden erişim için:

### Sanal Ortam için
```bash
# Cloudflare tunnel kurulumu
./deploy/cloudflare-setup.sh
```

### Docker için
```bash
# Cloudflare tunnel kurulumu
./deploy/docker-cloudflare.sh
```

## Sorun Giderme

### Sanal Ortam Sorunları

1. **Python sürüm sorunu**:
   ```bash
   python3 --version
   # Eğer 3.13 ise, script otomatik olarak 3.11 kuracak
   ```

2. **Paket kurulum hatası**:
   ```bash
   source venv/bin/activate
   pip install --upgrade pip
   pip install -r requirements-py311.txt
   ```

3. **Port kullanımda hatası**:
   ```bash
   ./deploy/venv-stop.sh
   # Veya manuel olarak:
   sudo lsof -ti:8001 | xargs kill -9
   sudo lsof -ti:3000 | xargs kill -9
   ```

### Docker Sorunları

1. **Docker izin hatası**:
   ```bash
   sudo usermod -aG docker $USER
   # Sonra logout/login yapın
   ```

2. **Container başlatma hatası**:
   ```bash
   docker-compose logs
   ```

3. **Port çakışması**:
   ```bash
   docker-compose down
   sudo lsof -ti:80 | xargs kill -9
   ```

## Performans Optimizasyonu

### Raspberry Pi 4 için
```bash
# GPU memory split
sudo raspi-config
# Advanced Options > Memory Split > 128

# Swap artırma
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
# CONF_SWAPSIZE=2048
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

## Güvenlik

### Firewall Ayarları
```bash
sudo ufw enable
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw allow 3000  # Frontend (sadece sanal ortam için)
sudo ufw allow 8001  # Backend (sadece sanal ortam için)
```

### SSL Sertifikası (Production)
Cloudflare tunnel kullanıyorsanız SSL otomatik olarak sağlanır.

## Monitoring

### Sistem Kaynakları
```bash
# Sanal ortam için
./deploy/venv-logs.sh

# Docker için
docker stats
```

### Log Takibi
```bash
# Sanal ortam
tail -f /var/log/syslog

# Docker
docker-compose logs -f
```

## Güncelleme

### Sanal Ortam
```bash
cd /home/growbox/fit-chatbot
git pull origin main
./deploy/venv-restart.sh
```

### Docker
```bash
cd /home/growbox/fit-chatbot
git pull origin main
docker-compose down
docker-compose build
./deploy/docker-start.sh
```

## Destek

Sorun yaşarsanız:
1. Logları kontrol edin
2. GitHub Issues'da sorun bildirin
3. Sistem kaynaklarını kontrol edin (RAM, disk) 