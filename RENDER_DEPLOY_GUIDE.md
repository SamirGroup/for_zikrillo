# 🚀 VFS Booking Bot - Render.com Deploy Qo'llanmasi

## 📋 Render.com Uchun Nimalar Kerak?

- ✅ **Bepul tier** mavjud (PostgreSQL, Redis, Web Services)
- ✅ **Auto-deploy** GitHub'dan
- ✅ **SSL certificates** avtomatik
- ✅ **Environment variables** boshqaruvi

---

## 🛠️ Deploy Qadamlar

### 1-Qadam: GitHub Repository Tayyorlash

```bash
# Repository'ga push qiling
git add .
git commit -m "Ready for Render.com deployment"
git push origin main
```

### 2-Qadam: Render.com Account Yaratish

1. https://render.com ga o'ting
2. "Sign Up" bosing
3. GitHub account bilan kirish tavsiya etiladi

### 3-Qadam: PostgreSQL Database Yaratish

1. Render.com dashboard'da **"New +"** → **"PostgreSQL"**
2. Configuration:
   ```
   Name: vfs-db
   Plan: Free (starter)
   Database Name: vfsdb
   User: vfsuser
   ```
3. **Create Database** bosing
4. Database yaratilgandan keyin **Connection String**ni ko'chirib oling

### 4-Qadam: Redis Instance Yaratish

1. **"New +"** → **"Redis"**
2. Configuration:
   ```
   Name: vfs-redis
   Plan: Free (starter)
   ```
3. **Create Redis** bosing
4. **Connection URL**ni ko'chirib oling

### 5-Qadam: Backend Web Service Deploy

#### Variant A: Render.com Dashboard (Recommended)

1. **"New +"** → **"Web Service"**
2. Connect GitHub repository
3. Configuration:
   ```
   Name: vfs-backend
   Environment: Node
   Build Command: cd backend && npm install && npx prisma generate && npx prisma migrate deploy
   Start Command: cd backend && npx prisma migrate deploy && npm start
   Plan: Free (starter)
   ```

4. **Environment Variables**:
   ```env
   NODE_ENV=production
   PORT=10000
   DATABASE_URL=<PostgreSQL connection string>
   REDIS_URL=<Redis connection URL>
   JWT_ACCESS_SECRET=<generate random 64 char hex>
   JWT_REFRESH_SECRET=<generate random 64 char hex>
   JWT_ACCESS_EXPIRY=15m
   JWT_REFRESH_EXPIRY=7d
   PROFILE_ENCRYPTION_KEY=<generate random 64 char hex>
   CAPTCHA_SOLVER=manual
   BOOKING_CONCURRENCY=3
   MONITOR_DEFAULT_INTERVAL_MS=30000
   SESSION_DIR=/tmp/sessions
   BOOKING_MAX_RETRIES=3
   FRONTEND_URL=<Will be added after frontend deploy>
   ```

5. **Advanced Settings**:
   - Health Check Path: `/api/health`
   - Docker: No (use Node.js environment)

#### Variant B: render.yaml (Infrastructure as Code)

```bash
# Render CLI o'rnating
npm install -g @render-cloud/cli

# Login
render login

# Deploy
render up
```

### 6-Qadam: Frontend Static Site Deploy

#### Variant A: Render.com Dashboard

1. **"New +"** → **"Static Site"**
2. Connect GitHub repository
3. Configuration:
   ```
   Name: vfs-frontend
   Build Command: cd frontend && npm install && npm run build
   Publish Directory: frontend/out
   ```

4. **Environment Variables**:
   ```env
   NODE_ENV=production
   NEXT_PUBLIC_API_URL=<Backend service URL>
   NEXT_PUBLIC_WS_URL=<Backend service URL>
   ```

5. **Build Settings**:
   - Framework Preset: Next.js
   - Node version: 20

#### Variant B: Next.js Static Export

`frontend/next.config.mjs` ni yangilash kerak:

```javascript
const nextConfig = {
  output: 'export',  // Static export
  trailingSlash: true,
  // ... other config
};
```

### 7-Qadam: Environment Variables Sozlash

Backend va Frontend o'rtasida URL'larni sozlash:

