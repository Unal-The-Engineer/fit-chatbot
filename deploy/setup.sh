#!/bin/bash

# AI Fitness Assistant Proje Kurulum Scripti
# Bu script projeyi Raspberry Pi'da kurar ve yapılandırır

set -e

PROJECT_DIR="/home/pi/ai-fitness-assistant"
cd $PROJECT_DIR

echo "🔧 AI Fitness Assistant Proje Kurulumu..."

# Backend kurulumu
echo "🐍 Backend kurulumu..."
cd backend

# Python virtual environment oluşturma
python3 -m venv venv
source venv/bin/activate

# Python bağımlılıklarını kurma
pip install --upgrade pip
pip install -r ../requirements.txt

cd ..

# Frontend kurulumu
echo "⚛️ Frontend kurulumu..."
cd frontend

# Node.js bağımlılıklarını kurma
npm install

# Production build oluşturma
npm run build

cd ..

# .env dosyası şablonu oluşturma
echo "📝 .env dosyası şablonu oluşturuluyor..."
cat > .env << 'EOF'
# OpenAI API Key
OPENAI_API_KEY=your_openai_api_key_here

# Tavily API Key (web search için)
TAVILY_API_KEY=your_tavily_api_key_here

# Server Configuration
HOST=0.0.0.0
PORT=8000
DEBUG=false

# Frontend URL (Cloudflare tunnel URL'i buraya gelecek)
FRONTEND_URL=https://your-domain.your-tunnel.trycloudflare.com
EOF

# PM2 ecosystem dosyası oluşturma
echo "⚙️ PM2 konfigürasyonu oluşturuluyor..."
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [
    {
      name: 'ai-fitness-backend',
      script: 'backend/venv/bin/python',
      args: 'backend/main.py',
      cwd: '/home/pi/ai-fitness-assistant',
      env: {
        NODE_ENV: 'production'
      },
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      error_file: './logs/backend-error.log',
      out_file: './logs/backend-out.log',
      log_file: './logs/backend-combined.log',
      time: true
    }
  ]
};
EOF

# Log dizini oluşturma
mkdir -p logs

# Nginx konfigürasyonu oluşturma
echo "🌐 Nginx konfigürasyonu oluşturuluyor..."
sudo tee /etc/nginx/sites-available/ai-fitness-assistant << 'EOF'
server {
    listen 80;
    server_name localhost;

    # Frontend static files
    location / {
        root /home/pi/ai-fitness-assistant/frontend/dist;
        try_files $uri $uri/ /index.html;
        
        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # Backend API
    location /api/ {
        proxy_pass http://127.0.0.1:8000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# Nginx site'ı aktifleştirme
sudo ln -sf /etc/nginx/sites-available/ai-fitness-assistant /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Nginx test ve restart
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

echo "✅ Proje kurulumu tamamlandı!"
echo ""
echo "📝 Sonraki adımlar:"
echo "1. .env dosyasını düzenleyin ve API anahtarlarınızı ekleyin:"
echo "   nano .env"
echo ""
echo "2. Uygulamayı başlatmak için:"
echo "   ./start.sh"
echo ""
echo "3. Cloudflare tunnel kurulumu için:"
echo "   ./cloudflare-setup.sh" 