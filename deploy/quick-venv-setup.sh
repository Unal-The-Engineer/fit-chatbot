#!/bin/bash

# AI Fitness Assistant - Hızlı Sanal Ortam Kurulumu
# Raspberry Pi Ubuntu için tek komut kurulum

set -e

echo "🚀 AI Fitness Assistant - Hızlı Kurulum Başlıyor..."
echo "=================================================="

# Proje dizini
PROJECT_DIR="/home/growbox/fit-chatbot"

# Eğer proje dizini varsa, içine git
if [ -d "$PROJECT_DIR" ]; then
    echo "📁 Mevcut proje dizinine geçiliyor: $PROJECT_DIR"
    cd $PROJECT_DIR
    
    # Git güncellemesi
    echo "📥 Git repository güncelleniyor..."
    git pull origin main
else
    # Proje dizinini oluştur ve klonla
    echo "📁 Proje dizini oluşturuluyor: $PROJECT_DIR"
    mkdir -p $PROJECT_DIR
    cd $PROJECT_DIR
    
    echo "📥 Git repository klonlanıyor..."
    git clone https://github.com/Unal-The-Engineer/fit-chatbot.git .
fi

# Kurulum scriptini çalıştır
echo "🔧 Sanal ortam kurulumu başlatılıyor..."
./deploy/venv-setup.sh

echo ""
echo "✅ Hızlı kurulum tamamlandı!"
echo ""
echo "📝 Sonraki adımlar:"
echo "1. API anahtarlarınızı .env dosyasına ekleyin:"
echo "   cd $PROJECT_DIR"
echo "   nano .env"
echo ""
echo "2. Uygulamayı başlatın:"
echo "   ./deploy/venv-start.sh" 