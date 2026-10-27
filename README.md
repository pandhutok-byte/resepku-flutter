# ResepKu

ResepKu adalah aplikasi Flutter berbasis Dart untuk mencari resep makanan menggunakan [TheMealDB API](https://www.themealdb.com/docs_api_guide.php).

## Fitur

- Mencari resep berdasarkan nama makanan.
- Menampilkan kategori makanan.
- Memfilter daftar resep berdasarkan kategori.
- Melihat detail resep, gambar, kategori, asal masakan, bahan, takaran, dan instruksi.
- Menampilkan satu resep acak.
- Menampilkan status loading, pesan error, dan pesan ketika hasil pencarian kosong.

## Teknologi

- Flutter
- Dart
- Package `http`
- TheMealDB API V1 (test key `1`)

## Endpoint yang digunakan

- Search: `https://www.themealdb.com/api/json/v1/1/search.php?s=chicken`
- Categories: `https://www.themealdb.com/api/json/v1/1/categories.php`
- Filter category: `https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood`
- Meal details: `https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772`
- Random meal: `https://www.themealdb.com/api/json/v1/1/random.php`

## Struktur utama

```text
lib/
├── main.dart
├── model/
│   └── meal.dart
├── view/
│   ├── home.dart
│   └── detail.dart
└── viewmodel/
    └── fetchmeal.dart

test/
└── widget_test.dart
```

## Menjalankan aplikasi

Pastikan Flutter SDK telah terpasang. Dari folder project, jalankan:

```bash
flutter pub get
flutter run
```

Untuk menjalankan pada HP Android yang telah terhubung melalui USB Debugging:

```bash
flutter devices
flutter run -d <DEVICE_ID>
```

Ganti `<DEVICE_ID>` dengan ID perangkat Android yang muncul dari `flutter devices`.

## Pemeriksaan kode dan pengujian

```bash
flutter analyze
flutter test
```

Jalankan kedua perintah tersebut sebelum pengumpulan dan pastikan hasil terakhir sudah diperiksa.

## Membuat APK Android

```bash
flutter build apk --release
```

File APK akan tersedia di `build/app/outputs/flutter-apk/app-release.apk` setelah proses build berhasil.

## Catatan API

Project ini menggunakan test key `1` pada TheMealDB API V1 untuk pengembangan dan pembelajaran. Periksa dokumentasi dan ketentuan TheMealDB sebelum mendistribusikan aplikasi untuk penggunaan publik.

## Identitas tugas

- Mata kuliah: Pemrograman Mobile
- Nama aplikasi: ResepKu
- Pengembang: Pandhu Syach Aryanto
- NIM: 240605110002
