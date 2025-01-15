FROM node:20.11.1-alpine AS builder
RUN apk add --no-cache git git-lfs && \
    git clone https://github.com/sp-tarkov/server spt-server && \
    cd spt-server && git lfs pull && \
    cd project && \
    sed -i 's/SPT.Server.exe/SPT.Server/g' ./gulpfile.mjs && \
    npm install && \
    npm run build:release

FROM debian:bookworm-slim
COPY --from=builder /spt-server/project/build/ /app/spt-server/
ENV TZ=Asia/Shanghai
WORKDIR /spt-server
EXPOSE 6969
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]