1. **Backend**ga Frontend URL qo'shing:
   ```
   FRONTEND_URL=https://vfs-frontend.onrender.com
   ```

2. **Frontend**ga Backend URL qo'shing:
   ```
   NEXT_PUBLIC_API_URL=https://vfs-backend.onrender.com
   NEXT_PUBLIC_WS_URL=https://vfs-backend.onrender.com
   ```

### 8-Qadam: Database Seed

Backend service ishga tushgandan keyin:

```bash
# Backend logs ko'ring va seed command yuboring
# Yoki SSH orqali:
render ssh vfs-backend
npx prisma migrate deploy
npx ts-node -r tsconfig-paths/register prisma/seed.ts
```

### 9-Qadam: Custom Domain (Optional)

1. Dashboard'da **"Settings"** → **"Custom Domain"**
2. Domain nomini kiriting
3. DNS records sozlang (CNAME yoki A record)
4. **Verify** bosing

---

## 🔑 Keys Generatsiya

Render.com'da environment variables yaratish uchun keys'lar:

### JWT Access Secret:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### JWT Refresh Secret:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### Profile Encryption Key:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

---

## 📊 Render.com Free Tier Limits

| Service | Free Tier |
|---------|-----------|
| Web Service | 750 hours/month, 512MB RAM |
| PostgreSQL | 1GB storage, 10GB bandwidth |
| Redis | 25MB storage |
| Static Site | 100GB bandwidth/month |

**Eslatma**: Free tier'da service 15 daqiqadan keyin "sleep" modiga o'tadi. Keyingi request kelganda 30-60 soniya "warming" kerak bo'ladi.

---

## 🐛 Troubleshooting

### Build Failed

**Sabab**: Node version yoki dependencies muammo

**Yechim**:
```bash
# package.json'da Node version tekshiring
"engines": {
  "node": ">=20.0.0"
}
```

### Database Connection Error

**Sabab**: DATABASE_URL noto'g'ri

**Yechim**:
- PostgreSQL connection string to'g'riligini tekshiring
- IP allowlist sozlamasini tekshiring (Render internal network)

### Frontend API Error

**Sabab**: NEXT_PUBLIC_API_URL noto'g'ri

**Yechim**:
- Backend service URL to'g'ri ekanligini tekshiring
- CORS sozlamalarini tekshiring

### Memory Error

**Sabab**: Free tier memory limiti (512MB)

**Yechim**:
- `BOOKING_CONCURRENCY=1` ga o'zgartiring
- Yoki paid plan'ga o'ting

---

## 🚀 Production Optimizatsiya

### 1. Build Cache

`render.yaml`'da:
```yaml
services:
  - type: web
    name: vfs-backend
    cacheKey: vfs-backend-v1  # Build cache
```

### 2. Auto-Deploy

GitHub webhook avtomatik deploy qiladi:
```
Push → Build → Deploy
```

### 3. Health Check

Backend `/api/health` endpoint:
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

Render.com dashboard'da logs ko'rinadi:
- Real-time logs
- Error tracking
- Performance metrics

---

## 📝 Deploy Checklist

- [ ] GitHub repository public/private
- [ ] PostgreSQL database yaratildi
- [ ] Redis instance yaratildi
- [ ] Backend web service deploy qilindi
- [ ] Frontend static site deploy qilindi
- [ ] Environment variables sozlandi
- [ ] Database migrations ishga tushdi
- [ ] Admin account yaratildi
- [ ] Health check ishlayapti
- [ ] Frontend Backend bilan ulandi
- [ ] SSL certificate ishlayapti
- [ ] Logs tekshirildi

---

## 🎉 Tayyor!

Deploy tugagandan keyin:

1. **Frontend URL**: `https://vfs-frontend.onrender.com`
2. **Backend URL**: `https://vfs-backend.onrender.com`
3. **Admin Login**: admin@vfsbot.local / admin1234

---

## 💡 Qo'shimcha Maslahatlar

1. **Monitoring**: Render.com dashboard'da metrics ko'ring
2. **Backups**: PostgreSQL automatic backups (paid plan)
3. **Scaling**: Traffic oshganda plan'ni upgrade qiling
4. **Security**: Environment variables'ni muntazam yangilang

**Omad!** 🚀
