#!/bin/bash

# AI Fitness Assistant - Sanal Ortam Durdurma Scripti

set -e

PROJECT_DIR="/home/growbox/fit-chatbot"
cd $PROJECT_DIR

echo "🛑 AI Fitness Assistant durduruluyor..."

# PID dosyalarını kontrol et ve process'leri durdur
if [ -f ".backend.pid" ]; then
    BACKEND_PID=$(cat .backend.pid)
    if ps -p $BACKEND_PID > /dev/null 2>&1; then
        echo "🔴 Backend durduruluyor (PID: $BACKEND_PID)..."
        kill $BACKEND_PID
    fi
    rm -f .backend.pid
fi

if [ -f ".frontend.pid" ]; then
    FRONTEND_PID=$(cat .frontend.pid)
    if ps -p $FRONTEND_PID > /dev/null 2>&1; then
        echo "🔴 Frontend durduruluyor (PID: $FRONTEND_PID)..."
        kill $FRONTEND_PID
    fi
    rm -f .frontend.pid
fi

# Alternatif olarak port'larda çalışan process'leri durdur
echo "🔍 Port 8001 ve 3000'de çalışan process'ler kontrol ediliyor..."

# Port 8001 (Backend)
BACKEND_PROC=$(lsof -ti:8001 2>/dev/null || true)
if [ ! -z "$BACKEND_PROC" ]; then
    echo "🔴 Port 8001'de çalışan process durduruluyor..."
    kill $BACKEND_PROC 2>/dev/null || true
fi

# Port 3000 (Frontend)
FRONTEND_PROC=$(lsof -ti:3000 2>/dev/null || true)
if [ ! -z "$FRONTEND_PROC" ]; then
    echo "🔴 Port 3000'de çalışan process durduruluyor..."
    kill $FRONTEND_PROC 2>/dev/null || true
fi

echo "✅ Uygulama durduruldu!"

echo ""
echo "🚀 Yeniden başlatmak için:"
echo "./deploy/venv-start.sh" 