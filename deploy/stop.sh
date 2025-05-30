#!/bin/bash

# AI Fitness Assistant Durdurma Scripti

set -e

echo "🛑 AI Fitness Assistant durduruluyor..."

# Backend'i durdur
echo "🐍 Backend durduruluyor..."
pm2 stop ai-fitness-backend || echo "Backend zaten durdurulmuş"

# Cloudflare tunnel'ı durdur
echo "☁️ Cloudflare tunnel durduruluyor..."
sudo systemctl stop cloudflared || echo "Cloudflare tunnel zaten durdurulmuş"

echo "✅ Uygulama durduruldu!"
echo ""
echo "📊 Durum kontrolü:"
echo "Backend: pm2 status"
echo "Cloudflare: sudo systemctl status cloudflared"
echo ""
echo "🚀 Yeniden başlatmak için:"
echo "./start.sh" 