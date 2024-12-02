# Sử dụng Node.js để build Vue.js
FROM node:16 AS builder

# Đặt thư mục làm việc trong container
WORKDIR /app

# Sao chép file package.json và package-lock.json vào container
COPY package*.json ./

# Cài đặt các dependencies
RUN npm install

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Build ứng dụng Vue.js
RUN npm run build

# Giai đoạn 2: Dùng Nginx để phục vụ ứng dụng
FROM nginx:latest

# Sao chép file build từ giai đoạn trước vào thư mục Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy file cấu hình Nginx (nếu có)
COPY nginx.conf /etc/nginx/nginx.conf

# Mở cổng 80
EXPOSE 80

# Khởi động Nginx
CMD ["nginx", "-g", "daemon off;"]
