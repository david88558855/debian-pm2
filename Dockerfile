# Docker 会自动注入 TARGETARCH 变量
ARG TARGETARCH

# 根据架构选择不同的基础镜像
FROM alpine:latest AS base-amd64
FROM arm64v8/alpine:latest AS base-arm64

# 选择对应的基础镜像
FROM base-${TARGETARCH}

# Docker 会自动注入 TARGETARCH 变量
ARG TARGETARCH

#拷贝文件至/app文件夹
COPY ./${TARGETARCH}/tfcenter/ /app

# 修改 app 文件夹内所有文件的执行权限
RUN chmod -R +x /app/*

# 容器启动时运行的命令
ENTRYPOINT ["/app/tfcenter64"]
