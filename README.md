# 🍳 Cookly App

Aplikasi mobile Flutter untuk berbagi dan menemukan resep masakan. Cookly memudahkan pengguna untuk membuat resep baru, mencari resep favorit, dan mengelola profil mereka.

## 📱 Fitur Utama

### 🏠 Home Page

- **Resep Hari Ini** - Rekomendasi resep spesial setiap hari
- **Resep Populer** - Daftar resep yang paling dicari
- **Filter Kategori** - Filter resep berdasarkan kategori (Makanan/Minuman)
- **Pencarian** - Cari resep berdasarkan nama, deskripsi, atau kategori
- **Resep Minuman** - Koleksi minuman spesial

### 📖 Detail Resep

- Informasi lengkap resep (nama, deskripsi, durasi)
- Daftar bahan dengan jumlah
- Langkah-langkah memasak terperinci
- Daftar peralatan yang dibutuhkan
- Bagikan resep dengan teman

### ➕ Buat Resep Baru

- Upload foto resep
- Isi detail resep (judul, deskripsi, durasi)
- Pilih kategori resep
- Tambah bahan-bahan dengan jumlah
- Tambah langkah-langkah memasak
- Tambah peralatan yang dibutuhkan
- Simpan ke database

### ❤️ Resep Favorit

- Masih dalam bentuk ui saja belum fungsional

### 👤 Profil Pengguna

- **Edit Profil** - Ubah nama, username, dan foto profil
- **Upload Foto Profil** - Upload dan tampilkan foto dari Supabase Storage
- **Logout** - Keluar dari akun

## 🛠️ Tech Stack

### Frontend

- **Framework**: Flutter (Dart)
- **State Management**: setState (StatefulWidget)
- **UI Components**: Custom widgets, Material Design

### Backend

- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage
- **API**: Supabase REST API

### Packages Utama

```yaml
device_info_plus: ^10.1.0
flutter_dotenv: ^6.0.0
http: ^1.1.0
image_picker: ^1.2.0
logging: ^1.3.0
path_provider: ^2.0.0
permission_handler: ^11.3.1
supabase_flutter: ^2.10.3
```

## 📂 Struktur Project

```
cookly-app/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── app.dart                     # MyApp widget
│   ├── screen/                      # Halaman aplikasi
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── main_screen.dart         # Root navigation
│   │   ├── profile_screen.dart
│   │   ├── edit_profile_screen.dart
│   │   ├── favorite_screen.dart
│   │   ├── create_screen.dart
│   │   ├── content/
│   │   │   └── home_content.dart
│   │   └── detail/
│   │       ├── detail_content.dart
│   │       └── allrecipe_screen.dart
│   ├── widgets/
│   │   ├── components/              # UI components
│   │   │   ├── custom_navbar.dart
│   │   │   ├── custom_bottom_navbar.dart
│   │   │   ├── custom_text.dart
│   │   │   ├── image_picker.dart
│   │   │   └── ...
│   │   └── sections/                # Section widgets
│   │       ├── home/
│   │       ├── login/
│   │       └── create/
│   ├── data/
│   │   ├── models/                  # Data models
│   │   │   ├── recipes_model.dart
│   │   │   └── user_model.dart
│   │   └── repository/              # Data access layer
│   │       ├── recipes_repository.dart
│   │       ├── user_repository.dart
│   │       └── add_recipes_repository.dart
│   ├── services/
│   │   └── resep_services.dart      # Business logic
│   ├── theme/
│   │   └── app_color.dart           # Color constants
│   └── helper/
│       └── formatduration.dart      # Utility functions
├── test/
│   └── widget_test.dart
├── web/
│   └── index.html
├── public_schema.sql                # Posgresql
├── pubspec.yaml
├── .env.example
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio / VS Code
- Git

### Installation

1. **Clone Repository**

```bash
git clone https://github.com/yourusername/cookly-app.git
cd cookly-app
```

2. **Setup Environment**

```bash
# Copy .env.example ke .env
cp .env.example .env

# Edit .env dengan Supabase credentials
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_anon_key
```

3. **Install Dependencies**

```bash
flutter pub get
```

4. **Setup Supabase**

- Buat project di [Supabase](https://supabase.com)
- Buat bucket storage `profile-images` dan `recipes`
- Buat tabel:
  
  ```
  public_schema.sql
  ```

1. **Run App**

    ```bash
    flutter run 
    ```

## 📖 Penggunaan

### Login

- Buat akun dengan email dan password
- Atau login dengan akun yang sudah ada

### Home Page

- Lihat resep populer dan minuman
- Gunakan fitur cari untuk mencari resep
- Filter resep berdasarkan kategori

### Buat Resep

- Tekan tombol **+** di bottom navigation
- Isi semua data resep
- Upload foto resep
- Simpan resep

### Edit Profil

- Tekan tab **Profile** di bottom navigation
- Tekan tombol **Edit Profile**
- Ubah nama, username, dan/atau foto
- Simpan perubahan

### Favorit

-Masih dalam bentuk tampilan ui saja belum fungsional

### Gambar tidak tampil

- Pastikan bucket storage `profile-images` sudah **public**
- Pastikan bucket storage `recipes` sudah **public**
- Cek RLS Policy di Supabase
- Verifikasi URL gambar di browser

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan:

1. Fork repository ini
2. Buat branch feature (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buka Pull Request

## 👨‍💻 Author

**Muhammad Shirojul Munir**

- GitHub: [@ultramunnn](https://github.com/ultramunnn)
- Email: munir63577@gmail.com

**Sabilah Mudrikah**

- GitHub: [@xblbong](https://github.com/xblbong)
- Email: sblhh.m@gmail.com

**Agus Fathurahman Rifai**

- GitHub: [@spicythur](https://github.com/spicythur)

**Ignatius Christian**

- GitHub: [@christian030280-tech](https://github.com/christian030280-tech)
