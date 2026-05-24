// In-Memory Redis Replacement (SQLite versiyasi uchun)
// Redis'siz ishlaydigan in-memory cache

class InMemoryCache {
  private cache: Map<string, any> = new Map();
  private ttlMap: Map<string, number> = new Map();

  async get(key: string): Promise<any> {
    // TTL tekshirish
    const expiry = this.ttlMap.get(key);
    if (expiry && Date.now() > expiry) {
      this.cache.delete(key);
      this.ttlMap.delete(key);
      return null;
    }
    return this.cache.get(key) || null;
  }

  async set(key: string, value: any, ttl?: number): Promise<void> {
    this.cache.set(key, value);
    if (ttl) {
      this.ttlMap.set(key, Date.now() + ttl * 1000);
    }
  }

  async del(key: string): Promise<void> {
    this.cache.delete(key);
    this.ttlMap.delete(key);
  }

  async exists(key: string): Promise<boolean> {
    return this.cache.has(key);
  }

  async keys(pattern: string): Promise<string[]> {
    const regex = new RegExp(pattern.replace('*', '.*'));
    return Array.from(this.cache.keys()).filter(k => regex.test(k));
  }

  async incr(key: string): Promise<number> {
    const current = parseInt(this.cache.get(key) || '0');
    const newValue = current + 1;
    this.cache.set(key, newValue.toString());
    return newValue;
  }

  async expire(key: string, ttl: number): Promise<boolean> {
    this.ttlMap.set(key, Date.now() + ttl * 1000);
    return true;
  }
}

// Singleton instance
let cacheInstance: InMemoryCache | null = null;

export function getCache(): InMemoryCache {
  if (!cacheInstance) {
    cacheInstance = new InMemoryCache();
  }
  return cacheInstance;
}

// Redis client replacement
export const redisClient = {
  get: (key: string) => getCache().get(key),
  set: (key: string, value: any, ttl?: number) => getCache().set(key, value, ttl),
  del: (key: string) => getCache().del(key),
  exists: (key: string) => getCache().exists(key),
  keys: (pattern: string) => getCache().keys(pattern),
  incr: (key: string) => getCache().incr(key),
  expire: (key: string, ttl: number) => getCache().expire(key, ttl),
  disconnect: () => { /* No-op for in-memory */ },
};

// Connection functions (no-op for in-memory)
export async function connectRedis(): Promise<void> {
  console.info('✅ In-memory cache initialized (Redis not required)');
}

export async function disconnectRedis(): Promise<void> {
  console.info('✅ In-memory cache disconnected');
}

export { getCache as getRedisClient };
