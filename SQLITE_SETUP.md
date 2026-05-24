# 🚀 VFS Booking Bot - SQLite Local Setup
## Docker, PostgreSQL, Redis'siz TO'LIQ lokal ishlaydigan versiya

---

## ✅ Nima Kerak?

- **Faqat Node.js** (v18+ yoki v20+)
- Hech qanday Docker, PostgreSQL, Redis o'rnatish shart **EMAS**!

---

## 📦 O'rnatish (3 Qadam)

### 1-Qadam: PowerShell Script Ishga Tushirish

```powershell
.\start-sqlite-local.ps1
```

Bu script avtomatik:
- ✅ Kutubxonalarni o'rnatadi (backend + frontend)
- ✅ SQLite database yaratadi
- ✅ Admin account yaratadi
- ✅ Hamma narsani sozlaydi

### 2-Qadam: Serverlarni Ishga Tushirish

```powershell
.\run-sqlite-local.ps1
```

Bu script ikkita yangi terminal ochadi:
- **Backend**: http://localhost:3001
- **Frontend**: http://localhost:3000

### 3-Qadam: Dashboard Ochish

Browser'da oching: **http://localhost:3000**

**Admin Login**:
- Email: `admin@vfsbot.local`
- Password: `admin1234`

---

## 🎯 Qo'lda Ishga Tushirish (Optional)

Agar scriptlar ishlamasa, qo'lda bajaring:

### Backend:
```powershell
cd backend
npm install
npx prisma generate
npx prisma migrate dev --name init
npx ts-node -r tsconfig-paths/register prisma/seed.ts
npm run dev
```

### Frontend (yangi terminal):
```powershell
cd frontend
npm install
npm run dev
```

---

## 📊 Database Ko'rish

Prisma Studio ochish:
```powershell
cd backend
npx prisma studio
```

Bu GraphQL GUI ochadi va database'dagi barcha ma'lumotlarni ko'rish mumkin.

---

## 🔧 Nimalar Ishlaydi?

✅ User authentication (JWT)  
✅ Profile management (encrypted)  
✅ Booking system  
✅ Monitor service  
✅ WebSocket real-time updates  
✅ Logging system  
✅ All API endpoints  

---

## ⚠️ Cheklovlar

Bu **development versiyasi**:

1. **In-Memory Cache**: Server qayta ishga tushganda cache tozalanadi
2. **Single-User**: Faqat bitta kompyuterda ishlatish uchun
3. **No Background Jobs**: BullMQ'siz, job'lar oddiy async/await bilan

**Production uchun** PostgreSQL + Redis + Docker versiyasini ishlatish tavsiya etiladi.

---

## 🐛 Muammolarni Hal Qilish

### "Cannot find module '@prisma/client'"
```powershell
cd backend
npx prisma generate
npm install
```

### "Port 3001 already in use"
```powershell
# Windows'da portni o'chirish:
netstat -ano | findstr :3001
taskkill /PID <PID> /F
```

### "Database locked"
```powershell
# database.db faylni o'chirib, qayta yaratish:
cd backend
rm database.db
npx prisma migrate dev --name init
```

---

## 📚 Fayl Tuzilishi

```
vfs-booking-bot/
├── backend/
│   ├── prisma/
│   │   ├── schema.prisma      # SQLite schema
│   │   └── dev.db             # SQLite database file ⭐
│   ├── src/
│   │   ├── config/
│   │   │   ├── inmemory-cache.ts  # In-memory cache (Redis replacement)
│   │   │   └── redis.ts           # Now uses in-memory
│   │   └── ...
│   └── package.json
├── frontend/
│   └── ...
├── .env                         # Environment variables
├── start-sqlite-local.ps1       # Setup script ⭐
├── run-sqlite-local.ps1         # Run script ⭐
└── SQLITE_SETUP.md              # Bu fayl
```

---

## 🎉 Tayyor!

Hech qanday murakkab o'rnatish yo'q - faqat:

```powershell
.\start-sqlite-local.ps1
.\run-sqlite-local.ps1
```

va **http://localhost:3000** ga o'ting!

---

## 📞 Yordam

Agar muammo bo'lsa:
1. `NO_DEPENDENCY_SETUP.md` ni o'qing
2. Terminal'dagi xatolik xabarlarini tekshiring
3. Node.js versiyasini tekshiring (`node --version`)

**Omad!** 🚀
