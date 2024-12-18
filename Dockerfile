# 使用 Maven 构建阶段
FROM maven:3.8-openjdk-8 AS builder

WORKDIR /build
COPY . .

# 执行构建脚本，生成 sekiro-open-demo.zip
RUN chmod +x build_demo_server.sh && \
    ./build_demo_server.sh

# 运行阶段
FROM openjdk:8-jre-slim

WORKDIR /app

# 从构建阶段复制构建产物
COPY --from=builder /build/target/sekiro-open-demo.zip /app/
RUN apt-get update && \
    apt-get install -y unzip && \
    unzip sekiro-open-demo.zip && \
    rm sekiro-open-demo.zip && \
    apt-get remove -y unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置环境变量
ENV PORT=5612

# 暴露文档和服务端口
EXPOSE $PORT

# 启动服务
CMD ["sh", "bin/sekiro.sh"] 