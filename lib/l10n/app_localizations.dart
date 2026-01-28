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
      'profile_subtitle': 'Manage your personal info',
      'settings_subtitle': 'App preferences and settings',
      'name': 'Name',
      'edit': 'Edit',
      'light_mode': 'Light Mode',
      'dark_mode': 'Dark Mode',
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

      /* 🔽 PROGRAM QUESTIONS */
      'question_screen_title': 'Questions',
      'continue': 'Continue',
      'yes': 'Yes',
      'no': 'No',
      'required_field': 'Required',
      'user_not_found_error': 'User session not found!',
      'diet_generation_error': 'Diet programs could not be generated. Please try again.',
      'error_occurred': 'Error occurred: ',

      /* 🔽 LOSE PROGRAM QUESTIONS */
      'lose_active_question': 'Are you physically active in your daily life?',
      'lose_steps_question': 'What is your average daily step count?',
      'lose_meals_question': 'How many meals do you eat per day?',
      'lose_restriction_question': 'Do you have any dietary restrictions?',
      'lose_sleep_question': 'How is your sleep pattern?',
      'lose_health_question': 'Do you have any health problems?',
      'lose_sleep_good': 'Good',
      'lose_sleep_moderate': 'Moderate',
      'lose_sleep_bad': 'Bad',
      'lose_goal_question': 'What is your goal?',

      /* 🔽 GAIN PROGRAM QUESTIONS */
      'gain_activity_level_question': 'What is your daily activity level?',
      'gain_meals_question': 'How many meals do you eat per day?',
      'gain_restriction_question': 'Do you have any dietary restrictions?',
      'gain_health_question': 'Do you have any health problems?',
      'activity_low': 'Low',
      'activity_medium': 'Medium',
      'activity_high': 'High',

      /* 🔽 MAINTAIN PROGRAM QUESTIONS */
      'maintain_activity_level_question': 'What is your daily activity level?',
      'maintain_meals_question': 'How many meals do you eat per day?',
      'maintain_restriction_question': 'Do you have any dietary restrictions?',

      /* 🔽 FITNESS PROGRAM QUESTIONS */
      'fitness_sport_days_question': 'How many days per week do you exercise?',
      'fitness_sport_type_question': 'What sports do you do?',
      'fitness_goal_question': 'What is your goal?',
      'fitness_goal_muscle': 'Muscle',
      'fitness_goal_endurance': 'Endurance',
      'fitness_goal_weight': 'Weight',
      'fitness_goal_other': 'Other',

      /* 🔽 DIET RESTRICTIONS */
      'restriction_lactose_free': 'Lactose-free',
      'restriction_gluten_free': 'Gluten-free',
      'restriction_vegan': 'Vegan',
      'restriction_vegetarian': 'Vegetarian',
      'restriction_none': 'None',
      'restriction_other': 'Other',

      /* 🔽 MEAL OPTIONS */
      'meals_2': '2',
      'meals_3': '3',
      'meals_4': '4',
      'meals_5_plus': '5+',

      /* 🔽 NEW MULTIPLE CHOICE QUESTIONS */
      'activity_level': 'What is your activity level?',
      'experience_level': 'What is your experience level?',
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',
      'daily_steps': 'How many steps do you take daily?',
      'steps_less_3000': 'Less than 3,000',
      'steps_3000_5000': '3,000 - 5,000',
      'steps_5000_8000': '5,000 - 8,000',
      'steps_8000_10000': '8,000 - 10,000',
      'steps_more_10000': 'More than 10,000',
      'workout_type': 'What type of workout do you prefer?',
      'workout_strength': 'Strength Training',
      'workout_cardio': 'Cardio',
      'workout_both': 'Both',
      'workout_home': 'Home',
      'workout_gym': 'Gym',
      'equipment_none': 'No Equipment',
      'primary_goal': 'What is your primary goal?',
      'goal_lose_weight': 'Lose Weight',
      'goal_build_muscle': 'Build Muscle',
      'goal_improve_endurance': 'Improve Endurance',
      'goal_stay_healthy': 'Stay Healthy',
      'current_eating_habits': 'How would you describe your current eating habits?',
      'eating_healthy': 'Healthy',
      'eating_moderate': 'Moderate',
      'eating_unhealthy': 'Needs Improvement',
      'water_intake': 'How much water do you drink daily?',
      'water_less_1L': 'Less than 1L',
      'water_1_2L': '1-2 Liters',
      'water_2_3L': '2-3 Liters',
      'water_more_3L': 'More than 3L',
      'stress_level': 'How would you rate your stress level?',
      'stress_low': 'Low',
      'stress_medium': 'Medium',
      'stress_high': 'High',
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
      'profile_subtitle': 'Kişisel bilgilerinizi yönetin',
      'settings_subtitle': 'Uygulama tercihleri ve ayarları',
      'name': 'İsim',
      'edit': 'Düzenle',
      'light_mode': 'Açık Mod',
      'dark_mode': 'Koyu Mod',
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

      /* 🔽 PROGRAM QUESTIONS */
      'question_screen_title': 'Sorular',
      'continue': 'Devam',
      'yes': 'Evet',
      'no': 'Hayır',
      'required_field': 'Zorunlu',
      'user_not_found_error': 'Kullanıcı oturumu bulunamadı!',
      'diet_generation_error': 'Diyet programları oluşturulamadı. Lütfen tekrar deneyin.',
      'error_occurred': 'Hata oluştu: ',

      /* 🔽 LOSE PROGRAM QUESTIONS */
      'lose_active_question': 'Yaşantında aktif hareket ediyor musun?',
      'lose_steps_question': 'Günlük ortalama kaç adım atıyorsun?',
      'lose_meals_question': 'Günde kaç öğün yiyorsun?',
      'lose_restriction_question': 'Diyet kısıtlaman var mı?',
      'lose_sleep_question': 'Uyku düzenin nasıl?',
      'lose_health_question': 'Sağlık problemi var mı?',
      'lose_sleep_good': 'İyi',
      'lose_sleep_moderate': 'Orta',
      'lose_sleep_bad': 'Kötü',
      'lose_goal_question': 'Hedefin nedir?',

      /* 🔽 GAIN PROGRAM QUESTIONS */
      'gain_activity_level_question': 'Günlük hareket seviyen nedir?',
      'gain_meals_question': 'Günde kaç öğün yiyorsun?',
      'gain_restriction_question': 'Diyet kısıtlaman var mı?',
      'gain_health_question': 'Sağlık problemi var mı?',
      'activity_low': 'Düşük',
      'activity_medium': 'Orta',
      'activity_high': 'Yüksek',

      /* 🔽 MAINTAIN PROGRAM QUESTIONS */
      'maintain_activity_level_question': 'Günlük hareket seviyen nedir?',
      'maintain_meals_question': 'Günde kaç öğün yiyorsun?',
      'maintain_restriction_question': 'Diyet kısıtlaman var mı?',

      /* 🔽 FITNESS PROGRAM QUESTIONS */
      'fitness_sport_days_question': 'Haftada kaç gün spor yapıyorsun?',
      'fitness_sport_type_question': 'Hangi sporları yapıyorsun?',
      'fitness_goal_question': 'Hedefin nedir?',
      'fitness_goal_muscle': 'Kas',
      'fitness_goal_endurance': 'Dayanıklılık',
      'fitness_goal_weight': 'Kilo',
      'fitness_goal_other': 'Diğer',

      /* 🔽 DIET RESTRICTIONS */
      'restriction_lactose_free': 'Laktozsuz',
      'restriction_gluten_free': 'Glutensiz',
      'restriction_vegan': 'Vegan',
      'restriction_vegetarian': 'Vejetaryen',
      'restriction_none': 'Yok',
      'restriction_other': 'Diğer',

      /* 🔽 MEAL OPTIONS */
      'meals_2': '2',
      'meals_3': '3',
      'meals_4': '4',
      'meals_5_plus': '5+',

      /* 🔽 NEW MULTIPLE CHOICE QUESTIONS */
      'activity_level': 'Aktivite seviyen nedir?',
      'experience_level': 'Deneyim seviyen nedir?',
      'beginner': 'Başlangıç',
      'intermediate': 'Orta',
      'advanced': 'İleri',
      'daily_steps': 'Günlük kaç adım atıyorsun?',
      'steps_less_3000': '3.000\'den az',
      'steps_3000_5000': '3.000 - 5.000',
      'steps_5000_8000': '5.000 - 8.000',
      'steps_8000_10000': '8.000 - 10.000',
      'steps_more_10000': '10.000\'den fazla',
      'workout_type': 'Hangi tür çalışmayı tercih edersin?',
      'workout_strength': 'Kuvvet Antrenmanı',
      'workout_cardio': 'Kardiyo',
      'workout_both': 'İkisi de',
      'workout_home': 'Ev',
      'workout_gym': 'Spor Salonu',
      'equipment_none': 'Ekipmansız',
      'primary_goal': 'Temel hedefin nedir?',
      'goal_lose_weight': 'Kilo Ver',
      'goal_build_muscle': 'Kas Yap',
      'goal_improve_endurance': 'Dayanıklılık Kazan',
      'goal_stay_healthy': 'Sağlıklı Kal',
      'current_eating_habits': 'Mevcut beslenme alışkanlıklarını nasıl tanımlarsın?',
      'eating_healthy': 'Sağlıklı',
      'eating_moderate': 'Orta',
      'eating_unhealthy': 'İyileştirmeye Gerek Var',
      'water_intake': 'Günde ne kadar su içiyorsun?',
      'water_less_1L': '1 Litreden az',
      'water_1_2L': '1-2 Litre',
      'water_2_3L': '2-3 Litre',
      'water_more_3L': '3 Litreden fazla',
      'stress_level': 'Stres seviyeni nasıl değerlendirirsin?',
      'stress_low': 'Düşük',
      'stress_medium': 'Orta',
      'stress_high': 'Yüksek',
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
  String get profileSubtitle => _t('profile_subtitle');
  String get settingsSubtitle => _t('settings_subtitle');
  String get name => _t('name');
  String get edit => _t('edit');
  String get lightMode => _t('light_mode');
  String get darkMode => _t('dark_mode');
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
  String get questionScreenTitle => _t('question_screen_title');
  String get continueBtn => _t('continue');
  String get yes => _t('yes');
  String get no => _t('no');
  String get requiredField => _t('required_field');
  String get userNotFoundError => _t('user_not_found_error');
  String get dietGenerationError => _t('diet_generation_error');
  String get errorOccurred => _t('error_occurred');

  // Lose program questions
  String get loseActiveQuestion => _t('lose_active_question');
  String get loseStepsQuestion => _t('lose_steps_question');
  String get loseMealsQuestion => _t('lose_meals_question');
  String get loseRestrictionQuestion => _t('lose_restriction_question');
  String get loseSleepQuestion => _t('lose_sleep_question');
  String get loseHealthQuestion => _t('lose_health_question');
  String get loseSleepGood => _t('lose_sleep_good');
  String get loseSleepModerate => _t('lose_sleep_moderate');
  String get loseSleepBad => _t('lose_sleep_bad');
  String get loseGoalQuestion => _t('lose_goal_question');

  // Gain program questions
  String get gainActivityLevelQuestion => _t('gain_activity_level_question');
  String get gainMealsQuestion => _t('gain_meals_question');
  String get gainRestrictionQuestion => _t('gain_restriction_question');
  String get gainHealthQuestion => _t('gain_health_question');
  String get activityLow => _t('activity_low');
  String get activityMedium => _t('activity_medium');
  String get activityHigh => _t('activity_high');

  // Maintain program questions
  String get maintainActivityLevelQuestion => _t('maintain_activity_level_question');
  String get maintainMealsQuestion => _t('maintain_meals_question');
  String get maintainRestrictionQuestion => _t('maintain_restriction_question');

  // Fitness program questions
  String get fitnessSportDaysQuestion => _t('fitness_sport_days_question');
  String get fitnessSportTypeQuestion => _t('fitness_sport_type_question');
  String get fitnessGoalQuestion => _t('fitness_goal_question');
  String get fitnessGoalMuscle => _t('fitness_goal_muscle');
  String get fitnessGoalEndurance => _t('fitness_goal_endurance');
  String get fitnessGoalWeight => _t('fitness_goal_weight');
  String get fitnessGoalOther => _t('fitness_goal_other');

  // Diet restrictions
  String get restrictionLactoseFree => _t('restriction_lactose_free');
  String get restrictionGlutenFree => _t('restriction_gluten_free');
  String get restrictionVegan => _t('restriction_vegan');
  String get restrictionVegetarian => _t('restriction_vegetarian');
  String get restrictionNone => _t('restriction_none');
  String get restrictionOther => _t('restriction_other');

  // Meal options
  String get meals2 => _t('meals_2');
  String get meals3 => _t('meals_3');
  String get meals4 => _t('meals_4');
  String get meals5Plus => _t('meals_5_plus');

  // New multiple choice questions
  String get activityLevel => _t('activity_level');
  String get experienceLevel => _t('experience_level');
  String get beginner => _t('beginner');
  String get intermediate => _t('intermediate');
  String get advanced => _t('advanced');
  String get dailySteps => _t('daily_steps');
  String get stepsLess3000 => _t('steps_less_3000');
  String get steps30005000 => _t('steps_3000_5000');
  String get steps50008000 => _t('steps_5000_8000');
  String get steps800010000 => _t('steps_8000_10000');
  String get stepsMore10000 => _t('steps_more_10000');
  String get workoutType => _t('workout_type');
  String get workoutStrength => _t('workout_strength');
  String get workoutCardio => _t('workout_cardio');
  String get workoutBoth => _t('workout_both');
  String get workoutHome => _t('workout_home');
  String get workoutGym => _t('workout_gym');
  String get equipmentNone => _t('equipment_none');
  String get primaryGoal => _t('primary_goal');
  String get goalLoseWeight => _t('goal_lose_weight');
  String get goalBuildMuscle => _t('goal_build_muscle');
  String get goalImproveEndurance => _t('goal_improve_endurance');
  String get goalStayHealthy => _t('goal_stay_healthy');
  String get currentEatingHabits => _t('current_eating_habits');
  String get eatingHealthy => _t('eating_healthy');
  String get eatingModerate => _t('eating_moderate');
  String get eatingUnhealthy => _t('eating_unhealthy');
  String get waterIntake => _t('water_intake');
  String get waterLess1L => _t('water_less_1L');
  String get water1_2L => _t('water_1_2L');
  String get water2_3L => _t('water_2_3L');
  String get waterMore3L => _t('water_more_3L');
  String get stressLevel => _t('stress_level');
  String get stressLow => _t('stress_low');
  String get stressMedium => _t('stress_medium');
  String get stressHigh => _t('stress_high');

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
