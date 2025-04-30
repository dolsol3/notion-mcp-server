# syntax=docker/dockerfile:1

# Use Node.js LTS as the base image
FROM node:20-slim AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies (BuildKit 옵션 제거)
RUN npm ci --ignore-scripts --omit-dev

# Copy source code
COPY . .

# Build the package (BuildKit 옵션 제거)
RUN npm run build

# Install package globally (BuildKit 옵션 제거)
RUN npm link

# Minimal image for runtime
FROM node:20-slim

# Copy built package from builder stage
COPY scripts/notion-openapi.json /usr/local/scripts/
COPY --from=builder /usr/local/lib/node_modules/@notionhq/notion-mcp-server /usr/local/lib/node_modules/@notionhq/notion-mcp-server
COPY --from=builder /usr/local/bin/notion-mcp-server /usr/local/bin/notion-mcp-server

# Set default environment variables
ENV OPENAPI_MCP_HEADERS="{}"

# Cloud Run이 요구하는 포트(8080) 노출
EXPOSE 8080

# Set entrypoint (npm start 사용)
ENTRYPOINT ["npm", "start"]
