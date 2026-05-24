# 🚀 VFS Booking Bot - Render.com Deploy Qo'llanmasi

> **Professional va bepul hosting uchun to'liq qo'llanma**

---

## 📋 Render.com Afzalliklari

✅ **Bepul tier** - PostgreSQL, Redis, Web Services  
✅ **Auto-deploy** - GitHub push qilganda avtomatik  
✅ **SSL certificates** - Avtomatik HTTPS  
✅ **Zero config** - render.yaml bilan oson  
✅ **Global CDN** - Tez yuklanish  

---

## 🏗️ Arxitektura

```
┌─────────────────────────────────────────────────┐
│           Render.com Platform                   │
│                                                  │
│  ┌──────────────┐    ┌──────────────┐          │
│  │  PostgreSQL  │    │    Redis     │          │
│  │   (Free)     │    │    (Free)    │          │
│  └──────┬───────┘    └──────┬───────┘          │
│         │                   │                   │
│         └─────────┬─────────┘                   │
│                   │                             │
│         ┌─────────▼─────────┐                   │
│         │   Backend API     │                   │
│         │   (Node.js)       │                   │
│         │   (Free tier)     │                   │
│         └─────────┬─────────┘                   │
│                   │                             │
│         ┌─────────▼─────────┐                   │
│         │   Frontend        │                   │
│         │   (Next.js)       │                   │
│         │   (Static)        │                   │
│         └───────────────────┘                   │
└─────────────────────────────────────────────────┘
                  │
                  ▼
         ┌─────────────────┐
         │   Users/Browser │
         └─────────────────┘
```

---

## 📝 Deploy Qadamlar

### 0-Qadam: Tayyorgarlik

```bash
# 1. GitHub repository'ga push qiling
git add .
git commit -m "Ready for Render.com deployment"
git push origin main

# 2. Render.com account yarating
# https://render.com/signup
```

### 1-Qadam: PostgreSQL Database

1. **Render.com dashboard** → **New +** → **PostgreSQL**

2. **Configuration**:
   ```
   Name: vfs-db
   Database Name: vfsdb
   User: vfsuser
   Plan: Starter (Free)
   Postgres Version: 16
   Region: [O'zingizga yaqin]
   ```

3. **Create Database** tugmasini bosing

4. **Connection String**ni ko'chirib oling:
   ```
   postgresql://vfsuser:password@host:5432/vfsdb?sslmode=require
   ```

### 2-Qadam: Redis Instance

1. **New +** → **Redis**

2. **Configuration**:
   ```
   Name: vfs-redis
   Plan: Starter (Free)
   Region: [PostgreSQL bilan bir xil]
   ```

3. **Create Redis** bosing

4. **Connection URL**ni ko'chirib oling:
   ```
   rediss://default:password@host:6379
   ```

### 3-Qadam: Backend Web Service

#### Variant A: Dashboard'dan (Tavsiya etiladi)

1. **New +** → **Web Service**

2. **Connect Repository**:
   ```
   GitHub → Select repository → Connect
   ```

3. **Configuration**:
   ```
   Name: vfs-backend
   Environment: Node
   Build Command: cd backend && npm install && npx prisma generate && npx prisma migrate deploy
   Start Command: cd backend && npm start
   Plan: Starter (Free)
   Root Directory: backend
   Node Version: 20
   ```

4. **Environment Variables** (Add each one):

   ```env
   NODE_ENV=production
   PORT=10000
   DATABASE_URL=<PostgreSQL connection string>
   REDIS_URL=<Redis connection URL>
   JWT_ACCESS_SECRET=<64 char hex>
   JWT_REFRESH_SECRET=<64 char hex>
   JWT_ACCESS_EXPIRY=15m
   JWT_REFRESH_EXPIRY=7d
   PROFILE_ENCRYPTION_KEY=<64 char hex>
   CAPTCHA_SOLVER=manual
   BOOKING_CONCURRENCY=3
   MONITOR_DEFAULT_INTERVAL_MS=30000
   SESSION_DIR=/tmp/sessions
   BOOKING_MAX_RETRIES=3
   ```

