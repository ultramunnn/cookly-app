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
  4. **Setup Supabase**

  ```

- Buat project di [Supabase](https://supabase.com)
- Buat bucket storage `profile-images` dan `recipes`
- Buat tabel:
  -- WARNING: This schema is for context only and is not meant to be run.
  -- Table order and constraints may not be valid for execution.

```
    CREATE TABLE public.bahan (
    bahan_id integer NOT NULL DEFAULT nextval('bahan_bahan_id_seq'::regclass),
    nama_bahan text NOT NULL,
    CONSTRAINT bahan_pkey PRIMARY KEY (bahan_id)
    );

    CREATE TABLE public.kategori (
    kategori_id integer NOT NULL DEFAULT nextval('kategori_kategori_id_seq'::regclass),
    nama_kategori text NOT NULL,
    CONSTRAINT kategori_pkey PRIMARY KEY (kategori_id)
    );

    CREATE TABLE public.langkah_resep (
    langkah_id integer NOT NULL DEFAULT nextval('langkah_resep_langkah_id_seq'::regclass),
    resep_id integer,
    urutan integer NOT NULL,
    deskripsi text NOT NULL,
    CONSTRAINT langkah_resep_pkey PRIMARY KEY (langkah_id),
    CONSTRAINT langkah_resep_resep_id_fkey FOREIGN KEY (resep_id) REFERENCES public.resep(resep_id)
    );

    CREATE TABLE public.peralatan (
    peralatan_id integer NOT NULL DEFAULT nextval('peralatan_peralatan_id_seq'::regclass),
    nama_peralatan text NOT NULL,
    CONSTRAINT peralatan_pkey PRIMARY KEY (peralatan_id)
    );

    CREATE TABLE public.profiles (
    id uuid NOT NULL,
    nama text,
    username text UNIQUE,
    created_at timestamp without time zone DEFAULT now(),
    gambar_url text,
    CONSTRAINT profiles_pkey PRIMARY KEY (id),
    CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
    );

    CREATE TABLE public.resep (
    resep_id integer NOT NULL DEFAULT nextval('resep_resep_id_seq'::regclass),
    judul text NOT NULL,
    deskripsi text,
    durasi integer,
    kategori_id integer,
    user_id uuid,
    tanggal_upload timestamp without time zone DEFAULT now(),
    is_public boolean DEFAULT true,
    gambar_url text,
    CONSTRAINT resep_pkey PRIMARY KEY (resep_id),
    CONSTRAINT resep_kategori_id_fkey FOREIGN KEY (kategori_id) REFERENCES public.kategori(kategori_id),
    CONSTRAINT resep_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
    );

    CREATE TABLE public.resep_bahan (
    resep_id integer NOT NULL,
    bahan_id integer NOT NULL,
    jumlah text,
    CONSTRAINT resep_bahan_pkey PRIMARY KEY (resep_id, bahan_id),
    CONSTRAINT resep_bahan_resep_id_fkey FOREIGN KEY (resep_id) REFERENCES public.resep(resep_id),
    CONSTRAINT resep_bahan_bahan_id_fkey FOREIGN KEY (bahan_id) REFERENCES public.bahan(bahan_id)
    );

    CREATE TABLE public.resep_peralatan (
    resep_id integer NOT NULL,
    peralatan_id integer NOT NULL,
    CONSTRAINT resep_peralatan_pkey PRIMARY KEY (resep_id, peralatan_id),
    CONSTRAINT resep_peralatan_resep_id_fkey FOREIGN KEY (resep_id) REFERENCES public.resep(resep_id),
    CONSTRAINT resep_peralatan_peralatan_id_fkey FOREIGN KEY (peralatan_id) REFERENCES public.peralatan(peralatan_id)
    );
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
