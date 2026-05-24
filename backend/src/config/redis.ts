// In-Memory Cache (Redis'siz ishlaydi - SQLite versiyasi)
import { getCache, redisClient, connectRedis, disconnectRedis } from './inmemory-cache';

export { getCache as getRedis, redisClient, connectRedis, disconnectRedis };
