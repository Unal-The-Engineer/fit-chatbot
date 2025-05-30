#!/bin/bash

# AI Fitness Assistant - Sanal Ortam Yeniden Başlatma Scripti

set -e

PROJECT_DIR="/home/growbox/fit-chatbot"
cd $PROJECT_DIR

echo "🔄 AI Fitness Assistant yeniden başlatılıyor..."

# Önce durdur
echo "🛑 Mevcut uygulamayı durduruyor..."
./deploy/venv-stop.sh

# Kısa bir bekleme
sleep 2

# Sonra başlat
echo "🚀 Uygulamayı yeniden başlatıyor..."
./deploy/venv-start.sh 