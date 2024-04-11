FROM node:18-alpine AS base

FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json* ./
RUN if [ -f package-lock.json ]; then npm ci; fi

FROM deps AS builder
WORKDIR /app
COPY . .

RUN if [ -f package-lock.json ]; then npm run build; fi

FROM base AS runner
WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

RUN mkdir .next
RUN chown nextjs:nodejs .next

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 80

ENV PORT 80

CMD HOSTNAME="0.0.0.0" node server.js
