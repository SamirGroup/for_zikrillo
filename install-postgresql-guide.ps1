# PostgreSQL Quick Install Guide for Windows
# Agar PostgreSQL o'rnatilmagan bo'lsa, bu qo'llanmani o'qing

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "📦 PostgreSQL Quick Install" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "PostgreSQL o'rnatishning 3 ta usuli:" -ForegroundColor Yellow
Write-Host "`n1. PostgreSQL Official Installer (Tavsiya etiladi)" -ForegroundColor White
Write-Host "   https://www.postgresql.org/download/windows/" -ForegroundColor Cyan
Write-Host "   - PostgreSQL 16.x yuklab oling" -ForegroundColor Gray
Write-Host "   - O'rnating va password: vfspass belgilang" -ForegroundColor Gray
Write-Host "   - Port: 5432" -ForegroundColor Gray

Write-Host "`n2. Chocolatey (Agar o'rnatilgan bo'lsa)" -ForegroundColor White
Write-Host "   choco install postgresql16 --args 'PASSWORD=vfspass'" -ForegroundColor Cyan

Write-Host "`n3. Winget (Windows Package Manager)" -ForegroundColor White
Write-Host "   winget install PostgreSQL.PostgreSQL.16" -ForegroundColor Cyan

Write-Host "`nO'rnatishdan keyin quyidagi buyruqlarni bajaring:" -ForegroundColor Yellow
Write-Host "1. PostgreSQL ishga tushganligini tekshiring:" -ForegroundColor White
Write-Host "   services.msc" -ForegroundColor Cyan
Write-Host "   va 'postgresql-x64-16' xizmati 'Running' bo'lishi kerak" -ForegroundColor Gray

Write-Host "`n2. Database va User yaratish:" -ForegroundColor White
Write-Host "   cd `"C:\Program Files\PostgreSQL\16\bin`"" -ForegroundColor Cyan
Write-Host "   .\psql.exe -U postgres" -ForegroundColor Cyan

Write-Host "`nPostgreSQL prompt'da:" -ForegroundColor White
Write-Host "   CREATE DATABASE vfsdb;" -ForegroundColor Gray
Write-Host "   CREATE USER vfsuser WITH PASSWORD 'vfspass';" -ForegroundColor Gray
Write-Host "   GRANT ALL PRIVILEGES ON DATABASE vfsdb TO vfsuser;" -ForegroundColor Gray
Write-Host "   \q" -ForegroundColor Gray

Write-Host "`n3. .env faylni tekshiring - DATABASE_URL to'g'ri bo'lishi kerak:" -ForegroundColor White
Write-Host "   DATABASE_URL=postgresql://vfsuser:vfspass@localhost:5432/vfsdb?schema=public" -ForegroundColor Cyan

Write-Host "`n✅ Tayyor! Keyin ./start-local.ps1 ni ishga tushiring`n" -ForegroundColor Green
