# Sử dụng image base với công cụ build C
FROM debian:bullseye-slim

# Cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    openssl \
    libssl-dev \
    libevent-dev \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

# Sao chép mã nguồn
COPY . /app
WORKDIR /app

# Làm sạch và biên dịch với tùy chọn bổ sung cho PCLMUL và SSE2
RUN make clean && \
    make CFLAGS="-fPIC -mpclmul -msse2 -O2" LDFLAGS="-shared" && \
    strip mtproto-proxy

# Cài đặt biến môi trường từ Railway
ENV PORT=${PORT:-8888}
ENV SECRET=${SECRET}

# Chạy MTProxy
CMD ./mtproto-proxy -u nobody -p $PORT -S $SECRET -P 0.0.0.0
