mkdir -p /opt/checkmate/mongo/data && \
docker network create checkmate_net || true && \
cat > /opt/checkmate/docker-compose.yml <<'YML'
services:
  mongodb:
    image: ghcr.io/bluewave-labs/checkmate-mongo:latest
    restart: unless-stopped
    command: ["mongod","--quiet","--bind_ip_all"]
    volumes:
      - ./mongo/data:/data/db
    networks: [ checkmate_net ]

  server:
    image: ghcr.io/bluewave-labs/checkmate-backend-mono:latest
    restart: unless-stopped
    environment:
      - DB_CONNECTION_STRING=mongodb://mongodb:27017/uptime_db
      - JWT_SECRET=changeme123456789
      - CLIENT_HOST=http://0.0.0.0:52345
      - UPTIME_APP_API_BASE_URL=http://0.0.0.0:52345/api/v1
      - UPTIME_APP_CLIENT_HOST=http://0.0.0.0:52345
    depends_on: [mongodb]
    ports:
      - "52345:52345"
    networks: [ checkmate_net ]

networks:
  checkmate_net:
    external: true
YML
cd /opt/checkmate && docker compose up -d
