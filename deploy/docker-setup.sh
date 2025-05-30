#!/bin/bash

# AI Fitness Assistant Docker Setup Script

set -e

echo "🐳 AI Fitness Assistant Docker Kurulumu Başlıyor..."

# Docker kurulumu kontrolü
if ! command -v docker &> /dev/null; then
    echo "📦 Docker kurulumu..."
    sudo apt update
    sudo apt install -y docker.io docker-compose
    sudo usermod -aG docker $USER
    echo "⚠️  Docker kuruldu. Lütfen sistemi yeniden başlatın veya yeni bir terminal açın."
    echo "Sonra bu scripti tekrar çalıştırın."
    exit 0
fi

# Docker Compose kurulumu kontrolü
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Docker Compose kurulumu..."
    sudo apt install -y docker-compose
fi

# Proje dizini
PROJECT_DIR="/home/growbox/fit-chatbot"
cd $PROJECT_DIR

echo "🔧 Docker ortamı hazırlanıyor..."

# Gerekli dizinleri oluştur
mkdir -p nginx ssl logs

# .env dosyasının varlığını kontrol et
if [ ! -f ".env" ]; then
    echo "📝 .env dosyası oluşturuluyor..."
    cat > .env << 'EOF'
# OpenAI API Key
OPENAI_API_KEY=your_openai_api_key_here

# Tavily API Key
TAVILY_API_KEY=your_tavily_api_key_here

# Cloudflare Tunnel Token (opsiyonel)
CLOUDFLARE_TUNNEL_TOKEN=your_tunnel_token_here
EOF
    
    echo "❌ .env dosyası oluşturuldu. Lütfen API anahtarlarınızı ekleyin:"
    echo "   nano .env"
    echo ""
    echo "Sonra şu komutu çalıştırın:"
    echo "   ./deploy/docker-start.sh"
    exit 1
fi

# Docker images'ları build et
echo "🔨 Docker images build ediliyor..."
docker-compose build

echo "✅ Docker setup tamamlandı!"
echo ""
echo "📝 Sonraki adımlar:"
echo "1. API anahtarlarınızı .env dosyasına ekleyin (eğer henüz yapmadıysanız)"
echo "2. Uygulamayı başlatın: ./deploy/docker-start.sh"
echo "3. Cloudflare tunnel kurun: ./deploy/docker-cloudflare.sh" 