5. **Advanced Settings**:
   ```
   Health Check Path: /api/health
   Docker Container: No
   ```

6. **Create Web Service** bosing

#### Variant B: render.yaml (IaC)

```bash
# Render CLI o'rnating
npm install -g @render-cloud/cli

# Login
render login

# Deploy
render up
```

### 4-Qadam: Frontend Static Site

1. **New +** → **Static Site**

2. **Connect Repository**:
   ```
   Same GitHub repository
   ```

3. **Configuration**:
   ```
   Name: vfs-frontend
   Build Command: cd frontend && npm install && npm run build
   Publish Directory: frontend/out
   Framework Preset: Next.js
   ```

4. **Environment Variables**:
   ```env
   NODE_ENV=production
   STATIC_EXPORT=true
   NEXT_PUBLIC_API_URL=<Backend URL>
   NEXT_PUBLIC_WS_URL=<Backend URL>
   ```

5. **Create Static Site** bosing

### 5-Qadam: Environment Variables Sozlash

Backend va Frontend URL'larni o'zaro bog'lash:

**Backend**ga qo'shing:
```
FRONTEND_URL=https://vfs-frontend.onrender.com
```

**Frontend**da (allaqachon sozlangan):
```
NEXT_PUBLIC_API_URL=https://vfs-backend.onrender.com
NEXT_PUBLIC_WS_URL=https://vfs-backend.onrender.com
```

### 6-Qadam: Keys Generatsiya

```bash
# JWT Access Secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# JWT Refresh Secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Profile Encryption Key
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### 7-Qadam: Database Seed

Backend service ishga tushgandan keyin (30-60 soniya kuting):

**Terminal orqali**:
```bash
# Render CLI bilan
render exec vfs-backend -- npx ts-node -r tsconfig-paths/register prisma/seed.ts
```

**Yoki Dashboard'da**:
```
Logs tab → Manual command yuborish
```

### 8-Qadam: Tekshirish

1. **Backend Health**:
   ```
   https://vfs-backend.onrender.com/api/health
   ```

2. **Frontend**:
   ```
   https://vfs-frontend.onrender.com
   ```

3. **Admin Login**:
   - Email: `admin@vfsbot.local`
   - Password: `admin1234`

---

## 🔧 Production Optimizatsiya

### 1. Build Cache

`render.yaml` ga qo'shing:
```yaml
services:
  - type: web
    name: vfs-backend
    cacheKey: vfs-backend-v1
