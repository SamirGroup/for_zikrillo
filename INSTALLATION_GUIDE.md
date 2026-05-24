# 🚀 VFS Booking Bot - To'liq O'rnatish Qo'llanmasi

> **Professional darajada o'rnatish uchun har bir qadamni diqqat bilan bajaring**

---

## 📋 Kerakli Dasturlar

### 1. **Git** ✅ (O'rnatilgan)
```powershell
git --version  # v2.52.0.windows.1
```

### 2. **Node.js** ✅ (O'rnatilgan)
```powershell
node --version  # v22.22.3
```

### 3. **Docker Desktop** ⚠️ (O'rnatish kerak)
- **Yuklab olish**: https://www.docker.com/products/docker-desktop/
- **O'rnatish**:
  1. Yuklab olingan `.exe` faylni ishga tushiring
  2. "Use WSL 2 instead of Hyper-V" ni tanlang
  3. O'rnatish tugagach, kompyuterni **qayta ishga tushiring**

---

## 📝 Qadam-ba-Qadam O'rnatish

### 1-Qadam: WSL Memory Konfiguratsiya

✅ **Amalga oshirildi!** `.wslconfig` fayl yaratildi:
```ini
[wsl2]
memory=6GB
processors=4
swap=2GB
```

**Fayl joylashuvi**: `C:\Users\User\.wslconfig`

### 2-Qadam: Docker Desktop O'rnatish

1. **Yuklab olish**:
   - https://www.docker.com/products/docker-desktop/
   - "Download for Windows" tugmasini bosing

2. **O'rnatish**:
   - Yuklab olingan `Docker Desktop Installer.exe` faylni ishga tushiring
   - O'rnatish jarayonida "Use WSL 2 instead of Hyper-V" ni tanlang
   - O'rnatish tugagach, kompyuterni **qayta ishga tushiring**

