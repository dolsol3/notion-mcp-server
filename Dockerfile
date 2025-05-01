# --- 싱글 스테이지 Dockerfile 예시 ---
    FROM node:20-slim

    # 작업 디렉토리 설정
    WORKDIR /app
    
    # 의존성 설치 먼저 (변경이 잦지 않으므로 캐시 활용에 유리)
    COPY package*.json ./
    RUN npm ci --ignore-scripts --omit=dev
    
    # 전체 소스 코드 복사
    COPY . .
    
    # 빌드 실행 (TypeScript 컴파일 등, package.json에 정의된 스크립트)
    RUN npm run build
    
    # 환경 변수 (Cloud Run 표준 PORT 사용 권장)
    # ENV PORT=8080 # Cloud Run이 자동으로 설정해주므로 굳이 안 써도 됨
    EXPOSE 8080 
    
    # 시작 명령어 (둘 중 하나 선택)
    # 옵션 1: npm start 스크립트 사용 (package.json에 "start"가 정의되어 있어야 함)
    ENTRYPOINT ["npm", "start"]
    # 옵션 2: 빌드된 메인 JS 파일 직접 실행 (예: build/index.js 가 메인 파일일 경우)
    # CMD ["node", "build/index.js"]
    
    # --- 예시 끝 ---