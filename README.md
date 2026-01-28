# Kalori Takip (Flutter Uygulaması)

Basit, cross-platform bir kalori takip uygulaması. Kullanıcılar kilo verme, kilo alma, formda kalma veya aktif fitness programları seçebilir ve kişiye özel diyet programları alabilir.

## Özellikler

- 🔐 **Firebase Authentication** - Email/şifre ile giriş ve kayıt
- 👤 **Kullanıcı Profili** - Boy, kilo, yaş ve doğum tarihi bilgileri
- 📋 **Program Seçimi** - Kilo verme, kilo alma, formda kalma, aktif fitness
- ❓ **Soru Ekranı** - Aktivite düzeyi, deneyim, adım sayısı, egzersiz türü vb.
- 🍽️ **Diyet Programı** - Kişiye özel diyet programları (AI destekli)
- 📷 **Kalori Tahmini** - Fotoğraftan yemek kalori tahmini
- 🌓 **Karanlık/Aydınlık Tema** - Kullanıcı tercihine göre tema
- 🌐 **Çoklu Dil** - Türkçe ve İngilizce desteği

## Teknolojiler

- **Flutter** - Cross-platform mobil geliştirme
- **Firebase** - Auth ve Firestore veritabanı
- **AI/ML** - OpenAI entegrasyonlu program üretimi
- **Localization** - flutter_localizations

## Kurulum

### 1. Flutter Bağımlılıklarını Yükleyin

```bash
flutter pub get
```

### 2. Firebase Yapılandırması

- [Firebase Console](https://console.firebase.google.com/) üzerinden proje oluşturun
- Android ve iOS uygulamalarını ekleyin
- `google-services.json` dosyasını `android/app/` klasörüne
- `GoogleService-Info.plist` dosyasını iOS Runner klasörüne ekleyin

### 3. Firebase Authentication

- Email/Şifre provider'ını etkinleştirin

### 4. Firestore Veritabanı

- Firestore veritabanı oluşturun
- Güvenlik kurallarını aşağıdaki gibi ayarlayın:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /programs/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /selectedPrograms/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /programAnswers/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 5. Backend Sunucusu (Opsiyonel - Mock Veri Dahil)

Fotoğraf tabanlı kalori tahmini ve AI program üretimi için backend gerekir:

```bash
cd functions
npm install
npm start
```

Not: Backend çalışmasa bile mock veriler döndürülür.

### 6. Uygulamayı Çalıştırın

```bash
flutter run
```

## Ekranlar

| Ekran | Açıklama |
|-------|----------|
| Login | Email/şifre ile giriş |
| Register | Yeni hesap oluşturma |
| Home | Hoş geldiniz ve menü |
| Programs | Program seçimi |
| Question | Kişiselleştirme soruları |
| Diet Programs | Önerilen diyet programları |
| My Programs | Seçilen program detayları |
| Profile | Kullanıcı bilgileri |
| Settings | Tema, dil, çıkış |
| Camera | Fotoğraf ile kalori tahmini |

## API Yapılandırması

`lib/services/ai_service.dart` dosyasında API URL'lerini güncelleyebilirsiniz:

- **iOS Simulator**: `http://localhost:3000`
- **Android Emulator**: `http://10.0.2.2:3000`
- **Production**: Cloud Function URL'nizi girin

Gerekli environment variable'lar:
- `OPENAI_API_KEY` veya `LLM_API_KEY`
- `NUTRITIONIX_APP_ID`, `NUTRITIONIX_APP_KEY` (fotoğraf için)

## Proje Yapısı

```
lib/
├── main.dart           # App başlangıcı
├── theme.dart          # Tema yapılandırması
├── models/
│   └── user_profile.dart
├── services/
│   ├── ai_service.dart
│   ├── auth_service.dart
│   ├── firebase_service.dart
│   ├── user_service.dart
│   └── ...
├── screens/
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── programs_screen.dart
│   ├── program_question_screen.dart
│   ├── diet_programs_selection_screen.dart
│   ├── my_programs_screen.dart
│   ├── profile_screen.dart
│   ├── settings_screen.dart
│   └── camera_screen.dart
├── widgets/
│   └── app_scaffold.dart
└── l10n/
    └── app_localizations.dart
```

## Notlar

- Bu bir prototip uygulamadır
- Fotoğraf işleme için Google Vision, Clarifai veya benzeri API'lar kullanılabilir
- AI program üretimi için OpenAI veya alternatif LLM servisleri entegre edilebilir

## Lisans

MIT License

