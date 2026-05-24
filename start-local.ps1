# VFS Booking Bot - Local Server Start Script
# Docker'siz lokal serverda ishga tushirish

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🚀 VFS Booking Bot - Local Server Start" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

# 1. PostgreSQL tekshirish
Write-Host "[1/6] PostgreSQL tekshirilmoqda..." -ForegroundColor Yellow

$postgresqlPath = "C:\Program Files\PostgreSQL\16\bin\psql.exe"
if (Test-Path $postgresqlPath) {
    try {
        $result = & $postgresqlPath -U postgres -d postgres -c "SELECT version();" 2>&1 | Out-String
        Write-Host "✅ PostgreSQL topildi" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  PostgreSQL topildi, lekin connection muammo" -ForegroundColor Yellow
        Write-Host "   PostgreSQL o'rnatilganligini va ishlayotganligini tekshiring" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ PostgreSQL topilmadi!" -ForegroundColor Red
    Write-Host "`nPostgreSQL o'rnatish:" -ForegroundColor Yellow
    Write-Host "1. https://www.postgresql.org/download/windows/" -ForegroundColor White
    Write-Host "2. PostgreSQL 16.x yuklab oling va o'rnating" -ForegroundColor White
    Write-Host "3. Password: vfspass (yoki o'zingiz tanlangan)" -ForegroundColor White
    Write-Host "`nScript to'xtatildi." -ForegroundColor Red
    exit 1
}

# 2. Redis tekshirish
Write-Host "`n[2/6] Redis tekshirilmoqda..." -ForegroundColor Yellow

$redisPath = "C:\redis\redis-cli.exe"
$redisServerRunning = $false

if (Test-Path $redisPath) {
    try {
        $pong = & $redisPath ping 2>&1
        if ($pong -eq "PONG") {
            Write-Host "✅ Redis ishlayapti" -ForegroundColor Green
            $redisServerRunning = $true
        }
    } catch {
        Write-Host "⚠️  Redis topildi, lekin server ishga tushmagan" -ForegroundColor Yellow
        Write-Host "   Redis server ishga tushirish uchun:" -ForegroundColor Yellow
        Write-Host "   cd C:\redis`n   redis-server.exe" -ForegroundColor White
    }
} else {
    Write-Host "❌ Redis topilmadi!" -ForegroundColor Red
    Write-Host "`nRedis o'rnatish:" -ForegroundColor Yellow
    Write-Host "1. https://github.com/microsoftarchive/redis/releases" -ForegroundColor White
    Write-Host "2. redis-x64-3.0.504.zip yuklab oling" -ForegroundColor White
    Write-Host "3. C:\redis papkasiga extract qiling" -ForegroundColor White
    Write-Host "`nScript to'xtatildi." -ForegroundColor Red
    exit 1
}

# 3. .env fayl tekshirish
Write-Host "`n[3/6] .env fayl tekshirilmoqda..." -ForegroundColor Yellow

if (-not (Test-Path .env)) {
    Write-Host "❌ .env fayl topilmadi!" -ForegroundColor Red
    Write-Host "Lokal .env faylni yaratayapman..." -ForegroundColor Yellow
    
    $envContent = @"
# ─── Server ───────────────────────────────────────────────────────────────────
NODE_ENV=development
PORT=3001
FRONTEND_URL=http://localhost:3000

# ─── Database (Local PostgreSQL) ──────────────────────────────────────────────
DATABASE_URL=postgresql://vfsuser:vfspass@localhost:5432/vfsdb?schema=public

# ─── Redis (Local) ────────────────────────────────────────────────────────────
REDIS_URL=redis://localhost:6379

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

# 4. Backend kutubxonalarni o'rnatish
Write-Host "`n[4/6] Backend kutubxonalarni o'rnatish..." -ForegroundColor Yellow

if (Test-Path backend\package.json) {
    if (-not (Test-Path backend\node_modules)) {
        Write-Host "Backend kutubxonalarni o'rnatayapman..." -ForegroundColor Cyan
        Set-Location backend
        npm install --legacy-peer-deps
        Set-Location ..
        Write-Host "✅ Backend kutubxonalarni o'rnatildi" -ForegroundColor Green
    } else {
        Write-Host "✅ Backend kutubxonalarni o'rnatilgan" -ForegroundColor Green
    }
    
    # Prisma generate
    Write-Host "Prisma client generate qilinmoqda..." -ForegroundColor Cyan
    Set-Location backend
    npx prisma generate
    Set-Location ..
} else {
    Write-Host "❌ backend/package.json topilmadi!" -ForegroundColor Red
    exit 1
}

# 5. Frontend kutubxonalarni o'rnatish
Write-Host "`n[5/6] Frontend kutubxonalarni o'rnatish..." -ForegroundColor Yellow

if (Test-Path frontend\package.json) {
    if (-not (Test-Path frontend\node_modules)) {
        Write-Host "Frontend kutubxonalarni o'rnatayapman..." -ForegroundColor Cyan
        Set-Location frontend
        npm install
        Set-Location ..
        Write-Host "✅ Frontend kutubxonalarni o'rnatildi" -ForegroundColor Green
    } else {
        Write-Host "✅ Frontend kutubxonalarni o'rnatilgan" -ForegroundColor Green
    }
} else {
    Write-Host "❌ frontend/package.json topilmadi!" -ForegroundColor Red
    exit 1
}

# 6. Database migration va seed
Write-Host "`n[6/6] Database sozlanmoqda..." -ForegroundColor Yellow

Set-Location backend

# Migration tekshirish
Write-Host "Database migration tekshirilmoqda..." -ForegroundColor Cyan
try {
    npx prisma migrate deploy 2>&1 | Out-Null
    Write-Host "✅ Database migration qilindi" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Migration muammo, davom etilmoqda..." -ForegroundColor Yellow
}

# Prisma generate
Write-Host "Prisma client generate qilinmoqda..." -ForegroundColor Cyan
npx prisma generate 2>&1 | Out-Null

# Admin account yaratish
Write-Host "Admin account yaratilmoqda..." -ForegroundColor Cyan
try {
    npx ts-node -r tsconfig-paths/register prisma/seed.ts 2>&1 | Out-Null
    Write-Host "✅ Admin account yaratildi" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Admin account yaratishda muammo" -ForegroundColor Yellow
}

Set-Location ..

# Yakuniy xabar
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🎉 Lokal Server Tayyor!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "📊 Xizmatlar:" -ForegroundColor Yellow
Write-Host "  • PostgreSQL: localhost:5432" -ForegroundColor White
Write-Host "  • Redis:      localhost:6379" -ForegroundColor White
Write-Host "  • Backend:    http://localhost:3001" -ForegroundColor White
Write-Host "  • Frontend:   http://localhost:3000" -ForegroundColor White

Write-Host "`n👤 Admin Login:" -ForegroundColor Yellow
Write-Host "  • Email:    admin@vfsbot.local" -ForegroundColor White
Write-Host "  • Password: admin1234" -ForegroundColor White

Write-Host "`n🚀 Backend va Frontend ishga tushirish:" -ForegroundColor Yellow
Write-Host "`nBackend uchun (yangi terminal):" -ForegroundColor White
Write-Host "  cd backend" -ForegroundColor Gray
Write-Host "  npm run dev" -ForegroundColor Gray

Write-Host "`nFrontend uchun (yangi terminal):" -ForegroundColor White
Write-Host "  cd frontend" -ForegroundColor Gray
Write-Host "  npm run dev" -ForegroundColor Gray

Write-Host "`n✅ Tayyor! Endi ikkita yangi terminal ochib, yuqoridagi buyruqlarni bajaring`n" -ForegroundColor Green
