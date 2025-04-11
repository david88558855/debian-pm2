# Docker 会自动注入 TARGETARCH 变量
ARG TARGETARCH

# 根据架构选择不同的基础镜像
FROM haoxuan8855/debian-systemd:x64 AS base-amd64
FROM haoxuan8855/debian-systemd:arm64 AS base-arm64

# 选择对应的基础镜像
FROM base-${TARGETARCH}

# Docker 会自动注入 TARGETARCH 变量
ARG TARGETARCH

# 安装Node.js环境（pm2依赖Node.js）
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# 安装 PM2
RUN npm install -g pm2

# 验证 PM2 是否安装成功
CMD pm2 --version

# 容器启动时运行的命令
ENTRYPOINT ["/bin/systemd"]
