/** @type {import('next').NextConfig} */
const nextConfig = {
  // Production mode: standalone for Docker, export for static
  output: process.env.STATIC_EXPORT === 'true' ? 'export' : 'standalone',
  
  // Disable React strict mode in production for better performance
  reactStrictMode: true,
  
  // Image optimization (disable for static export)
  images: {
    unoptimized: process.env.STATIC_EXPORT === 'true',
  },
  
  // Async rewrites for API proxy
  async rewrites() {
    return process.env.NODE_ENV === 'development'
      ? [
          {
            source: '/api/:path*',
            destination: `${process.env.NEXT_PUBLIC_API_URL ?? 'http://localhost:3001'}/api/:path*`,
          },
        ]
      : [];
  },
  
  // Headers for security
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
        ],
      },
    ];
  },
};

export default nextConfig;
