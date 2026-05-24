# PostgreSQL + Redis Local Setup Guide (Windows)

## PostgreSQL O'rnatish

### Variant 1: PostgreSQL Official Installer (Tavsiya etiladi)

1. **Yuklab olish**:
   - https://www.postgresql.org/download/windows/
   - "Download for Windows" bosing
   - PostgreSQL 16.x versiyasini yuklab oling

2. **O'rnatish**:
   - Yuklab olingan `.exe` faylni ishga tushiring
   - O'rnatish jarayonida quyidagi ma'lumotlarni yozib oling:
     - **Port**: 5432 (default)
     - **Superuser password**: `vfspass` (yoki o'zingiz tanlangan parol)
     - **Database name**: `vfsdb`

3. **PostgreSQL tekshirish**:
   ```powershell
   # Command prompt oching
   cd "C:\Program Files\PostgreSQL\16\bin"
   .\psql.exe -U postgres -d postgres
   ```
   
   **Password so'ralganda**: O'rnatishda belgilagan parolingizni kiriting

4. **VFS uchun database yaratish**:
   ```sql
   -- PostgreSQL'da:
   CREATE DATABASE vfsdb;
   CREATE USER vfsuser WITH PASSWORD 'vfspass';
   GRANT ALL PRIVILEGES ON DATABASE vfsdb TO vfsuser;
   \q
   ```

### Variant 2: XAMPP (PostgreSQL + boshqalar)

1. https://www.apachefriends.org/download.html
2. XAMPP yuklab oling (PostgreSQL bilan)
3. O'rnating va XAMPP Control Panel'da PostgreSQL ni ishga tushiring

---

## Redis O'rnatish

### Variant 1: Redis for Windows (Microsoft)

1. **GitHub'dan yuklab olish**:
   - https://github.com/microsoftarchive/redis/releases
   - `redis-x64-3.0.504.zip` yuklab oling

2. **Extract qilish**:
   ```powershell
   # Masalan: C:\redis papkasiga extract qiling
   ```

3. **Redis ishga tushirish**:
   ```powershell
   cd C:\redis
   redis-server.exe
   ```

4. **Redis CLI tekshirish**:
   ```powershell
   redis-cli.exe ping
   # "PONG" javobini ko'rasiz
   ```

### Variant 2: Windows Subsystem for Linux (WSL)

Agar WSL o'rnatilgan bo'lsa:
```bash
sudo apt update
sudo apt install redis-server
sudo systemctl start redis-server
```

### Variant 3: Docker Redis (faqat Redis uchun)

Agar faqat Redis uchun Docker ishlatmoqchi bo'lsangiz:
```powershell
docker run -d -p 6379:6379 --name local-redis redis:7-alpine
```

---

## Environment Variables Sozlash

`.env` faylni quyidagicha o'zgartiring:

```env
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
```

---

## Backend Kutubxonalarni O'rnatish

```powershell
# Backend papkasiga o'ting
cd backend

# Kutubxonalarni o'rnatish
npm install

# Prisma client generate qilish
npx prisma generate
```

## Frontend Kutubxonalarni O'rnatish

```powershell
# Frontend papkasiga o'ting
cd frontend

# Kutubxonalarni o'rnatish
npm install
```

---

## Database Migration

```powershell
# Backend papkasida:
cd backend

# Prisma migration run qilish
npx prisma migrate dev --name init

# Agar migration muammo bo'lsa:
npx prisma migrate deploy
```

## Admin Account Yaratish

```powershell
# Backend papkasida:
cd backend

# Seed run qilish
npx ts-node -r tsconfig-paths/register prisma/seed.ts
```

---

## Backend Ishga Tushirish

### Variant 1: Development Mode (Hot Reload)

```powershell
cd backend
npm run dev
```

Backend http://localhost:3001 da ishlaydi

### Variant 2: Production Build

```powershell
cd backend
npm run build
npm start
```

---

## Frontend Ishga Tushirish

```powershell
cd frontend
npm run dev
```

Frontend http://localhost:3000 da ishlaydi

---

## Barcha Xizmatlarni Birgalikda Ishga Tushirish

### Variant 1: PowerShell Script

```powershell
# start-local.ps1 faylini yaratib, ishga tushiring
.\start-local.ps1
```

### Variant 2: Turli Terminal'lar

1. **Terminal 1** (Backend):
   ```powershell
   cd backend
   npm run dev
   ```

2. **Terminal 2** (Frontend):
   ```powershell
   cd frontend
   npm run dev
   ```

---

## Tekshirish

### 1. PostgreSQL Connection:
```powershell
cd "C:\Program Files\PostgreSQL\16\bin"
.\psql.exe -U vfsuser -d vfsdb -h localhost
```

### 2. Redis Connection:
```powershell
cd C:\redis
redis-cli.exe ping
```

### 3. Backend Health:
Browser'da: http://localhost:3001/api/health

### 4. Frontend:
Browser'da: http://localhost:3000

---

## Muammolarni Hal Qilish

### PostgreSQL Connection Error
- PostgreSQL xizmati ishlayapti-yo'qligini tekshiring
- Firewall'da 5432 port ochiq ekanligini tekshiring
- `.env` faylda DATABASE_URL to'g'ri ekanligini tekshiring

### Redis Connection Error
- Redis server ishlayapti-yo'qligini tekshiring
- 6379 port ochiq ekanligini tekshiring

### Prisma Migration Error
```powershell
# Prisma schema generate qiling:
npx prisma generate

# Migration qayta run qiling:
npx prisma migrate reset
```

### Module Not Found Error
```powershell
# node_modules o'chirib, qayta o'rnating:
rm -r node_modules
npm install
```

---

## Qo'shimcha Sozlamalar

### PostgreSQL GUI (Tavsiya etiladi)

1. **pgAdmin 4**:
   - PostgreSQL bilan birga o'rnatiladi
   - Start menyudan pgAdmin 4 ni qidiring

2. **DBeaver** (Alternative):
   - https://dbeaver.io/download/
   - PostgreSQL uchun universal GUI

### Redis GUI

1. **Redis Desktop Manager**:
   - https://redisdesktop.com/download

2. **Another Redis Desktop Manager**:
   - https://github.com/qishibo/AnotherRedisDesktopManager

---

## Tayyor!

Endi http://localhost:3000 da dashboard ochib, admin bilan kirishingiz mumkin:
- **Email**: admin@vfsbot.local
- **Password**: admin1234

Omad! 🚀
