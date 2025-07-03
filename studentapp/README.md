# studentapp

# Student Manager Flutter App

Ứng dụng quản lý sinh viên được phát triển bằng Flutter, kết nối với backend Spring Boot.

## ✅ Trạng thái hoàn thành

- ✅ **Cấu trúc dự án**: Đã tạo đầy đủ thư mục theo chuẩn development
- ✅ **Models**: Student, Subject, Grade với toJSON/fromJSON
- ✅ **Services**: API client sử dụng HttpClient
- ✅ **Controllers**: State management với ChangeNotifier
- ✅ **Views**: Màn hình CRUD cho tất cả entities
- ✅ **Widgets**: Components tái sử dụng (loading, error, cards)
- ✅ **Utils**: Validation, formatting, dialog helpers
- ✅ **Routes**: Navigation system hoàn chỉnh
- ✅ **Theme**: Material Design custom theme
- ✅ **Tests**: Widget tests cơ bản đã pass
- ✅ **Documentation**: README chi tiết

### Tính năng đã hoàn thành

- **Quản lý sinh viên**: Thêm, sửa, xóa, tìm kiếm
- **Quản lý môn học**: Thêm, sửa, xóa, tìm kiếm  
- **Quản lý điểm**: Thêm, sửa, xóa, tìm kiếm
- **Validation**: Form validation cho tất cả input
- **Error handling**: Xử lý lỗi và hiển thị thông báo
- **Loading states**: Loading indicators khi gọi API
- **Empty states**: Hiển thị khi không có dữ liệu

## Cấu trúc dự án

```
lib/
├── main.dart                   # Entry point
├── config/                    # Cấu hình chung
│   ├── app_config.dart        # Cấu hình API và constants
│   └── app_theme.dart         # Theme và màu sắc
├── models/                    # Mô hình dữ liệu
│   ├── student_model.dart     # Model sinh viên
│   ├── subject_model.dart     # Model môn học
│   ├── grade_model.dart       # Model điểm
│   └── models.dart           # Export tất cả models
├── views/                     # Giao diện người dùng
│   ├── screens/               # Các màn hình
│   │   ├── home_screen.dart
│   │   ├── students_screen.dart
│   │   ├── subjects_screen.dart
│   │   ├── grades_screen.dart
│   │   └── screens.dart
│   └── widgets/               # Các widget tái sử dụng
│       ├── loading_widget.dart
│       ├── error_widget.dart
│       ├── empty_state_widget.dart
│       ├── student_card.dart
│       ├── subject_card.dart
│       ├── grade_card.dart
│       └── widgets.dart
├── controllers/               # Controller xử lý logic
│   ├── student_controller.dart
│   ├── subject_controller.dart
│   ├── grade_controller.dart
│   └── controllers.dart
├── services/                  # Service gọi API
│   ├── api_service.dart
│   ├── student_service.dart
│   ├── subject_service.dart
│   ├── grade_service.dart
│   └── services.dart
├── utils/                     # Helper, format, validation
│   ├── validators.dart
│   ├── formatters.dart
│   ├── dialog_utils.dart
│   └── utils.dart
└── routes/                    # Khai báo router
    └── app_routes.dart
```

## Tính năng

### 1. Quản lý Sinh viên
- ✅ Xem danh sách sinh viên
- ✅ Thêm sinh viên mới
- ✅ Sửa thông tin sinh viên
- ✅ Xóa sinh viên
- ✅ Tìm kiếm sinh viên theo tên

### 2. Quản lý Môn học
- ✅ Xem danh sách môn học
- ✅ Thêm môn học mới
- ✅ Sửa thông tin môn học
- ✅ Xóa môn học
- ✅ Tìm kiếm môn học theo tên

### 3. Quản lý Điểm số
- ✅ Xem danh sách điểm
- ✅ Thêm điểm mới
- ✅ Sửa điểm
- ✅ Xóa điểm
- ✅ Hiển thị điểm với màu sắc theo mức độ

## Cài đặt và chạy

### 1. Yêu cầu hệ thống
- Flutter SDK >= 3.8.1
- Dart SDK >= 3.8.1
- Android Studio hoặc VS Code
- Backend API đang chạy tại `http://localhost:8080`

### 2. Cài đặt dependencies
```bash
flutter pub get
```

### 3. Cấu hình API
Mở file `lib/config/app_config.dart` và cập nhật URL API:
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

### 4. Chạy ứng dụng
```bash
flutter run
```

## API Endpoints được sử dụng

### Students
- `GET /api/students` - Lấy danh sách sinh viên
- `GET /api/students/{id}` - Lấy thông tin sinh viên theo ID
- `POST /api/students` - Tạo sinh viên mới
- `PUT /api/students/{id}` - Cập nhật sinh viên
- `DELETE /api/students/{id}` - Xóa sinh viên
- `GET /api/students/search?name={name}` - Tìm kiếm sinh viên
- `GET /api/students/birth-year/{year}` - Lấy sinh viên theo năm sinh

### Subjects
- `GET /api/subjects` - Lấy danh sách môn học
- `GET /api/subjects/{id}` - Lấy thông tin môn học theo ID
- `POST /api/subjects` - Tạo môn học mới
- `PUT /api/subjects/{id}` - Cập nhật môn học
- `DELETE /api/subjects/{id}` - Xóa môn học
- `GET /api/subjects/search?name={name}` - Tìm kiếm môn học

### Grades
- `GET /api/grades` - Lấy danh sách điểm
- `GET /api/grades/{id}` - Lấy thông tin điểm theo ID
- `POST /api/grades` - Tạo điểm mới
- `PUT /api/grades/{id}` - Cập nhật điểm
- `DELETE /api/grades/{id}` - Xóa điểm
- `GET /api/grades/student/{studentId}` - Lấy điểm theo sinh viên
- `GET /api/grades/subject/{subjectId}` - Lấy điểm theo môn học

## Kiến trúc

Ứng dụng được xây dựng theo mô hình MVC:

- **Models**: Định nghĩa cấu trúc dữ liệu (Student, Subject, Grade)
- **Views**: Giao diện người dùng (Screens và Widgets)
- **Controllers**: Quản lý trạng thái và logic nghiệp vụ
- **Services**: Xử lý việc gọi API
- **Utils**: Các hàm tiện ích (validation, formatting, dialogs)

## Lưu ý

1. **Kết nối Backend**: Đảm bảo backend API đang chạy và có thể truy cập được
2. **CORS**: Backend cần cấu hình CORS để cho phép Flutter app truy cập
3. **Validation**: Tất cả input đều được validate trước khi gửi lên server
4. **Error Handling**: App có xử lý lỗi và hiển thị thông báo phù hợp
5. **UI/UX**: Giao diện được thiết kế đơn giản, dễ sử dụng với Material Design

## Phát triển thêm

Một số tính năng có thể bổ sung:
- [ ] Xem chi tiết sinh viên với danh sách điểm
- [ ] Xem chi tiết môn học với danh sách điểm
- [ ] Thống kê điểm trung bình
- [ ] Export dữ liệu ra Excel/PDF
- [ ] Dark mode
- [ ] Đa ngôn ngữ
- [ ] Authentication
- [ ] Push notifications

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
