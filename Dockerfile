# 🧱 Этап 1: Сборка
FROM node:18.14.2 AS builder

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@latest --activate

COPY package*.json ./
COPY pnpm-lock.yaml ./
RUN pnpm install

COPY . .

RUN pnpm run build

# 🚀 Этап 2: Прод-среда (Nginx)
FROM nginx:alpine AS runner

# Копируем собранную статику из предыдущего этапа
COPY --from=builder /app/dist /usr/share/nginx/html

# Копируем конфиг nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Запуск Nginx
CMD ["nginx", "-g", "daemon off;"]
