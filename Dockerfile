FROM node:14-alpine AS base

WORKDIR /usr/app

COPY . .

# Prepare static files
FROM base AS build-backend
RUN npm ci
RUN npm run build

# Release
FROM base AS Release

COPY --from=build-backend /usr/app/dist ./

COPY ./package.json .
COPY ./package-lock.json .

RUN npm ci --only=production

CMD ["node","index.js"]
