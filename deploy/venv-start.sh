#!/bin/bash

# AI Fitness Assistant - Sanal Ortam Başlatma Scripti

set -e

PROJECT_DIR="/home/growbox/fit-chatbot"
cd $PROJECT_DIR

echo "🚀 AI Fitness Assistant sanal ortamda başlatılıyor..."

# .env dosyasının varlığını kontrol et
if [ ! -f ".env" ]; then
    echo "❌ .env dosyası bulunamadı!"
    echo "Lütfen önce ./deploy/venv-setup.sh scriptini çalıştırın."
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

# Sanal ortamın varlığını kontrol et
if [ ! -d "venv" ]; then
    echo "❌ Sanal ortam bulunamadı!"
    echo "Lütfen önce ./deploy/venv-setup.sh scriptini çalıştırın."
    exit 1
fi

# Sanal ortamı aktifleştir
echo "🔧 Sanal ortam aktifleştiriliyor..."
source venv/bin/activate

# Frontend'i build et
echo "🔨 Frontend build ediliyor..."
cd frontend
npm run build
cd ..

# Backend'i başlat (arka planda)
echo "🚀 Backend başlatılıyor..."
cd backend
python main.py &
BACKEND_PID=$!
cd ..

# Backend'in başlamasını bekle
echo "⏳ Backend'in başlaması bekleniyor..."
sleep 5

# Frontend'i serve et (arka planda)
echo "🌐 Frontend serve ediliyor..."
cd frontend
npx serve -s dist -l 3000 &
FRONTEND_PID=$!
cd ..

# Health check
echo "🔍 Health check yapılıyor..."
for i in {1..30}; do
    if curl -f http://localhost:8000/health > /dev/null 2>&1; then
        echo "✅ Backend başarıyla başlatıldı!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Backend başlatılamadı!"
        kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
        exit 1
    fi
    echo "Backend deneme $i/30..."
    sleep 2
done

for i in {1..30}; do
    if curl -f http://localhost:3000 > /dev/null 2>&1; then
        echo "✅ Frontend başarıyla başlatıldı!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Frontend başlatılamadı!"
        kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
        exit 1
    fi
    echo "Frontend deneme $i/30..."
    sleep 2
done

# PID'leri kaydet
echo $BACKEND_PID > .backend.pid
echo $FRONTEND_PID > .frontend.pid

echo ""
echo "✅ Uygulama başarıyla başlatıldı!"
echo ""
echo "🌐 Erişim adresleri:"
echo "Frontend: http://localhost:3000"
echo "Backend API: http://localhost:8000"
echo "Backend Docs: http://localhost:8000/docs"
echo "Yerel IP: http://$(hostname -I | awk '{print $1}'):3000"

echo ""
echo "📝 Yönetim komutları:"
echo "Durdur: ./deploy/venv-stop.sh"
echo "Logları görüntüle: ./deploy/venv-logs.sh"
echo "Yeniden başlat: ./deploy/venv-restart.sh"

echo ""
echo "⚠️  Uygulamayı durdurmak için Ctrl+C yerine ./deploy/venv-stop.sh kullanın"

# Kullanıcı müdahalesi bekle
trap 'echo ""; echo "🛑 Uygulama durduruluyor..."; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true; rm -f .backend.pid .frontend.pid; exit 0' INT

echo "📊 Uygulama çalışıyor... Durdurmak için Ctrl+C"
wait 