import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../widgets/app_scaffold.dart';
import '../l10n/app_localizations.dart';
import 'programs_screen.dart';

class MyProgramsScreen extends StatefulWidget {
  @override
  State<MyProgramsScreen> createState() => _MyProgramsScreenState();
}

class _MyProgramsScreenState extends State<MyProgramsScreen> {
  Map<String, dynamic>? _selectedProgram;
  String? _programKey;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgram();
  }

  Future<void> _loadProgram() async {
    setState(() => _loading = true);
    final uid = AuthService.currentUser?.uid;
    if (uid == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      _programKey = await UserService.getProgram(uid);
      if (_programKey != null) {
        _selectedProgram = await UserService.getSelectedDietProgram(uid);
      }
    } catch (e) {
      print('Error loading program: $e');
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      title: 'Programlarım',
      currentIndex: 1,
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _selectedProgram == null
              ? _buildEmptyState()
              : _buildProgramDetails(),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.grey[700];
    final subtitleColor = isDark ? Colors.white70 : Colors.grey[600];
    final iconColor = isDark ? Colors.white38 : Colors.grey[400];
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 64, color: iconColor),
            SizedBox(height: 16),
            Text(
              'Henüz bir program seçmediniz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor),
            ),
            SizedBox(height: 8),
            Text(
              'Size özel bir diyet programı oluşturmak için program seçin',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: subtitleColor),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProgramsScreen()),
                ).then((_) => _loadProgram());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('Program Seç'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramDetails() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final program = _selectedProgram!;
    final programName = program['name'] ?? 'Diyet Programı';
    final dailyCalories = program['dailyCalories'] ?? 0;
    final description = program['description'] ?? '';
    final dailyMeals = program['dailyMeals'] as Map<String, dynamic>?;
    final weeklyPlan = program['weeklyPlan'] ?? '';
    final nutritionTargets = program['nutritionTargets'] as Map<String, dynamic>?;
    final tips = program['tips'] as List<dynamic>?;
    final notes = program['notes'] ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Program Header
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    programName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.white, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Günlük Kalori: $dailyCalories kcal',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Nutrition Targets
          if (nutritionTargets != null) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Besin Değerleri Hedefi',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNutritionBox('Protein', '${nutritionTargets['protein'] ?? 0}g', Colors.blue),
                        _buildNutritionBox('Karbonhidrat', '${nutritionTargets['carbs'] ?? 0}g', Colors.orange),
                        _buildNutritionBox('Yağ', '${nutritionTargets['fat'] ?? 0}g', Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],

          // Daily Meals
          if (dailyMeals != null) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Günlük Öğün Planı',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    if (dailyMeals['breakfast'] != null)
                      _buildMealItem('Sabah', dailyMeals['breakfast']),
                    if (dailyMeals['lunch'] != null)
                      _buildMealItem('Öğle', dailyMeals['lunch']),
                    if (dailyMeals['dinner'] != null)
                      _buildMealItem('Akşam', dailyMeals['dinner']),
                    if (dailyMeals['snacks'] != null)
                      _buildMealItem('Ara Öğün', dailyMeals['snacks']),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],

          // Weekly Plan
          if (weeklyPlan.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Haftalık Plan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text(
                      weeklyPlan,
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],

          // Tips
          if (tips != null && tips.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'İpuçları ve Öneriler',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    ...tips.map((tip) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  tip.toString(),
                                  style: TextStyle(fontSize: 14, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],

          // Notes
          if (notes.isNotEmpty) ...[
            Card(
              color: isDark ? Color(0xFF2A1D12) : Color(0xFFFFF3E0),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Dikkat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.orange[200] : Colors.orange[900],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      notes,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? Colors.orange[100] : Colors.orange[900],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProgramsScreen()),
              ).then((_) => _loadProgram());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Yeni Program Seç'),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionBox(String label, String value, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : Colors.grey[700];
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: labelColor),
        ),
      ],
    );
  }

  Widget _buildMealItem(String mealName, String mealContent) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mealTitleColor = isDark ? Colors.white : Color(0xFF2E7D32);
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealName,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: mealTitleColor),
          ),
          SizedBox(height: 4),
          Text(
            mealContent,
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

