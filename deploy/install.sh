#!/bin/bash

# Raspberry Pi Ubuntu Deployment Script for AI Fitness Assistant
# Bu script Raspberry Pi Ubuntu'da gerekli tüm bağımlılıkları kurar

set -e

echo "🚀 AI Fitness Assistant Raspberry Pi Ubuntu Kurulumu Başlıyor..."

# Sistem güncellemesi
echo "📦 Sistem paketleri güncelleniyor..."
sudo apt update && sudo apt upgrade -y

# Node.js ve npm kurulumu (LTS sürümü)
echo "📦 Node.js kurulumu..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Python3 ve pip kurulumu
echo "📦 Python3 ve pip kurulumu..."
sudo apt install -y python3 python3-pip python3-venv

# Git kurulumu (eğer yoksa)
echo "📦 Git kurulumu..."
sudo apt install -y git

# PM2 kurulumu (process manager)
echo "📦 PM2 kurulumu..."
sudo npm install -g pm2

# Nginx kurulumu
echo "📦 Nginx kurulumu..."
sudo apt install -y nginx

# Cloudflare tunnel kurulumu (ARM64 için)
echo "📦 Cloudflare tunnel kurulumu..."
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb
sudo dpkg -i cloudflared-linux-arm64.deb
rm cloudflared-linux-arm64.deb

# Proje dizini oluşturma (growbox kullanıcısı için)
echo "📁 Proje dizini hazırlanıyor..."
PROJECT_DIR="/home/growbox/fit-chatbot"
sudo mkdir -p $PROJECT_DIR
sudo chown growbox:growbox $PROJECT_DIR

echo "✅ Temel kurulum tamamlandı!"
echo "📝 Sonraki adımlar:"
echo "1. Projeyi Raspberry Pi'ya kopyalayın"
echo "2. setup.sh scriptini çalıştırın"
echo "3. .env dosyasını yapılandırın"
echo "4. start.sh ile uygulamayı başlatın" 