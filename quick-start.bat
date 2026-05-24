# VFS Booking Bot - Quick Start
# Docker Desktop o'rnatilgandan keyin shu faylni ishga tushiring

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🚀 Quick Start - VFS Booking Bot" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Docker containerlarni ishga tushirayapman..." -ForegroundColor Yellow
docker-compose -f docker-compose.dev.yml up -d --build

Write-Host "`nContainer'larni tekshirayapman..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

docker-compose -f docker-compose.dev.yml ps

Write-Host "`nDatabase migratsiya qilayapman..." -ForegroundColor Yellow
docker-compose -f docker-compose.dev.yml exec -T backend npx prisma migrate deploy

Write-Host "`nAdmin account yaratayapman..." -ForegroundColor Yellow
docker-compose -f docker-compose.dev.yml exec -T backend npx ts-node -r tsconfig-paths/register prisma/seed.ts

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🎉 Tayyor!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:3000" -ForegroundColor Yellow
Write-Host "Admin: admin@vfsbot.local / admin1234" -ForegroundColor Yellow
Write-Host "`nLive logs ko'rish uchun:" -ForegroundColor Yellow
Write-Host "  docker-compose -f docker-compose.dev.yml logs -f backend`n" -ForegroundColor White
