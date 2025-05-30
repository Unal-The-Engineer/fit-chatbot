#!/bin/bash

# AI Fitness Assistant Güncelleme Scripti

set -e

PROJECT_DIR="/home/growbox/fit-chatbot"
cd $PROJECT_DIR

echo "🔄 AI Fitness Assistant güncelleniyor..."

# Git'ten son değişiklikleri çek
echo "📥 Son değişiklikler çekiliyor..."
git pull origin main

# Backend bağımlılıklarını güncelle
echo "🐍 Backend bağımlılıkları güncelleniyor..."
cd backend
source venv/bin/activate
pip install --upgrade pip
pip install -r ../requirements.txt
cd ..

# Frontend'i yeniden build et
echo "⚛️ Frontend yeniden build ediliyor..."
cd frontend
npm install
npm run build
cd ..

# Backend'i yeniden başlat
echo "🔄 Backend yeniden başlatılıyor..."
pm2 restart ai-fitness-backend

# Nginx'i yeniden yükle
echo "🌐 Nginx yeniden yükleniyor..."
sudo nginx -t
sudo systemctl reload nginx

echo "✅ Güncelleme tamamlandı!"
echo ""
echo "📊 Durum kontrolü:"
echo "pm2 status"
echo "sudo systemctl status nginx"
echo "sudo systemctl status cloudflared" 