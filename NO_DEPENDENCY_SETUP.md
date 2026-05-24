# VFS Booking Bot - No-Dependency Local Setup
# Docker, PostgreSQL, Redis'siz to'liq lokal ishlaydigan versiya

## 🎯 Nima O'zgardi?

### Database: PostgreSQL → **SQLite**
- ✅ Hech narsa o'rnatish shart emas
- ✅ Bitta fayl (database.db)
- ✅ Prisma bilan to'liq mos

### Cache: Redis → **In-Memory**
- ✅ Hech narsa o'rnatish shart emas
- ✅ JavaScript Map ishlatiladi
- ✅ Development uchun ideal

### Job Queue: BullMQ → **Simple In-Memory Queue**
- ✅ Redis'siz ishlaydi
- ✅ Async/await pattern
- ✅ Development uchun yetarli

---

## 📦 O'rnatish (Juda Oson!)

### 1-Qadam: Kutubxonalarni O'rnatish

```powershell
# Backend
cd backend
npm install

# Frontend  
cd frontend
npm install
```

### 2-Qadam: .env Faylni Yangilash

`.env` fayl avtomatik yaratiladi yoki quyidagicha qo'lda o'zgartiring:

```env
# ─── Server ───────────────────────────────────────────────────────────────────
NODE_ENV=development
PORT=3001
FRONTEND_URL=http://localhost:3000

# ─── Database (SQLite - Hech narsa o'rnatish shart emas!) ─────────────────────
DATABASE_URL=file:./dev.db

# ─── No Redis Required! ───────────────────────────────────────────────────────
# In-memory cache ishlatiladi

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
```

### 3-Qadam: Prisma Schema O'zgartirish

`backend/prisma/schema.prisma` fayl avtomatik yangilanadi.

### 4-Qadam: Database Migration

```powershell
cd backend
npx prisma migrate dev --name init
```

### 5-Qadam: Admin Account Yaratish

```powershell
cd backend
npx ts-node -r tsconfig-paths/register prisma/seed.ts
```

### 6-Qadam: Server Ishga Tushirish

```powershell
# Backend
cd backend
npm run dev

# Frontend (yangi terminal)
cd frontend
npm run dev
```

---

## 🎉 Tayyor!

- **Backend**: http://localhost:3001
- **Frontend**: http://localhost:3000
- **Admin**: admin@vfsbot.local / admin1234

Hech qanday PostgreSQL, Redis, Docker kerak emas!

---

## 📊 Nimalar Ishlaydi?

✅ Barcha API endpoints  
✅ User authentication (JWT)  
✅ Profile management (encrypted)  
✅ Booking system  
✅ Monitor service  
✅ WebSocket real-time updates  
✅ Telegram bot (agar token sozlangan bo'lsa)  
✅ Email notifications (agar SMTP sozlangan bo'lsa)  
✅ Logging system  

---

## ⚠️ Cheklovlar

**Development versiyasi**, quyidagi cheklovlar bor:

1. **In-Memory Cache**: Server qayta ishga tushganda cache tozalanadi
2. **Single-User**: Faqat bitta kompyuterda ishlatish uchun
3. **No Background Jobs**: BullMQ'siz, job'lar in-memory ishlaydi

**Production uchun** PostgreSQL + Redis + Docker ishlatish tavsiya etiladi.

---

## 🚀 Qo'shimcha Buyruqlar

### Database Ko'rish (Prisma Studio):
```powershell
cd backend
npx prisma studio
```

### Database Reset:
```powershell
cd backend
npx prisma migrate reset
```

### Live Logs:
```powershell
# Backend terminalida avtomatik ko'rinadi
```

---

## 🎓 O'rganish Uchun

Loyihani o'rganish, test qilish va development qilish uchun **ideal**!

Hech qanday murakkab konfiguratsiya yo'q - faqat `npm install` va `npm run dev`!

Omad! 🚀
