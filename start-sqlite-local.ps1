# VFS Booking Bot - SQLite Local Server (Docker, PostgreSQL, Redis'siz!)
# Bu script barcha jarayonlarni avtomatik bajaradi

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🚀 SQLite Local Server Setup" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "✅ Hech narsa o'rnatish shart emas!" -ForegroundColor Yellow
Write-Host "   - Docker kerak emas" -ForegroundColor Gray
Write-Host "   - PostgreSQL kerak emas" -ForegroundColor Gray
Write-Host "   - Redis kerak emas" -ForegroundColor Gray
Write-Host "   - Faqat Node.js kerak!`n" -ForegroundColor Gray

# 1. .env fayl tekshirish
Write-Host "[1/5] .env fayl tekshirilmoqda..." -ForegroundColor Yellow

if (-not (Test-Path .env)) {
    Write-Host "⚠️  .env fayl topilmadi, yaratilmoqda..." -ForegroundColor Yellow
    
    $envContent = @"
# ─── Server ───────────────────────────────────────────────────────────────────
NODE_ENV=development
PORT=3001
FRONTEND_URL=http://localhost:3000

# ─── Database (SQLite) ────────────────────────────────────────────────────────
DATABASE_URL=file:./dev.db

# ─── Auth ─────────────────────────────────────────────────────────────────────
JWT_ACCESS_SECRET=6abd5f2beb0fe212d9fe2cd8ea2a47bb200068039537a007eb73aa4b0d12033bc8c14000fb1cd95b59138f7b96524d76c98346632196b0b16cb27a7462e500b2
JWT_REFRESH_SECRET=30b1006e78be18928ca7d53b008129385afe86971369eb4a451510b9ec80835dd163da5c5fb38086fde34633a2ec9078332e755483540a07e59dde5ae7d1db18
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d

# ─── Encryption ───────────────────────────────────────────────────────────────
PROFILE_ENCRYPTION_KEY=b3e6d0d174b79e0a1fd6772b40701f78b282a10421710e39262be849a4a4172a

# ─── Captcha ──────────────────────────────────────────────────────────────────
TWOCAPTCHA_API_KEY=
CAPTCHA_SOLVER=manual

# ─── Proxy ────────────────────────────────────────────────────────────────────
PROXY_DEFAULT_PROVIDER=proxyrack
PROXY_HOST=premium.residential.proxyrack.net
PROXY_PORT=10000
PROXY_USERNAME=
PROXY_PASSWORD=

# ─── Telegram ─────────────────────────────────────────────────────────────────
TELEGRAM_BOT_TOKEN=
TELEGRAM_CHAT_ID=
TELEGRAM_PROXY=

# ─── Automation ───────────────────────────────────────────────────────────────
BOOKING_CONCURRENCY=3
MONITOR_DEFAULT_INTERVAL_MS=30000
SESSION_DIR=./sessions
BOOKING_MAX_RETRIES=3
"@
    
    Set-Content -Path .env -Value $envContent -Force
    Write-Host "✅ .env fayl yaratildi" -ForegroundColor Green
} else {
    Write-Host "✅ .env fayl mavjud" -ForegroundColor Green
}

# 2. Backend kutubxonalarni o'rnatish
Write-Host "`n[2/5] Backend kutubxonalarni o'rnatish..." -ForegroundColor Yellow

if (Test-Path backend\package.json) {
    if (-not (Test-Path backend\node_modules)) {
        Write-Host "Backend kutubxonalarni o'rnatayapman... (bu bir oz vaqt olishi mumkin)" -ForegroundColor Cyan
        Set-Location backend
        npm install --legacy-peer-deps 2>&1 | Out-String
        Set-Location ..
        Write-Host "✅ Backend kutubxonalarni o'rnatildi" -ForegroundColor Green
    } else {
        Write-Host "✅ Backend kutubxonalarni o'rnatilgan" -ForegroundColor Green
    }
} else {
    Write-Host "❌ backend/package.json topilmadi!" -ForegroundColor Red
    exit 1
}

# 3. Frontend kutubxonalarni o'rnatish
Write-Host "`n[3/5] Frontend kutubxonalarni o'rnatish..." -ForegroundColor Yellow

if (Test-Path frontend\package.json) {
    if (-not (Test-Path frontend\node_modules)) {
        Write-Host "Frontend kutubxonalarni o'rnatayapman... (bu bir oz vaqt olishi mumkin)" -ForegroundColor Cyan
        Set-Location frontend
        npm install 2>&1 | Out-String
        Set-Location ..
        Write-Host "✅ Frontend kutubxonalarni o'rnatildi" -ForegroundColor Green
    } else {
        Write-Host "✅ Frontend kutubxonalarni o'rnatilgan" -ForegroundColor Green
    }
} else {
    Write-Host "❌ frontend/package.json topilmadi!" -ForegroundColor Red
    exit 1
}

# 4. Prisma generate va migration
Write-Host "`n[4/5] Database sozlanmoqda..." -ForegroundColor Yellow

Set-Location backend

Write-Host "Prisma client generate qilinmoqda..." -ForegroundColor Cyan
npx prisma generate 2>&1 | Out-Null

Write-Host "Database migration qilinmoqda..." -ForegroundColor Cyan
try {
    npx prisma migrate dev --name init 2>&1 | Out-Null
    Write-Host "✅ Database migration qilindi" -ForegroundColor Green
} catch {
    # Agar migration muammo bo'lsa, deploy try qiling
    try {
        npx prisma migrate deploy 2>&1 | Out-Null
        Write-Host "✅ Database migration qilindi (deploy)" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Migration muammo, davom etilmoqda..." -ForegroundColor Yellow
    }
}

# 5. Admin account yaratish
Write-Host "`n[5/5] Admin account yaratilmoqda..." -ForegroundColor Yellow

try {
    npx ts-node -r tsconfig-paths/register prisma/seed.ts 2>&1 | Out-Null
    Write-Host "✅ Admin account yaratildi" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Admin account yaratishda muammo" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}

Set-Location ..

# Yakuniy xabar
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🎉 SQLite Server Tayyor!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "📊 Xizmatlar:" -ForegroundColor Yellow
Write-Host "  • Database:   database.db (SQLite file)" -ForegroundColor White
Write-Host "  • Backend:    http://localhost:3001" -ForegroundColor White
Write-Host "  • Frontend:   http://localhost:3000" -ForegroundColor White

Write-Host "`n👤 Admin Login:" -ForegroundColor Yellow
Write-Host "  • Email:    admin@vfsbot.local" -ForegroundColor White
Write-Host "  • Password: admin1234" -ForegroundColor White

Write-Host "`n🚀 Serverlarni Ishga Tushirish:" -ForegroundColor Yellow
Write-Host "`nBackend uchun:" -ForegroundColor White
Write-Host "  cd backend" -ForegroundColor Gray
Write-Host "  npm run dev" -ForegroundColor Gray

Write-Host "`nFrontend uchun:" -ForegroundColor White
Write-Host "  cd frontend" -ForegroundColor Gray
Write-Host "  npm run dev" -ForegroundColor Gray

Write-Host "`n✅ Tayyor! Endi ikkita yangi terminal ochib, yuqoridagi buyruqlarni bajaring`n" -ForegroundColor Green
