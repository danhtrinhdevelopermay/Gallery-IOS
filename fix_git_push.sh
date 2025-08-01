#!/bin/bash

echo "🔧 Khắc phục lỗi Git push - File quá lớn"

# Bước 1: Xóa Git repository cũ
echo "1. Xóa Git history cũ..."
rm -rf .git

# Bước 2: Xóa các file không cần thiết
echo "2. Xóa các file lớn và không cần thiết..."
find . -name "*.zip" -delete
find . -name "gradle-*" -type d -exec rm -rf {} + 2>/dev/null || true
rm -f my-release-key.keystore
rm -f keystore-base64.txt

# Bước 3: Khởi tạo Git repository mới
echo "3. Khởi tạo Git repository mới..."
git init

# Bước 4: Thiết lập user (nếu cần)
git config user.name "Developer"
git config user.email "developer@example.com"

# Bước 5: Add .gitignore trước
echo "4. Thêm .gitignore..."
git add .gitignore
git commit -m "Add gitignore"

# Bước 6: Add tất cả file còn lại
echo "5. Thêm tất cả file..."
git add .
git commit -m "Initial commit: iOS Gallery App with GitHub Actions"

echo ""
echo "✅ Repository đã được khởi tạo thành công!"
echo ""
echo "📋 Tiếp theo, chạy các lệnh sau:"
echo ""
echo "git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git"
echo "git push -u origin main --force"
echo ""
echo "🔑 Nhớ thay YOUR_USERNAME và YOUR_REPO_NAME bằng thông tin thật"
echo "📦 Sau khi push, thêm 4 secrets vào GitHub repository:"
echo "   - KEYSTORE_BASE64"
echo "   - KEYSTORE_PASSWORD: 123456"
echo "   - KEY_PASSWORD: 123456"
echo "   - KEY_ALIAS: my-key-alias"