# Kalori Takip (Flutter prototype)

Basit, cross-platform bir kalori takip uygulaması—AI entegrasyonlu prototip.

Bu repo temel bir scaffold içerir ve aşağıdaki bileşenleri hedefler:
- Kullanıcı profili, program seçimi (kilo verme / kilo alma / aktif vs sedanter)
- Fotoğraf tabanlı yemek kalori tahmini (arka uç fonksiyonu + üçüncü parti API)
- Firebase entegrasyonu (Auth, Firestore, Storage)
- OpenAI benzeri bir servisle kişiye özel program üretimi

Ön gereksinimler
- Flutter SDK
- Firebase projesi (API anahtarları ve konfigürasyon)
- Bir backend endpoint (Cloud Function veya benzeri) fotoğraf -> kalori dönüşümü için

Çalıştırma (geliştirme)

1) Flutter bağımlılıklarını yükleyin:

```bash
flutter pub get
```

2) Firebase yapılandırmasını ekleyin (Android/iOS için `google-services.json` / `GoogleService-Info.plist`).

3) Uygulamayı çalıştırın:

```bash
flutter run
```

Notlar
- AI servisleri için `lib/services/ai_service.dart` içinde placeholder URL'ler var. Bu URL'leri kendi Cloud Function veya API anahtarlarınızla değiştirin.
- Bu bir prototip. Görüntü sınıflandırma için Google Vision / Clarifai / custom model kullanılabilir.
