# Docker 会自动注入 TARGETARCH 变量
ARG TARGETARCH

# 根据架构选择不同的基础镜像
FROM haoxuan8855/debian-systemd:x64 AS base-amd64
FROM haoxuan8855/debian-systemd:arm64 AS base-arm64

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
    curl openssh-server \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# 安装 PM2
RUN npm install -g pm2

RUN mkdir -p /var/run/sshd && echo 'root:q09995' | chpasswd

# 创建用户haoxuan，并设置密码
RUN useradd -m -g root haoxuan && echo "haoxuan:q09995" | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -i 's/#Port 22/Port 6623/' /etc/ssh/sshd_config \
 && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

COPY ./pm2-root.service /etc/systemd/system/

RUN systemctl enable pm2-root

# 容器启动时运行的命令
ENTRYPOINT ["/bin/systemd"]
