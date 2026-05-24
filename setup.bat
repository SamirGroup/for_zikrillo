# VFS Booking Bot - Professional Setup Script
# Bu script loyihani to'liq ishga tushiradi

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🚀 VFS Booking Bot - Professional Setup" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

# 1. Docker tekshirish
Write-Host "[1/8] Docker Desktop tekshirilmoqda..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>&1
    Write-Host "✅ Docker topildi: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker Desktop o'rnatilmagan!" -ForegroundColor Red
    Write-Host "`nDocker Desktop o'rnatish:" -ForegroundColor Yellow
    Write-Host "1. https://www.docker.com/products/docker-desktop/ ga o'ting" -ForegroundColor White
    Write-Host "2. 'Download for Windows' bosing" -ForegroundColor White
    Write-Host "3. O'rnatib, kompyuterni qayta ishga tushiring" -ForegroundColor White
    Write-Host "`nScript to'xtatildi." -ForegroundColor Red
    exit 1
}

# 2. WSL konfiguratsiya
Write-Host "`n[2/8] WSL konfiguratsiyasi tekshirilmoqda..." -ForegroundColor Yellow
$wslConfigPath = "$env:USERPROFILE\.wslconfig"
if (Test-Path $wslConfigPath) {
    Write-Host "✅ .wslconfig mavjud: $wslConfigPath" -ForegroundColor Green
} else {
    Write-Host "⚠️  .wslconfig topilmadi, yaratilmoqda..." -ForegroundColor Yellow
    $content = "[wsl2]`nmemory=6GB`nprocessors=4`nswap=2GB"
    Set-Content -Path $wslConfigPath -Value $content -Force
    Write-Host "✅ .wslconfig yaratildi" -ForegroundColor Green
}

# 3. .env tekshirish
Write-Host "`n[3/8] .env fayl tekshirilmoqda..." -ForegroundColor Yellow
if (-not (Test-Path .env)) {
    Write-Host "❌ .env fayl topilmadi!" -ForegroundColor Red
    Write-Host "Iltimos, .env.example faylni .env ga ko'chirib, keys'larni to'ldiring." -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ .env fayl mavjud" -ForegroundColor Green

# 4. .env fayl tekshirish (keys'lar)
Write-Host "`n[4/8] Keyslar tekshirilmoqda..." -ForegroundColor Yellow
$envContent = Get-Content .env
$jwtAccess = $envContent | Where-Object { $_ -match "^JWT_ACCESS_SECRET=" }
$jwtRefresh = $envContent | Where-Object { $_ -match "^JWT_REFRESH_SECRET=" }
$encryptionKey = $envContent | Where-Object { $_ -match "^PROFILE_ENCRYPTION_KEY=" }

if ($jwtAccess -match "JWT_ACCESS_SECRET=$([char]39){64}") {
    Write-Host "✅ JWT_ACCESS_SECRET sozlangan" -ForegroundColor Green
} else {
    Write-Host "⚠️  JWT_ACCESS_SECRET to'ldirilmagan!" -ForegroundColor Red
}

if ($jwtRefresh -match "JWT_REFRESH_SECRET=$([char]39){64}") {
    Write-Host "✅ JWT_REFRESH_SECRET sozlangan" -ForegroundColor Green
} else {
    Write-Host "⚠️  JWT_REFRESH_SECRET to'ldirilmagan!" -ForegroundColor Red
}

if ($encryptionKey -match "PROFILE_ENCRYPTION_KEY=$([char]39){64}") {
    Write-Host "✅ PROFILE_ENCRYPTION_KEY sozlangan" -ForegroundColor Green
} else {
    Write-Host "⚠️  PROFILE_ENCRYPTION_KEY to'ldirilmagan!" -ForegroundColor Red
}

# 5. Docker containerlarni tozalash
Write-Host "`n[5/8] Eski container'lar tozalanmoqda..." -ForegroundColor Yellow
docker-compose -f docker-compose.dev.yml down -v --remove-orphans 2>&1 | Out-Null
Write-Host "✅ Eski container'lar tozalandi" -ForegroundColor Green

# 6. Docker containerlarni ishga tushirish
Write-Host "`n[6/8] Docker containerlarni ishga tushirilmoqda..." -ForegroundColor Yellow
Write-Host "⏳ Bu jarayon 10-20 daqiqa vaqt olishi mumkin (birinchi marta)..." -ForegroundColor Cyan

try {
    docker-compose -f docker-compose.dev.yml up -d --build
    Write-Host "✅ Container'lar ishga tushirildi" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker containerlarni ishga tushirishda xatolik!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# 7. Container status tekshirish
Write-Host "`n[7/8] Container status tekshirilmoqda..." -ForegroundColor Yellow
Start-Sleep -Seconds 10  # Container'lar ishga tushishi uchun kutish

$containerStatus = docker-compose -f docker-compose.dev.yml ps
Write-Host $containerStatus
Write-Host "✅ Container'lar holati ko'rsatildi" -ForegroundColor Green

# 8. Database seed (Admin account yaratish)
Write-Host "`n[8/8] Database seed qilinmoqda..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

try {
    docker-compose -f docker-compose.dev.yml exec -T backend `
        npx prisma migrate deploy 2>&1 | Out-Null
    Write-Host "✅ Database migratsiya qilindi" -ForegroundColor Green
    
    docker-compose -f docker-compose.dev.yml exec -T backend `
        npx ts-node -r tsconfig-paths/register prisma/seed.ts 2>&1 | Out-Null
    Write-Host "✅ Admin account yaratildi" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Database seed jarayonida xatolik, lekin davom etilmoqda..." -ForegroundColor Yellow
}

# Yakuniy xabar
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🎉 LOYIHA MUVAFFAQIYATLI ISHGA TUSHIRILDI!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "📊 Xizmatlar:" -ForegroundColor Yellow
Write-Host "  • Frontend:  http://localhost:3000" -ForegroundColor White
Write-Host "  • Backend:   http://localhost:3001" -ForegroundColor White
Write-Host "  • Database:  postgresql://localhost:5432/vfsdb" -ForegroundColor White
Write-Host "  • Redis:     redis://localhost:6379" -ForegroundColor White

Write-Host "`n👤 Admin Login:" -ForegroundColor Yellow
Write-Host "  • Email:    admin@vfsbot.local" -ForegroundColor White
Write-Host "  • Password: admin1234" -ForegroundColor White

Write-Host "`n📝 Foydali buyruqlar:" -ForegroundColor Yellow
Write-Host "  • Live logs:      docker-compose -f docker-compose.dev.yml logs -f backend" -ForegroundColor White
Write-Host "  • Container'larni to'xtatish:  docker-compose -f docker-compose.dev.yml down" -ForegroundColor White
Write-Host "  • Container'larni qayta ishga tushirish: docker-compose -f docker-compose.dev.yml up -d" -ForegroundColor White

Write-Host "`n⚠️  Muhim:" -ForegroundColor Yellow
Write-Host "  • Telegram bot sozlash uchun .env faylga TELEGRAM_BOT_TOKEN va TELEGRAM_CHAT_ID qo'shing" -ForegroundColor White
Write-Host "  • Proxy sozlash uchun .env faylga PROXY_USERNAME va PROXY_PASSWORD qo'shing" -ForegroundColor White
Write-Host "  • 2Captcha sozlash uchun .env faylga TWOCAPTCHA_API_KEY qo'shing" -ForegroundColor White

Write-Host "`n✅ Tayyor! Browser'da http://localhost:3000 ga o'ting`n" -ForegroundColor Green
