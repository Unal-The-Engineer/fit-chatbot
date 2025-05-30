#!/bin/bash

# AI Fitness Assistant - Quick Start Script
# Bu script tüm kurulum sürecini otomatikleştirir

set -e

echo "🚀 AI Fitness Assistant - Hızlı Kurulum Başlıyor..."
echo "Bu script yaklaşık 10-15 dakika sürecek."
echo ""

# Kullanıcıdan onay al
read -p "Devam etmek istiyor musunuz? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Kurulum iptal edildi."
    exit 1
fi

# API anahtarlarını al
echo "📝 API Anahtarlarını Girin:"
read -p "OpenAI API Key: " OPENAI_KEY
read -p "Tavily API Key: " TAVILY_KEY

if [ -z "$OPENAI_KEY" ] || [ -z "$TAVILY_KEY" ]; then
    echo "❌ API anahtarları gereklidir!"
    exit 1
fi

# Proje dizini
PROJECT_DIR="/home/growbox/fit-chatbot"

echo ""
echo "🔧 Adım 1/5: Sistem hazırlığı..."
# Temel kurulum
./deploy/install.sh

echo ""
echo "📁 Adım 2/5: Proje kurulumu..."
cd $PROJECT_DIR
chmod +x deploy/*.sh
./deploy/setup.sh

echo ""
echo "🔑 Adım 3/5: API anahtarları yapılandırılıyor..."
# .env dosyasını güncelle
sed -i "s/your_openai_api_key_here/$OPENAI_KEY/g" .env
sed -i "s/your_tavily_api_key_here/$TAVILY_KEY/g" .env

echo ""
echo "🚀 Adım 4/5: Uygulama başlatılıyor..."
./deploy/start.sh

echo ""
echo "☁️ Adım 5/5: Cloudflare tunnel kurulumu..."
echo "Bu adım manuel müdahale gerektirir."
echo ""
echo "Cloudflare tunnel kurmak için:"
echo "1. ./deploy/cloudflare-setup.sh komutunu çalıştırın"
echo "2. Tarayıcınızda Cloudflare hesabınıza giriş yapın"
echo "3. Script'in talimatlarını takip edin"
echo ""

echo "✅ Temel kurulum tamamlandı!"
echo ""
echo "🌐 Yerel erişim: http://$(hostname -I | awk '{print $1}')"
echo ""
echo "📊 Durum kontrolü:"
echo "pm2 status"
echo "sudo systemctl status nginx"
echo ""
echo "📝 Cloudflare tunnel kurulumu için:"
echo "./deploy/cloudflare-setup.sh"
echo ""
echo "🔧 Yönetim komutları:"
echo "Durdurma: ./deploy/stop.sh"
echo "Güncelleme: ./deploy/update.sh"
echo "Loglar: pm2 logs ai-fitness-backend" 