3. **Docker Desktop ishga tushirish**:
   - Start menyudan "Docker Desktop" ni qidiring va ishga tushiring
   - Treydagi (o'ng pastki burchak) soat belgisiga bosing
   - Docker daemon ishga tushishini kuting (soat belgisi barqaror bo'lishi kerak)

4. **Tekshirish**:
   ```powershell
   docker --version
   docker info
   ```

### 3-Qadam: Docker Desktop Restart

Docker Desktop o'rnatilgandan keyin:
```powershell
wsl --shutdown
```

Keyin Docker Desktop ni qayta oching va daemon ishga tushishini kuting.

### 4-Qadam: Loynihani Ishga Tushirish

#### Variant A: Professional Script (Tavsiya etiladi)

```powershell
.\setup.bat
```

Bu script barcha jarayonlarni avtomatik bajaradi:
- Docker tekshiruvi
- Container'larni ishga tushirish
- Database migratsiya
- Admin account yaratish

#### Variant B: Quick Start

```powershell
.\quick-start.bat
```

#### Variant C: Qo'lda Ishga Tushirish

```powershell
# 1. Container'larni ishga tushirish
docker-compose -f docker-compose.dev.yml up -d --build

# 2. Status tekshirish
docker-compose -f docker-compose.dev.yml ps

# 3. Database migratsiya
docker-compose -f docker-compose.dev.yml exec -T backend npx prisma migrate deploy

# 4. Admin account yaratish
docker-compose -f docker-compose.dev.yml exec -T backend npx ts-node -r tsconfig-paths/register prisma/seed.ts
```

### 5-Qadam: Tekshirish

#### Container'lar statusi:
```powershell
docker-compose -f docker-compose.dev.yml ps
```

**Kutilayotgan natija**:
```
NAME                        STATUS
vfsbookingbot-postgres-1    Up (healthy)
vfsbookingbot-redis-1       Up
vfsbookingbot-backend-1     Up
vfsbookingbot-frontend-1    Up
```

#### Live logs:
```powershell
docker-compose -f docker-compose.dev.yml logs -f backend
```

#### Browser'da tekshirish:
- **Frontend**: http://localhost:3000
- **Backend Health**: http://localhost:3001/api/health

### 6-Qadam: Admin Accountga Kirish

**Login ma'lumotlari**:
- **Email**: `admin@vfsbot.local`
- **Password**: `admin1234`

---

## 🔑 Generated Keys (Saqlab Qo'ying!)

`.env` fayl yaratildi va quyidagi keys'lar generatsiya qilindi:

### JWT Keys'lar:
```
JWT_ACCESS_SECRET=6abd5f2beb0fe212d9fe2cd8ea2a47bb200068039537a007eb73aa4b0d12033bc8c14000fb1cd95b59138f7b96524d76c98346632196b0b16cb27a7462e500b2
JWT_REFRESH_SECRET=30b1006e78be18928ca7d53b008129385afe86971369eb4a451510b9ec80835dd163da5c5fb38086fde34633a2ec9078332e755483540a07e59dde5ae7d1db18
```

### Encryption Key:
```
PROFILE_ENCRYPTION_KEY=b3e6d0d174b79e0a1fd6772b40701f78b282a10421710e39262be849a4a4172a
```

**Bu keys'lar `generated_keys.txt` faylida saqlangan!**

---

## 📦 Kutubxonalarni O'rnatish

### Backend Kutubxonalari (Auto-install)

Backend Docker container ichida avtomatik o'rnatiladi. Lekin lokal o'rganish uchun:

```powershell
cd backend
npm install
```

**Asosiy kutubxonalar**:
- `express` - REST API framework
- `prisma` - Database ORM
- `playwright` - Browser automation
- `bullmq` - Job queue (Redis)
- `socket.io` - WebSocket real-time
- `winston` - Logging
- `zod` - Validation
- `bcryptjs` - Password hashing
- `jsonwebtoken` - JWT auth
- `telegraf` - Telegram bot
- `helmet` - Security headers
- `playwright-extra` + `puppeteer-extra-plugin-stealth` - Anti-detection

### Frontend Kutubxonalari (Auto-install)

Frontend Docker container ichida avtomatik o'rnatiladi. Lokalda:

```powershell
cd frontend
npm install
```

**Asosiy kutubxonalar**:
- `next` - React framework (App Router)
- `react` - UI library
- `zustand` - State management
- `react-hook-form` - Form handling
- `socket.io-client` - WebSocket client
- `axios` - HTTP client
- `zod` - Validation
- `framer-motion` - Animations
- `tailwindcss` - Styling
- `date-fns` - Date formatting
- `lucide-react` - Icons

---

## 🔧 Sozlamalar (Optional)

### 1. Telegram Bot Sozlash

**1. Bot yaratish**:
- Telegram'da `@BotFather` ga o'ting
- `/newbot` buyrug'ini yuboring
- Bot nomini tanlang (masalan: `VFS Monitor Bot`)
- Bot token olasiz (masalan: `1234567890:ABCdefGHI...`)

**2. Chat ID olish**:
- Telegram'da yangi bot bilan `/start` yuboring
- Browser'da oching: `https://api.telegram.org/bot<BOT_TOKEN>/getUpdates`
- Response'da `"chat":{"id":XXXXXXXX}` qismini toping

**3. .env faylga qo'shish**:
```env
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHI...
TELEGRAM_CHAT_ID=123456789
```

### 2. Proxy Sozlash (Proxyrack)

**1. Proxyrack account yaratish**:
- https://proxyrack.com ga o'ting
- Residential Proxies plan sotib oling
- Dashboard'dan username va password olasiz

**2. .env faylga qo'shish**:
```env
PROXY_HOST=premium.residential.proxyrack.net
PROXY_PORT=10000
PROXY_USERNAME=your_username
PROXY_PASSWORD=your_password
```

### 3. 2Captcha Sozlash (Optional)

**1. 2Captcha account yaratish**:
- https://2captcha.com ga oting
- Balance qo'shing ($5-10)
- API Key olasiz

**2. .env faylga qo'shish**:
```env
TWOCAPTCHA_API_KEY=your_api_key
CAPTCHA_SOLVER=twocaptcha
```

Agar 2Captcha sozlamasangiz, `CAPTCHA_SOLVER=manual` qoldiring.

---

## 📊 Foydalanish

### Container'larni Boshqarish

```powershell
# Ishga tushirish
docker-compose -f docker-compose.dev.yml up -d

# To'xtatish
docker-compose -f docker-compose.dev.yml down

# Qayta ishga tushirish
docker-compose -f docker-compose.dev.yml restart

# To'liq tozalash (barcha ma'lumotlar o'chiriladi)
docker-compose -f docker-compose.dev.yml down -v
```

### Logs Ko'rish

```powershell
# Backend logs
docker-compose -f docker-compose.dev.yml logs -f backend

# Frontend logs
docker-compose -f docker-compose.dev.yml logs -f frontend

# Barcha logs
docker-compose -f docker-compose.dev.yml logs -f

# Last 100 lines
docker-compose -f docker-compose.dev.yml logs --tail=100 backend
```

### Database Boshqarish

```powershell
# Prisma Studio (GUI)
docker-compose -f docker-compose.dev.yml exec backend npx prisma studio

# PostgreSQL shell
docker-compose -f docker-compose.dev.yml exec postgres psql -U vfsuser -d vfsdb
```

### Admin Account Qayta Yaratish

Agar database reset qilingan bo'lsa:
```powershell
docker-compose -f docker-compose.dev.yml exec -T backend npx ts-node -r tsconfig-paths/register prisma/seed.ts
```

---

## 🐛 Muammolarni Hal Qilish

### 1. "Invalid Credentials" Login Sahifasida

**Sabab**: Admin account database'da yo'q

**Yechim**:
```powershell
docker-compose -f docker-compose.dev.yml exec -T backend npx ts-node -r tsconfig-paths/register prisma/seed.ts
```

### 2. "Network Error" yoki "Failed to fetch"

**Sabab**: Backend container ishga tushmagan

**Yechim**:
```powershell
# Container'lar statusini tekshiring
docker-compose -f docker-compose.dev.yml ps

# Agar backend down bo'lsa, qayta ishga tushiring
docker-compose -f docker-compose.dev.yml up -d backend

# Logs ko'ring
docker-compose -f docker-compose.dev.yml logs backend
```

### 3. Docker "WSL 2 backend error"

**Sabab**: WSL 2 to'g'ri konfiguratsiya qilinmagan

**Yechim**:
```powershell
# WSL ni to'liq o'chirib yoqish
wsl --shutdown
# Docker Desktop ni qayta oching
```

### 4. "Page crashed" yoki Memory error

**Sabab**: WSL 2 memory yetarli emas

**Yechim**:
- `.wslconfig` faylni tekshiring (memory=6GB bo'lishi kerak)
- `wsl --shutdown` qiling
- Docker Desktop ni qayta oching

### 5. "403 Forbidden" yoki "IP Blocked"

**Sabab**: Proxy sozlanmagan yoki VFS IP block qilgan

**Yechim**:
- `.env` faylga Proxy ma'lumotlarini qo'shing
- Monitoring intervalni oshiring (30s → 60s)
- `.env` faylda `MONITOR_DEFAULT_INTERVAL_MS=60000` qiling

---

## 📚 Fayl Tuzilishi

```
vfs-booking-bot/
├── backend/                     # Node.js API Server
│   ├── src/
│   │   ├── app.ts              # Express app
│   │   ├── index.ts            # Entry point
│   │   ├── config/             # Database, Redis, env
│   │   ├── middleware/         # Auth, rate limit
│   │   └── modules/            # Business logic
│   ├── prisma/
│   │   ├── schema.prisma       # Database schema
│   │   └── seed.ts             # Admin account seeder
│   └── package.json
│
├── frontend/                    # Next.js Dashboard
│   ├── src/
│   │   ├── app/                # Pages (App Router)
│   │   ├── components/         # UI components
│   │   └── lib/                # Utilities, API client
│   └── package.json
│
├── docker-compose.dev.yml      # Docker configuration
├── .env                        # Environment variables
├── setup.bat                   # Professional setup script
├── quick-start.bat             # Quick start script
└── INSTALLATION_GUIDE.md       # Bu fayl
```

---

## ✅ Tekshirish Ro'yxati

O'rnatish tugagandan keyin:

- [ ] Docker Desktop ishlayapti (trey'da soat belgisi barqaror)
- [ ] `docker ps` 4 ta container ko'rsatadi (postgres, redis, backend, frontend)
- [ ] http://localhost:3000 ochiladi
- [ ] Admin account bilan kirish mumkin (admin@vfsbot.local / admin1234)
- [ ] Live logs ko'rinadi (backend container logs)
- [ ] Database connection ishlaydi (Prisma Studio ochiladi)

---

## 🎯 Keyingi Qadamlar

1. **Dashboard ochish**: http://localhost:3000
2. **Admin accountga kirish**: admin@vfsbot.local / admin1234
3. **Telegram bot sozlash** (ixtiyoriy)
4. **Proxy sozlash** (ixtiyoriy)
5. **Birinchi applicant qo'shish**
6. **Monitoring boshlash**

---

## 📞 Yordam

Agar muammo yuzaga kelsa:
1. `docker-compose -f docker-compose.dev.yml logs backend` ni tekshiring
2. Docker Desktop statusini tekshiring
3. WSL memory konfiguratsiyasini tekshiring
4. `.env` fayl to'g'ri to'ldirilganligini tekshiring

**Muvaffaqiyat!** 🎉
