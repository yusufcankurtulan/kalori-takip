import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'home_title': 'Calorie Tracker',
      'menu_profile_title': 'Profile & Programs',
      'menu_profile_desc': 'Manage your personal information',
      'programs_title': 'Programs',
      'programs_desc': 'Choose a program for your goals',
      'menu_camera_title': 'Photo Calorie Estimate',
      'menu_camera_desc': 'Analyze food using your camera',
      'menu_records_title': 'My Daily Records',
      'menu_records_desc': 'Coming soon!',
      'home_subtitle': 'Start your healthy journey',

      'profile_header_title': 'Profile Details',
      'profile_header_subtitle': 'Share basic info for a healthier life',
      'save_and_continue': 'Save and Continue',
      'enter_valid_height': 'Enter a valid height',
      'enter_valid_weight': 'Enter a valid weight',
      'enter_valid_age': 'Enter a valid age',
      'user_not_found': 'User not found.',
      'profile_save_error': 'Error saving profile.',
      'language': 'Language',
      'theme': 'Theme',
      'gender_male': 'Male',
      'gender_female': 'Female',
      'gender_other': 'Other',

      'profile_title': 'My Profile',
      'settings_title': 'Settings',
      'welcome': 'Welcome!',
      'user_info': 'User Information',
      'logout': 'Sign Out',
      'age': 'Age',
      'weight': 'Weight (kg)',
      'height': 'Height (cm)',
      'gender': 'Gender',
      'profile_not_set': 'Not set yet',

      /* 🔽 MY PROGRAMS – NEW */
      'my_programs_title': 'My Programs',
      'no_program_title': 'No program selected yet',
      'no_program_description': 'Select a program to create a personalized diet plan',
      'select_program': 'Select Program',
      'select_new_program': 'Select New Program',
      'default_diet_program': 'Diet Program',
      'daily_calories': 'Daily Calories',
      'nutrition_targets': 'Nutrition Targets',
      'protein': 'Protein',
      'carbohydrate': 'Carbohydrate',
      'fat': 'Fat',
      'daily_meal_plan': 'Daily Meal Plan',
      'breakfast': 'Breakfast',
      'lunch': 'Lunch',
      'dinner': 'Dinner',
      'snack': 'Snack',
      'weekly_plan': 'Weekly Plan',
      'tips_and_suggestions': 'Tips & Suggestions',
      'warning': 'Warning',
    },

    'tr': {
      'home_title': 'Kalori Takip',
      'menu_profile_title': 'Profil & Programlar',
      'menu_profile_desc': 'Kişisel bilgilerinizi yönetin',
      'programs_title': 'Programlar',
      'programs_desc': 'Hedeflerinize uygun program seçin',
      'menu_camera_title': 'Fotoğrafla Kalori Tahmini',
      'menu_camera_desc': 'Kameranızla yiyecek analizi yapın',
      'menu_records_title': 'Günlük Kayıtlarım',
      'menu_records_desc': 'Yakında gelecek (çok yakında!)',
      'home_subtitle': 'Sağlıklı yaşam yolculuğunuzu başlatın',

      'profile_header_title': 'Profil Bilgileri',
      'profile_header_subtitle': 'Sağlıklı yaşam için temel bilgileri paylaş',
      'save_and_continue': 'Kaydet ve Devam Et',
      'enter_valid_height': 'Geçerli bir boy girin',
      'enter_valid_weight': 'Geçerli bir kilo girin',
      'enter_valid_age': 'Geçerli bir yaş girin',
      'user_not_found': 'Kullanıcı bulunamadı.',
      'profile_save_error': 'Profil kaydedilirken hata oluştu.',
      'language': 'Dil',
      'theme': 'Tema',
      'gender_male': 'Erkek',
      'gender_female': 'Kadın',
      'gender_other': 'Diğer',

      'profile_title': 'Profilim',
      'settings_title': 'Ayarlar',
      'welcome': 'Hoşgeldiniz!',
      'user_info': 'Kullanıcı Bilgileri',
      'logout': 'Çıkış Yap',
      'age': 'Yaş',
      'weight': 'Kilo (kg)',
      'height': 'Boy (cm)',
      'gender': 'Cinsiyet',
      'profile_not_set': 'Henüz ayarlanmadı',

      /* 🔽 MY PROGRAMS – NEW */
      'my_programs_title': 'Programlarım',
      'no_program_title': 'Henüz bir program seçmediniz',
      'no_program_description': 'Size özel bir diyet programı oluşturmak için program seçin',
      'select_program': 'Program Seç',
      'select_new_program': 'Yeni Program Seç',
      'default_diet_program': 'Diyet Programı',
      'daily_calories': 'Günlük Kalori',
      'nutrition_targets': 'Besin Değerleri Hedefi',
      'protein': 'Protein',
      'carbohydrate': 'Karbonhidrat',
      'fat': 'Yağ',
      'daily_meal_plan': 'Günlük Öğün Planı',
      'breakfast': 'Sabah',
      'lunch': 'Öğle',
      'dinner': 'Akşam',
      'snack': 'Ara Öğün',
      'weekly_plan': 'Haftalık Plan',
      'tips_and_suggestions': 'İpuçları ve Öneriler',
      'warning': 'Dikkat',
    }
  };

  String _t(String key) {
    final code = locale.languageCode;
    final map = _localizedValues[code] ?? _localizedValues['tr']!;
    return map[key] ?? key;
  }

  String get homeTitle => _t('home_title');
  String get menuProfileTitle => _t('menu_profile_title');
  String get menuProfileDesc => _t('menu_profile_desc');
  String get menuCameraTitle => _t('menu_camera_title');
  String get menuCameraDesc => _t('menu_camera_desc');
  String get menuRecordsTitle => _t('menu_records_title');
  String get menuRecordsDesc => _t('menu_records_desc');
  String get programsTitle => _t('programs_title');
  String get programsDesc => _t('programs_desc');
  String get homeSubtitle => _t('home_subtitle');

  String get profileHeaderTitle => _t('profile_header_title');
  String get profileHeaderSubtitle => _t('profile_header_subtitle');
  String get saveAndContinue => _t('save_and_continue');
  String get enterValidHeight => _t('enter_valid_height');
  String get enterValidWeight => _t('enter_valid_weight');
  String get enterValidAge => _t('enter_valid_age');
  String get userNotFound => _t('user_not_found');
  String get profileSaveError => _t('profile_save_error');
  String get language => _t('language');
  String get theme => _t('theme');
  String get genderMale => _t('gender_male');
  String get genderFemale => _t('gender_female');
  String get genderOther => _t('gender_other');

  String get profileTitle => _t('profile_title');
  String get settingsTitle => _t('settings_title');
  String get welcome => _t('welcome');
  String get userInfo => _t('user_info');
  String get logout => _t('logout');
  String get age => _t('age');
  String get weight => _t('weight');
  String get height => _t('height');
  String get gender => _t('gender');
  String get profileNotSet => _t('profile_not_set');

  /* 🔽 MY PROGRAMS GETTERS */
  String get myProgramsTitle => _t('my_programs_title');
  String get noProgramTitle => _t('no_program_title');
  String get noProgramDescription => _t('no_program_description');
  String get selectProgram => _t('select_program');
  String get selectNewProgram => _t('select_new_program');
  String get defaultDietProgram => _t('default_diet_program');
  String get dailyCalories => _t('daily_calories');
  String get nutritionTargets => _t('nutrition_targets');
  String get protein => _t('protein');
  String get carbohydrate => _t('carbohydrate');
  String get fat => _t('fat');
  String get dailyMealPlan => _t('daily_meal_plan');
  String get breakfast => _t('breakfast');
  String get lunch => _t('lunch');
  String get dinner => _t('dinner');
  String get snack => _t('snack');
  String get weeklyPlan => _t('weekly_plan');
  String get tipsAndSuggestions => _t('tips_and_suggestions');
  String get warning => _t('warning');

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['tr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
