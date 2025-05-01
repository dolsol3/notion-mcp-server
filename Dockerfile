# --- Dockerfile 수정 ---

# 최종 실행 단계 (두 번째 FROM)
FROM node:20-slim
WORKDIR /app

# ---> 이 부분을 추가하세요 <---
# 빌더(builder) 스테이지의 /app 폴더에서 package.json과 package-lock.json을 복사합니다.
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./ 
# npm ci를 사용했으므로 lock 파일도 중요합니다.

# 기존 복사 명령들 (빌드 결과 및 node_modules)
COPY --from=builder /app/build ./build
COPY --from=builder /app/node_modules ./node_modules
# 참고: 아래 두 줄(전역 설치 복사)은 위에서 node_modules를 제대로 복사했다면 필요 없을 수 있습니다.
# COPY --from=builder /usr/local/lib/node_modules/@notionhq/notion-mcp-server ./node_modules/@notionhq/notion-mcp-server
# COPY --from=builder /usr/local/bin/notion-mcp-server /usr/local/bin/notion-mcp-server

# 나머지 ENV, EXPOSE, ENTRYPOINT 등
ENV CLOUD_RUN_PORT=8080 
EXPOSE 8080
ENTRYPOINT ["npm", "start"]

# --- 수정 끝 ---