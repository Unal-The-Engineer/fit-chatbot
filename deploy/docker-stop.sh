#!/bin/bash

# AI Fitness Assistant Docker Stop Script

set -e

PROJECT_DIR="/home/growbox/fit-chatbot"
cd $PROJECT_DIR

echo "🛑 AI Fitness Assistant Docker containers durduruluyor..."

# Tüm containers'ları durdur
docker-compose down

echo "✅ Tüm containers durduruldu!"

echo ""
echo "📊 Container durumları:"
docker-compose ps

echo ""
echo "🚀 Yeniden başlatmak için:"
echo "./deploy/docker-start.sh" 