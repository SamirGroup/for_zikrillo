# VFS Booking Bot - Run Local Server
# Backend va Frontend ni bir vaqtda ishga tushirish

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🚀 Run Local Server" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

# 1. Backend ishga tushirish
Write-Host "Backend ishga tushirilmoqda..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\backend'; Write-Host 'Backend server ishlayapti: http://localhost:3001' -ForegroundColor Green; npm run dev"

# 20 soniya kutish (backend ishga tushishi uchun)
Start-Sleep -Seconds 20

# 2. Frontend ishga tushirish
Write-Host "`nFrontend ishga tushirilmoqda..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\frontend'; Write-Host 'Frontend server ishlayapti: http://localhost:3000' -ForegroundColor Green; npm run dev"

# 20 soniya kutish
Start-Sleep -Seconds 20

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "✅ Ikkala server ishga tushdi!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Frontend: http://localhost:3000" -ForegroundColor Yellow
Write-Host "Backend:  http://localhost:3001" -ForegroundColor Yellow

Write-Host "`n⚠️  Eslatma:" -ForegroundColor Yellow
Write-Host "  • Backend terminalini yopmang" -ForegroundColor White
Write-Host "  • Frontend terminalini yopmang" -ForegroundColor White
Write-Host "  • Serverlarni to'xtatish uchun terminal'da Ctrl+C bosing" -ForegroundColor White

Write-Host "`n✅ Tayyor! Browser'da http://localhost:3000 ga o'ting`n" -ForegroundColor Green
