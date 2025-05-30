#!/bin/bash

# Cloudflare Tunnel Kurulum Scripti

set -e

echo "☁️ Cloudflare Tunnel Kurulumu..."

# Cloudflare hesabına giriş
echo "🔐 Cloudflare hesabınıza giriş yapın..."
cloudflared tunnel login

# Tunnel oluşturma
echo "🚇 Yeni tunnel oluşturuluyor..."
read -p "Tunnel adını girin (örnek: ai-fitness-pi): " TUNNEL_NAME

if [ -z "$TUNNEL_NAME" ]; then
    TUNNEL_NAME="ai-fitness-pi"
fi

cloudflared tunnel create $TUNNEL_NAME

# Tunnel ID'sini al
TUNNEL_ID=$(cloudflared tunnel list | grep $TUNNEL_NAME | awk '{print $1}')

if [ -z "$TUNNEL_ID" ]; then
    echo "❌ Tunnel oluşturulamadı!"
    exit 1
fi

echo "✅ Tunnel oluşturuldu: $TUNNEL_NAME (ID: $TUNNEL_ID)"

# Konfigürasyon dosyası oluşturma
echo "📝 Tunnel konfigürasyonu oluşturuluyor..."
mkdir -p ~/.cloudflared

cat > ~/.cloudflared/config.yml << EOF
tunnel: $TUNNEL_ID
credentials-file: /home/pi/.cloudflared/$TUNNEL_ID.json

ingress:
  - hostname: $TUNNEL_NAME.trycloudflare.com
    service: http://localhost:80
  - service: http_status:404
EOF

# DNS kaydı oluşturma
echo "🌐 DNS kaydı oluşturuluyor..."
read -p "Domain adınızı girin (örnek: myapp.example.com) veya Enter'a basarak otomatik subdomain kullanın: " DOMAIN

if [ -z "$DOMAIN" ]; then
    echo "Otomatik subdomain kullanılacak: $TUNNEL_NAME.trycloudflare.com"
else
    cloudflared tunnel route dns $TUNNEL_NAME $DOMAIN
    # Konfigürasyonu güncelle
    sed -i "s/$TUNNEL_NAME.trycloudflare.com/$DOMAIN/g" ~/.cloudflared/config.yml
    echo "✅ DNS kaydı oluşturuldu: $DOMAIN"
fi

# Systemd service oluşturma
echo "⚙️ Systemd service oluşturuluyor..."
sudo tee /etc/systemd/system/cloudflared.service << EOF
[Unit]
Description=Cloudflare Tunnel
After=network.target

[Service]
Type=simple
User=pi
ExecStart=/usr/local/bin/cloudflared tunnel run
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

# Service'i etkinleştirme
sudo systemctl daemon-reload
sudo systemctl enable cloudflared
sudo systemctl start cloudflared

# .env dosyasını güncelleme
PROJECT_DIR="/home/pi/ai-fitness-assistant"
if [ -f "$PROJECT_DIR/.env" ]; then
    if [ -z "$DOMAIN" ]; then
        FRONTEND_URL="https://$TUNNEL_NAME.trycloudflare.com"
    else
        FRONTEND_URL="https://$DOMAIN"
    fi
    
    sed -i "s|FRONTEND_URL=.*|FRONTEND_URL=$FRONTEND_URL|g" "$PROJECT_DIR/.env"
    echo "✅ .env dosyası güncellendi: FRONTEND_URL=$FRONTEND_URL"
    
    # Backend'i yeniden başlat
    cd $PROJECT_DIR
    pm2 restart ai-fitness-backend
fi

echo ""
echo "🎉 Cloudflare Tunnel kurulumu tamamlandı!"
echo ""
echo "📊 Durum kontrolü:"
echo "Tunnel durumu: sudo systemctl status cloudflared"
echo "Tunnel logları: sudo journalctl -u cloudflared -f"
echo ""
if [ -z "$DOMAIN" ]; then
    echo "🌐 Uygulamanız şu adreste erişilebilir:"
    echo "https://$TUNNEL_NAME.trycloudflare.com"
else
    echo "🌐 Uygulamanız şu adreste erişilebilir:"
    echo "https://$DOMAIN"
fi
echo ""
echo "📝 Tunnel yönetimi:"
echo "Durdurma: sudo systemctl stop cloudflared"
echo "Başlatma: sudo systemctl start cloudflared"
echo "Yeniden başlatma: sudo systemctl restart cloudflared" 