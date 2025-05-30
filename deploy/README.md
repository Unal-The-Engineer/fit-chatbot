# AI Fitness Assistant - Raspberry Pi Deployment Rehberi

Bu rehber, AI Fitness Assistant uygulamasını Raspberry Pi'da deploy etmek için gerekli tüm adımları içerir.

## 📋 Gereksinimler

- Raspberry Pi 4 (2GB+ RAM önerilir)
- Raspberry Pi OS (64-bit)
- İnternet bağlantısı
- OpenAI API anahtarı
- Tavily API anahtarı (web search için)
- Cloudflare hesabı (tunnel için)

## 🚀 Kurulum Adımları

### 1. Raspberry Pi Hazırlığı

Raspberry Pi'nızda SSH bağlantısı kurun ve aşağıdaki komutu çalıştırın:

```bash
# Temel sistem kurulumu
curl -fsSL https://raw.githubusercontent.com/your-repo/ai-fitness-assistant/main/deploy/install.sh | bash
```

### 2. Proje Dosyalarını Kopyalama

Projeyi Raspberry Pi'ya kopyalayın:

```bash
# Git ile klonlama
cd /home/pi
git clone https://github.com/your-repo/ai-fitness-assistant.git

# Veya SCP ile kopyalama (yerel makinenizden)
scp -r /path/to/ai-fitness-assistant pi@raspberry-pi-ip:/home/pi/
```

### 3. Proje Kurulumu

```bash
cd /home/pi/ai-fitness-assistant
chmod +x deploy/*.sh
./deploy/setup.sh
```

### 4. Çevre Değişkenlerini Yapılandırma

```bash
nano .env
```

Aşağıdaki değerleri kendi API anahtarlarınızla değiştirin:

```env
OPENAI_API_KEY=sk-your-openai-api-key
TAVILY_API_KEY=tvly-your-tavily-api-key
HOST=0.0.0.0
PORT=8000
DEBUG=false
FRONTEND_URL=https://your-domain.trycloudflare.com
```

### 5. Uygulamayı Başlatma

```bash
./deploy/start.sh
```

### 6. Cloudflare Tunnel Kurulumu

```bash
./deploy/cloudflare-setup.sh
```

Bu script:
- Cloudflare hesabınıza giriş yapmanızı isteyecek
- Yeni bir tunnel oluşturacak
- DNS kaydını yapılandıracak
- Otomatik olarak tunnel'ı başlatacak

## 🛠️ Yönetim Komutları

### Uygulamayı Durdurma
```bash
./deploy/stop.sh
```

### Uygulamayı Güncelleme
```bash
./deploy/update.sh
```

### Durum Kontrolü
```bash
# Backend durumu
pm2 status

# Nginx durumu
sudo systemctl status nginx

# Cloudflare tunnel durumu
sudo systemctl status cloudflared

# Logları görüntüleme
pm2 logs ai-fitness-backend
sudo journalctl -u cloudflared -f
```

## 🌐 Erişim

- **Yerel erişim**: http://raspberry-pi-ip
- **İnternet erişimi**: https://your-tunnel-name.trycloudflare.com

## 🔧 Sorun Giderme

### Backend Başlamıyor
```bash
# Logları kontrol edin
pm2 logs ai-fitness-backend

# .env dosyasını kontrol edin
cat .env

# Manuel başlatma
cd /home/pi/ai-fitness-assistant/backend
source venv/bin/activate
python main.py
```

### Frontend Görünmüyor
```bash
# Nginx durumunu kontrol edin
sudo systemctl status nginx

# Nginx loglarını kontrol edin
sudo tail -f /var/log/nginx/error.log

# Frontend build'ini kontrol edin
ls -la frontend/dist/
```

### Cloudflare Tunnel Çalışmıyor
```bash
# Tunnel durumunu kontrol edin
sudo systemctl status cloudflared

# Tunnel loglarını kontrol edin
sudo journalctl -u cloudflared -f

# Konfigürasyonu kontrol edin
cat ~/.cloudflared/config.yml
```

## 📊 Performans Optimizasyonu

### Raspberry Pi 4 için öneriler:
- Swap dosyası boyutunu artırın (2GB)
- GPU memory split'i 16MB'a ayarlayın
- Overclock ayarlarını yapın (isteğe bağlı)

```bash
# Swap boyutunu artırma
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
# CONF_SWAPSIZE=2048
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

# GPU memory ayarı
sudo nano /boot/config.txt
# gpu_mem=16
sudo reboot
```

## 🔒 Güvenlik

### Firewall Ayarları
```bash
# UFW kurulumu
sudo apt install ufw

# Gerekli portları açma
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443

# Firewall'ı etkinleştirme
sudo ufw enable
```

### SSL Sertifikası
Cloudflare tunnel otomatik olarak SSL sertifikası sağlar. Ek yapılandırma gerekmez.

## 📱 Monitoring

### Sistem kaynaklarını izleme
```bash
# CPU ve RAM kullanımı
htop

# Disk kullanımı
df -h

# Ağ trafiği
sudo iftop
```

### Uygulama logları
```bash
# Backend logları
pm2 logs ai-fitness-backend --lines 100

# Nginx access logları
sudo tail -f /var/log/nginx/access.log

# Sistem logları
sudo journalctl -f
```

## 🆘 Destek

Sorun yaşadığınızda:
1. Logları kontrol edin
2. Sistem kaynaklarını kontrol edin
3. İnternet bağlantısını kontrol edin
4. API anahtarlarının geçerliliğini kontrol edin

## 📝 Notlar

- Raspberry Pi'nın güç kaynağının yeterli olduğundan emin olun (3A+)
- SD kart hızının Class 10 veya üzeri olması önerilir
- Düzenli yedekleme yapın
- Sistem güncellemelerini takip edin 