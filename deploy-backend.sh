#!/bin/bash
# Render.com Backend Deploy Script

echo "========================================"
echo "🚀 Render.com Backend Deploy"
echo "========================================"

# Install dependencies
echo "[1/4] Installing dependencies..."
cd backend
npm install --production

# Generate Prisma client
echo "[2/4] Generating Prisma client..."
npx prisma generate

# Run migrations
echo "[3/4] Running database migrations..."
npx prisma migrate deploy

# Create directories
echo "[4/4] Creating necessary directories..."
mkdir -p /tmp/sessions recordings

echo "✅ Deploy complete!"
echo "Backend service is ready to start"
