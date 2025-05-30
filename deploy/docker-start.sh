#!/bin/bash

# AI Fitness Assistant Docker Start Script

set -e

PROJECT_DIR="/home/growbox/fit-chatbot"
cd $PROJECT_DIR

echo "🚀 AI Fitness Assistant Docker ile başlatılıyor..."

# .env dosyasının varlığını kontrol et
if [ ! -f ".env" ]; then
    echo "❌ .env dosyası bulunamadı!"
    echo "Lütfen önce ./deploy/docker-setup.sh scriptini çalıştırın."
    exit 1
fi

# API anahtarlarının varlığını kontrol et
if grep -q "your_openai_api_key_here" .env; then
    echo "❌ OpenAI API anahtarı henüz ayarlanmamış!"
    echo "Lütfen .env dosyasını düzenleyin: nano .env"
    exit 1
fi

if grep -q "your_tavily_api_key_here" .env; then
    echo "❌ Tavily API anahtarı henüz ayarlanmamış!"
    echo "Lütfen .env dosyasını düzenleyin: nano .env"
    exit 1
fi

# Docker containers'ları başlat (Cloudflare tunnel hariç)
echo "🐳 Docker containers başlatılıyor..."
docker-compose up -d fitness-backend fitness-frontend nginx

# Containers'ların başlamasını bekle
echo "⏳ Containers'ların başlaması bekleniyor..."
sleep 10

# Health check
echo "🔍 Health check yapılıyor..."
for i in {1..30}; do
    if curl -f http://localhost/health > /dev/null 2>&1; then
        echo "✅ Uygulama başarıyla başlatıldı!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Uygulama başlatılamadı. Logları kontrol edin:"
        echo "docker-compose logs"
        exit 1
    fi
    echo "Deneme $i/30..."
    sleep 2
done

echo ""
echo "📊 Container durumları:"
docker-compose ps

echo ""
echo "🌐 Erişim adresleri:"
echo "Yerel: http://localhost"
echo "Yerel IP: http://$(hostname -I | awk '{print $1}')"

echo ""
echo "📝 Yönetim komutları:"
echo "Logları görüntüle: docker-compose logs -f"
echo "Durdur: ./deploy/docker-stop.sh"
echo "Yeniden başlat: ./deploy/docker-restart.sh"

echo ""
echo "☁️ Cloudflare tunnel kurmak için:"
echo "./deploy/docker-cloudflare.sh" 