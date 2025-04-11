# Docker 会自动注入 TARGETARCH 变量
ARG TARGETARCH

# 根据架构选择不同的基础镜像
FROM haoxuan8855/ubuntu-systemd:x64 AS base-amd64
FROM haoxuan8855/ubuntu-systemd:arm64 AS base-arm64

# 选择对应的基础镜像
FROM base-${TARGETARCH}

# Docker 会自动注入 TARGETARCH 变量
ARG TARGETARCH

# 设置工作目录为 /root
WORKDIR /root

# 确保容器以 root 用户运行
USER root

# 安装Node.js环境（pm2依赖Node.js）
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# 安装 PM2
RUN npm install -g pm2

# 容器启动时运行的命令
ENTRYPOINT ["/bin/systemd"]
