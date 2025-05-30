#!/bin/bash

# AI Fitness Assistant - Raspberry Pi Sanal Ortam Kurulumu

set -e

echo "🐍 AI Fitness Assistant - Raspberry Pi Sanal Ortam Kurulumu Başlıyor..."

# Proje dizini
PROJECT_DIR="/home/growbox/fit-chatbot"

# Eğer proje dizini yoksa oluştur
if [ ! -d "$PROJECT_DIR" ]; then
    echo "📁 Proje dizini oluşturuluyor: $PROJECT_DIR"
    mkdir -p $PROJECT_DIR
fi

cd $PROJECT_DIR

# Python sürüm kontrolü
echo "🔍 Python sürümü kontrol ediliyor..."
PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "Mevcut Python sürümü: $PYTHON_VERSION"

if [[ "$PYTHON_VERSION" == "3.13" ]]; then
    echo "⚠️  Python 3.13 tespit edildi. Pydantic uyumluluk sorunu olabilir."
    echo "🔧 Python 3.11 kurulumu öneriliyor..."
    
    # Python 3.11 kurulumu
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update
    sudo apt install -y python3.11 python3.11-venv python3.11-dev python3.11-distutils
    
    # Python 3.11'i varsayılan olarak ayarla
    PYTHON_CMD="python3.11"
    echo "✅ Python 3.11 kuruldu ve kullanılacak."
elif [[ "$PYTHON_VERSION" == "3.11" ]] || [[ "$PYTHON_VERSION" == "3.12" ]]; then
    echo "✅ Python $PYTHON_VERSION uyumlu."
    PYTHON_CMD="python3"
else
    echo "⚠️  Python $PYTHON_VERSION tespit edildi. Python 3.11 veya 3.12 öneriliyor."
    PYTHON_CMD="python3"
fi

# Sistem güncellemesi
echo "📦 Sistem paketleri güncelleniyor..."
sudo apt update
sudo apt upgrade -y

# Python ve gerekli paketlerin kurulumu
echo "🐍 Python ve gerekli paketler kuruluyor..."
sudo apt install -y python3-pip python3-venv python3-dev
sudo apt install -y build-essential libssl-dev libffi-dev
sudo apt install -y curl wget git nano

# Node.js kurulumu (frontend için)
echo "📦 Node.js kuruluyor..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# Git repository'yi klonla (eğer yoksa)
if [ ! -d ".git" ]; then
    echo "📥 Git repository klonlanıyor..."
    git clone https://github.com/Unal-The-Engineer/fit-chatbot.git .
fi

# Python sanal ortamı oluştur
echo "🔧 Python sanal ortamı oluşturuluyor..."
if [ -d "venv" ]; then
    echo "⚠️  Mevcut sanal ortam siliniyor..."
    rm -rf venv
fi

$PYTHON_CMD -m venv venv

# Sanal ortamı aktifleştir
echo "✅ Sanal ortam aktifleştiriliyor..."
source venv/bin/activate

# pip'i güncelle
echo "📦 pip güncelleniyor..."
pip install --upgrade pip

# Python sürümüne göre requirements dosyası seç
if [[ "$PYTHON_VERSION" == "3.13" ]] || [[ "$PYTHON_CMD" == "python3.11" ]]; then
    REQUIREMENTS_FILE="requirements-py311.txt"
    echo "📦 Python 3.11/3.12 uyumlu paketler yükleniyor..."
else
    REQUIREMENTS_FILE="requirements.txt"
    echo "📦 Standart paketler yükleniyor..."
fi

# Python paketlerini yükle
if [ -f "$REQUIREMENTS_FILE" ]; then
    pip install -r $REQUIREMENTS_FILE
else
    echo "⚠️  $REQUIREMENTS_FILE bulunamadı, standart requirements.txt kullanılıyor..."
    pip install -r requirements.txt
fi

echo "✅ Python sanal ortamı başarıyla kuruldu!"

# Frontend bağımlılıklarını yükle
echo "📦 Frontend bağımlılıkları yükleniyor..."
cd frontend
npm install
cd ..

# .env dosyası oluştur
if [ ! -f ".env" ]; then
    echo "📝 .env dosyası oluşturuluyor..."
    cat > .env << 'EOF'
# OpenAI API Key
OPENAI_API_KEY=your_openai_api_key_here

# Tavily API Key  
TAVILY_API_KEY=your_tavily_api_key_here

# Backend URL (production)
VITE_API_URL=http://localhost:8000

# Debug mode
DEBUG=true
EOF
    
    echo "❌ .env dosyası oluşturuldu. Lütfen API anahtarlarınızı ekleyin:"
    echo "   nano .env"
fi

echo ""
echo "✅ Kurulum tamamlandı!"
echo ""
echo "🐍 Kullanılan Python: $PYTHON_CMD ($PYTHON_VERSION)"
echo "📦 Kullanılan requirements: $REQUIREMENTS_FILE"
echo ""
echo "📝 Sonraki adımlar:"
echo "1. API anahtarlarınızı .env dosyasına ekleyin:"
echo "   nano .env"
echo ""
echo "2. Uygulamayı başlatın:"
echo "   ./deploy/venv-start.sh"
echo ""
echo "3. Sanal ortamı manuel olarak aktifleştirmek için:"
echo "   source venv/bin/activate" 