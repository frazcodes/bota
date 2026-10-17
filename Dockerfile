FROM node:22-slim AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN apt-get update && apt-get install -y --no-install-recommends build-essential python3 && rm -rf /var/lib/apt/lists/*
RUN npm ci --omit=dev --no-audit --no-fund

FROM node:22-slim AS runner
ENV NODE_ENV=production
WORKDIR /app
RUN apt-get update && apt-get upgrade -y --no-install-recommends && rm -rf /var/lib/apt/lists/*
COPY --from=deps /app/node_modules ./node_modules
COPY --chown=node:node . .
EXPOSE 3000
USER node
CMD ["node", "index.js"]