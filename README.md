# iOS Gallery App

Ứng dụng gallery Android với giao diện giống iOS, được build bằng Flutter.

## Tính năng

- 📱 Giao diện giống iOS đến từng chi tiết
- 📸 Chụp ảnh và chọn ảnh từ thư viện
- 🖼️ Xem ảnh với zoom và pan
- ✅ Chế độ chọn và xóa nhiều ảnh
- 🔄 GitHub Actions tự động build APK

## Cấu trúc dự án

```
├── lib/
│   ├── main.dart                 # Entry point
│   ├── models/
│   │   └── gallery_item.dart     # Model cho gallery items
│   ├── screens/
│   │   ├── gallery_screen.dart   # Màn hình chính
│   │   └── photo_detail_screen.dart # Màn hình xem ảnh chi tiết
│   └── widgets/
│       ├── ios_navigation_bar.dart # Navigation bar giống iOS
│       └── gallery_grid.dart     # Grid hiển thị ảnh
├── android/                      # Android configuration
├── .github/workflows/build.yml   # GitHub Actions workflow
└── assets/images/               # Ảnh mẫu
```

## GitHub Actions Build

Workflow tự động build APK release theo các bước:

1. ✅ Set up job
2. ✅ Checkout repository  
3. ✅ Setup Java JDK
4. ✅ Setup Flutter
5. ✅ Flutter doctor
6. ✅ Install dependencies
7. ✅ Clean and prepare project
8. ✅ Check Gradle setup
9. ✅ Build Release APK
10. ✅ Check APK exists
11. ✅ Upload Release APK
12. ✅ Create Release
13. ✅ Complete job

## Cài đặt và chạy

1. Clone repository
2. Chạy `flutter pub get` để cài đặt dependencies
3. Kết nối thiết bị Android hoặc khởi động emulator
4. Chạy `flutter run` để chạy app

## Build APK

### Build local:
```bash
flutter build apk --release
```

### Build qua GitHub Actions:
1. Push code lên GitHub
2. Actions sẽ tự động chạy
3. APK sẽ được upload như artifact

## Cấu hình secrets cho GitHub Actions

Để build được APK, cần thêm các secrets vào GitHub repository:

- `KEYSTORE_BASE64`: Keystore file được encode base64
- `KEYSTORE_PASSWORD`: Mật khẩu keystore
- `KEY_PASSWORD`: Mật khẩu key
- `KEY_ALIAS`: Tên alias của key

## Giao diện iOS

App được thiết kế để giống giao diện iOS Photos app:

- Navigation bar với title lớn
- Grid layout 3 cột
- Chế độ selection với checkmark
- Animation và transition mượt mà
- Màu sắc và typography giống iOS