```

### 2. Auto-Deploy

GitHub webhook avtomatik:
```
git push → Build → Deploy
```

### 3. Health Check

Backend `/api/health` endpoint ishlaydi:
```typescript
app.get('/api/health', async (req, res) => {
  const dbOk = await checkDatabase();
  const redisOk = await checkRedis();
  res.json({ 
    status: dbOk && redisOk ? 'healthy' : 'unhealthy',
    timestamp: new Date().toISOString()
  });
});
```

### 4. Logging

Render.com dashboard:
- **Real-time logs**
- **Error tracking**
- **Performance metrics**

---

## 📊 Render.com Free Tier Cheklovlari

| Service | Limits | Notes |
|---------|--------|-------|
| **Web Service** | 750 hours/month | ~24/7 ishlaydi |
| **PostgreSQL** | 1GB storage | Automatic backups |
| **Redis** | 25MB storage | In-memory |
| **Static Site** | 100GB bandwidth | CDN orqali |
| **Sleep Mode** | 15 min idle | Free tier'da |

⚠️ **Muhim**: Free tier'da service 15 daqiqa faol bo'lmasa "sleep" modiga o'tadi. Keyingi request kelganda **30-60 soniya** warming kerak bo'ladi.

### Production Uchun Upgrade

```
Starter Plan: $7/month per service
- No sleep mode
- Better performance
- More resources
```

---

## 🐛 Troubleshooting

### Build Failed ❌

**Sabab**: Node version yoki dependencies

**Yechim**:
```bash
# package.json'da tekshiring
"engines": {
  "node": ">=20.0.0"
}
```

### Database Connection Error ❌

**Sabab**: DATABASE_URL noto'g'ri

**Yechim**:
1. Connection string to'g'riligini tekshiring
2. `sslmode=require` qo'shing
3. IP allowlist sozlamasini tekshiring

### Frontend API Error ❌

**Sabab**: NEXT_PUBLIC_API_URL noto'g'ri

**Yechim**:
1. Backend URL to'g'ri ekanligini tekshiring
2. CORS sozlamalarini tekshiring
3. Backend health check ishlayapti-yo'qligini tekshiring

### Memory Error ❌

**Sabab**: Free tier 512MB limit

**Yechim**:
```env
# .env
BOOKING_CONCURRENCY=1  # Kamaytirish
MONITOR_DEFAULT_INTERVAL_MS=60000  # Interval oshirish
```

### Deploy Timeout ❌

**Sabab**: Build vaqtida vaqt yetmayapti

**Yechim**:
```bash
# Build optimize qiling
# backend/package.json
"scripts": {
  "build": "tsc --project tsconfig.json"
}
```

---

## 📝 Deploy Checklist

Deploy qilishdan oldin:

- [ ] GitHub repository ready
- [ ] PostgreSQL database yaratildi
- [ ] Redis instance yaratildi
- [ ] Backend service konfiguratsiya qilindi
- [ ] Frontend static site konfiguratsiya qilindi
- [ ] All environment variables sozlandi
- [ ] Database migrations ishga tushdi
- [ ] Admin account yaratildi
- [ ] Health check ishlayapti
- [ ] Frontend-backend ulandi
- [ ] SSL certificate ishlayapti

Deploy tugagandan keyin:

- [ ] Frontend ochiladi
- [ ] Admin login ishlaydi
- [ ] Database connection ishlaydi
- [ ] Redis connection ishlaydi
- [ ] Logs ko'rinadi
- [ ] Auto-deploy ishlaydi

---

## 🎉 Tayyor!

Deploy muvaffaqiyatli tugadi!

**URL'lar**:
- Frontend: `https://vfs-frontend.onrender.com`
- Backend: `https://vfs-backend.onrender.com`
- Database: PostgreSQL (internal)
- Cache: Redis (internal)

**Admin Login**:
- URL: `https://vfs-frontend.onrender.com`
- Email: `admin@vfsbot.local`
- Password: `admin1234`

---

## 💡 Qo'shimcha Maslahatlar

### 1. Monitoring

- Render.com dashboard → Metrics
- Response time, CPU, Memory
- Error rate tracking

### 2. Backups

PostgreSQL automatic backups:
- Daily backups (paid plan)
- Manual backups:
  ```bash
  render database backup create vfs-db
  ```

### 3. Scaling

Traffic oshganda:
```
Starter → Pro plan
512MB → 1GB/2GB RAM
```

### 4. Security

- Environment variables muntazam yangilang
- API keys secret saqlang
- CORS sozlamalarini tekshiring
- Rate limiting ishlatilgan

### 5. Custom Domain

```
Settings → Custom Domain
Domain name: yourdomain.com
DNS: CNAME point to onrender.com
```

---

## 📞 Yordam

Agar muammo bo'lsa:

1. **Render.com Docs**: https://render.com/docs
2. **Logs**: Dashboard → Logs tab
3. **Support**: render.com support ticket
4. **Community**: Render.com community forum

---

**Omad tilaman!** 🚀

Loyihangiz Render.com'da muvaffaqiyatli ishlaydi!
