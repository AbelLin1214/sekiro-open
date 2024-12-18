# 使用 Maven 构建阶段
FROM maven:3.8-openjdk-8 AS builder

WORKDIR /build
COPY . .

# 直接执行 Maven 构建命令
RUN mvn -Dmaven.test.skip=true package appassembler:assemble && \
    chmod +x target/sekiro-server/bin/sekiro.sh

# 运行阶段
FROM openjdk:8-jre-slim

WORKDIR /app

# 直接复制构建产物
COPY --from=builder /build/target/sekiro-server/appassembler/ /app/

# 设置环境变量
ENV PORT=5612

# 暴露文档和服务端口
EXPOSE $PORT

# 启动服务
CMD ["sh", "bin/sekiro.sh"] 