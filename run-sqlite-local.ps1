# VFS Booking Bot - Run SQLite Local Server
# Backend va Frontend ni bir vaqtda ishga tushirish

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🚀 Run SQLite Local Server" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Serverlarni ishga tushirayapman..." -ForegroundColor Yellow

# 1. Backend ishga tushirish
Write-Host "`nBackend ishga tushirilmoqda (http://localhost:3001)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\backend'; Write-Host '========================================' -ForegroundColor Cyan; Write-Host '🚀 Backend Server' -ForegroundColor Green; Write-Host '========================================' -ForegroundColor Cyan; Write-Host 'URL: http://localhost:3001' -ForegroundColor Yellow; Write-Host 'Admin: admin@vfsbot.local / admin1234' -ForegroundColor Yellow; Write-Host '========================================' -ForegroundColor Cyan; Write-Host 'Terminalni yopmang!' -ForegroundColor Red; npm run dev"

# 15 soniya kutish
Start-Sleep -Seconds 15

# 2. Frontend ishga tushirish
Write-Host "`nFrontend ishga tushirilmoqda (http://localhost:3000)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\frontend'; Write-Host '========================================' -ForegroundColor Cyan; Write-Host "🚀 Frontend Server" -ForegroundColor Green; Write-Host '========================================' -ForegroundColor Cyan; Write-Host 'URL: http://localhost:3000' -ForegroundColor Yellow; Write-Host 'Admin: admin@vfsbot.local / admin1234' -ForegroundColor Yellow; Write-Host '========================================' -ForegroundColor Cyan; Write-Host 'Terminalni yopmang!' -ForegroundColor Red; npm run dev"

# 10 soniya kutish
Start-Sleep -Seconds 10

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "✅ Ikkala server ishga tushdi!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "📊 Serverlar:" -ForegroundColor Yellow
Write-Host "  • Frontend:  http://localhost:3000" -ForegroundColor White
Write-Host "  • Backend:   http://localhost:3001" -ForegroundColor White
Write-Host "  • Database:  database.db (SQLite)" -ForegroundColor White

Write-Host "`n👤 Admin Login:" -ForegroundColor Yellow
Write-Host "  • Email:    admin@vfsbot.local" -ForegroundColor White
Write-Host "  • Password: admin1234" -ForegroundColor White

Write-Host "`n📝 Foydali buyruqlar:" -ForegroundColor Yellow
Write-Host "  • Database ko'rish: cd backend && npx prisma studio" -ForegroundColor White
Write-Host "  • Serverlarni to'xtatish: Terminal'da Ctrl+C bosing" -ForegroundColor White

Write-Host "`n✅ Tayyor! Browser'da http://localhost:3000 ga o'ting`n" -ForegroundColor Green
