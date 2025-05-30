#!/bin/bash

# AI Fitness Assistant - Sanal Ortam Log Görüntüleme Scripti

PROJECT_DIR="/home/growbox/fit-chatbot"
cd $PROJECT_DIR

echo "📊 AI Fitness Assistant - Log Görüntüleme"
echo "========================================"

# PID dosyalarını kontrol et
if [ -f ".backend.pid" ]; then
    BACKEND_PID=$(cat .backend.pid)
    if ps -p $BACKEND_PID > /dev/null 2>&1; then
        echo "✅ Backend çalışıyor (PID: $BACKEND_PID)"
    else
        echo "❌ Backend çalışmıyor"
    fi
else
    echo "❌ Backend PID dosyası bulunamadı"
fi

if [ -f ".frontend.pid" ]; then
    FRONTEND_PID=$(cat .frontend.pid)
    if ps -p $FRONTEND_PID > /dev/null 2>&1; then
        echo "✅ Frontend çalışıyor (PID: $FRONTEND_PID)"
    else
        echo "❌ Frontend çalışmıyor"
    fi
else
    echo "❌ Frontend PID dosyası bulunamadı"
fi

echo ""
echo "🔍 Port durumları:"
echo "Port 8000 (Backend): $(lsof -ti:8000 2>/dev/null && echo 'Kullanımda' || echo 'Boş')"
echo "Port 3000 (Frontend): $(lsof -ti:3000 2>/dev/null && echo 'Kullanımda' || echo 'Boş')"

echo ""
echo "📝 Son sistem logları:"
echo "====================="
journalctl --user -n 20 --no-pager

echo ""
echo "🌐 Erişim testi:"
echo "==============="
echo "Backend health check:"
curl -s http://localhost:8000/health 2>/dev/null && echo " ✅" || echo " ❌"

echo "Frontend erişim:"
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 2>/dev/null && echo " ✅" || echo " ❌"

echo ""
echo "📊 Sistem kaynakları:"
echo "===================="
echo "CPU kullanımı:"
top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1

echo "Bellek kullanımı:"
free -h | grep Mem | awk '{print "Kullanılan: " $3 "/" $2 " (" $3/$2*100 "%)"}'

echo "Disk kullanımı:"
df -h / | tail -1 | awk '{print "Kullanılan: " $3 "/" $2 " (" $5 ")"}' 