#!/bin/bash
# Render.com Frontend Deploy Script

echo "========================================"
echo "🚀 Render.com Frontend Deploy"
echo "========================================"

# Install dependencies
echo "[1/3] Installing dependencies..."
cd frontend
npm install

# Build for production
echo "[2/3] Building for production..."
npm run build

# Copy standalone files
echo "[3/3] Copying standalone files..."
cp -r .next/standalone/* ../server/
cp -r .next/static ../server/.next/static
cp -r public ../server/public

echo "✅ Deploy complete!"
echo "Frontend service is ready to start"
