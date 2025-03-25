FROM node:22.12.0-bullseye AS server-builder
RUN apt update && apt install -y git git-lfs p7zip-full && \
git clone -b master --depth=1 https://github.com/sp-tarkov/server spt-server && \
    cd spt-server && git lfs pull && \
    cd project && \
    sed -i 's/SPT.Server.exe/SPT.Server/g' ./gulpfile.mjs && \
    npm install && \
    npm run build:release && \
    rm -rf /var/lib/apt/lists/*

FROM debian:bookworm-slim
COPY --from=server-builder /spt-server/project/build/ /app/spt-server/
ENV TZ=Asia/Shanghai
VOLUME /spt-server
WORKDIR /spt-server
EXPOSE 6969
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]