#!/bin/bash

# AI Fitness Assistant Başlatma Scripti

set -e

PROJECT_DIR="/home/pi/ai-fitness-assistant"
cd $PROJECT_DIR

echo "🚀 AI Fitness Assistant başlatılıyor..."

# .env dosyasının varlığını kontrol et
if [ ! -f ".env" ]; then
    echo "❌ .env dosyası bulunamadı!"
    echo "Lütfen önce .env dosyasını oluşturun ve API anahtarlarınızı ekleyin."
    echo "Örnek: cp .env.example .env && nano .env"
    exit 1
fi

# Backend'i PM2 ile başlat
echo "🐍 Backend başlatılıyor..."
pm2 start ecosystem.config.js

# PM2'yi sistem başlangıcında otomatik başlatmak için kaydet
pm2 save
pm2 startup

echo "✅ Uygulama başarıyla başlatıldı!"
echo ""
echo "📊 Durum kontrolü:"
echo "Backend: pm2 status"
echo "Nginx: sudo systemctl status nginx"
echo ""
echo "📝 Logları görüntülemek için:"
echo "Backend logs: pm2 logs ai-fitness-backend"
echo "Nginx logs: sudo tail -f /var/log/nginx/access.log"
echo ""
echo "🌐 Yerel erişim: http://localhost"
echo ""
echo "🔧 Cloudflare tunnel kurulumu için:"
echo "./cloudflare-setup.sh" 