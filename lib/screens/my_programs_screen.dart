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
      debugPrint('Error loading program: $e');
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

    /// 🔹 FITNESS ICON & TEXT ORTAK RENGİ
    final baseTextColor = isDark ? Colors.white70 : Colors.grey[800]!;

    return AppScaffold(
      title: loc.myProgramsTitle,
      currentIndex: 1,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTextStyle(
              style: TextStyle(
                color: baseTextColor,
                fontSize: 14,
              ),
              child: _selectedProgram == null
                  ? _buildEmptyState(baseTextColor)
                  : _buildProgramDetails(baseTextColor),
            ),
    );
  }

  Widget _buildEmptyState(Color baseTextColor) {
    final loc = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 64,
              color: baseTextColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              loc.noProgramTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              loc.noProgramDescription,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildStyledButton(
              text: loc.selectProgram,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProgramsScreen()),
                ).then((_) => _loadProgram());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramDetails(Color baseTextColor) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final program = _selectedProgram!;
    final programName = program['name'] ?? loc.defaultDietProgram;
    final dailyCalories = program['dailyCalories'] ?? 0;
    final description = program['description'] ?? '';
    final dailyMeals = program['dailyMeals'] as Map<String, dynamic>?;
    final weeklyPlan = program['weeklyPlan'] ?? '';
    final nutritionTargets =
        program['nutritionTargets'] as Map<String, dynamic>?;
    final tips = program['tips'] as List<dynamic>?;
    final notes = program['notes'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    programName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${loc.dailyCalories}: $dailyCalories kcal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// NUTRITION TARGETS
          if (nutritionTargets != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.nutritionTargets,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNutritionBox(
                          loc.protein,
                          '${nutritionTargets['protein'] ?? 0}g',
                          Colors.blue,
                        ),
                        _buildNutritionBox(
                          loc.carbohydrate,
                          '${nutritionTargets['carbs'] ?? 0}g',
                          Colors.orange,
                        ),
                        _buildNutritionBox(
                          loc.fat,
                          '${nutritionTargets['fat'] ?? 0}g',
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          /// DAILY MEALS
          if (dailyMeals != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.dailyMealPlan,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (dailyMeals['breakfast'] != null)
                      _buildMealItem(
                        loc.breakfast,
                        dailyMeals['breakfast'],
                      ),
                    if (dailyMeals['lunch'] != null)
                      _buildMealItem(loc.lunch, dailyMeals['lunch']),
                    if (dailyMeals['dinner'] != null)
                      _buildMealItem(loc.dinner, dailyMeals['dinner']),
                    if (dailyMeals['snacks'] != null)
                      _buildMealItem(loc.snack, dailyMeals['snacks']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          /// WEEKLY PLAN
          if (weeklyPlan.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.weeklyPlan,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(weeklyPlan),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          /// TIPS
          if (tips != null && tips.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.tipsAndSuggestions,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...tips.map(
                      (tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF2E7D32),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(tip.toString())),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          /// NOTES
          if (notes.isNotEmpty) ...[
            Card(
              color:
                  isDark ? const Color(0xFF2A1D12) : const Color(0xFFFFF3E0),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          loc.warning,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(notes),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
          _buildStyledButton(
            text: loc.selectProgram,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProgramsScreen()),
              ).then((_) => _loadProgram());
            },
          ),

        ],
      ),
    );
  }

  Widget _buildNutritionBox(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMealItem(String mealName, String mealContent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 4),
          Text(mealContent),
        ],
      ),
    );
  }

  Widget _buildStyledButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fitness_center,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
