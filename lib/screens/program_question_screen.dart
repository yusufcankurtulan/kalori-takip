import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../services/ai_service.dart';
import '../l10n/app_localizations.dart';
import 'diet_programs_selection_screen.dart';

class ProgramQuestionScreen extends StatefulWidget {
  final String programKey;
  const ProgramQuestionScreen({Key? key, required this.programKey}) : super(key: key);

  @override
  State<ProgramQuestionScreen> createState() => _ProgramQuestionScreenState();
}

class _ProgramQuestionScreenState extends State<ProgramQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _answers = {};
  bool _saving = false;

  List<Map<String, dynamic>> get _questions {
    final loc = AppLocalizations.of(context);
    switch (widget.programKey) {
      case 'lose':
        return [
          {'key': 'activity_level', 'question': loc.activityLevel, 'type': 'select', 'options': [
            loc.activityLow, loc.activityMedium, loc.activityHigh,
          ]},
          {'key': 'experience_level', 'question': loc.experienceLevel, 'type': 'select', 'options': [
            loc.beginner, loc.intermediate, loc.advanced,
          ]},
          {'key': 'daily_steps', 'question': loc.dailySteps, 'type': 'select', 'options': [
            loc.stepsLess3000, loc.steps30005000, loc.steps50008000, loc.steps800010000, loc.stepsMore10000,
          ]},
          {'key': 'workout_type', 'question': loc.workoutType, 'type': 'multi', 'options': [
            loc.workoutStrength, loc.workoutCardio, loc.workoutBoth,
          ]},
          {'key': 'eating_habits', 'question': loc.currentEatingHabits, 'type': 'select', 'options': [
            loc.eatingHealthy, loc.eatingModerate, loc.eatingUnhealthy,
          ]},
          {'key': 'water_intake', 'question': loc.waterIntake, 'type': 'select', 'options': [
            loc.waterLess1L, loc.water1_2L, loc.water2_3L, loc.waterMore3L,
          ]},
          {'key': 'stress_level', 'question': loc.stressLevel, 'type': 'select', 'options': [
            loc.stressLow, loc.stressMedium, loc.stressHigh,
          ]},
          {'key': 'primary_goal', 'question': loc.primaryGoal, 'type': 'select', 'options': [
            loc.goalLoseWeight, loc.goalBuildMuscle, loc.goalImproveEndurance, loc.goalStayHealthy,
          ]},
        ];
      case 'gain':
        return [
          {'key': 'activity_level', 'question': loc.activityLevel, 'type': 'select', 'options': [
            loc.activityLow, loc.activityMedium, loc.activityHigh,
          ]},
          {'key': 'experience_level', 'question': loc.experienceLevel, 'type': 'select', 'options': [
            loc.beginner, loc.intermediate, loc.advanced,
          ]},
          {'key': 'workout_type', 'question': loc.workoutType, 'type': 'multi', 'options': [
            loc.workoutStrength, loc.workoutCardio, loc.workoutBoth,
          ]},
          {'key': 'meals_per_day', 'question': loc.loseMealsQuestion, 'type': 'select', 'options': [
            loc.meals3, loc.meals4, loc.meals5Plus,
          ]},
          {'key': 'eating_habits', 'question': loc.currentEatingHabits, 'type': 'select', 'options': [
            loc.eatingHealthy, loc.eatingModerate, loc.eatingUnhealthy,
          ]},
          {'key': 'water_intake', 'question': loc.waterIntake, 'type': 'select', 'options': [
            loc.waterLess1L, loc.water1_2L, loc.water2_3L, loc.waterMore3L,
          ]},
          {'key': 'primary_goal', 'question': loc.primaryGoal, 'type': 'select', 'options': [
            loc.goalBuildMuscle, loc.goalLoseWeight, loc.goalImproveEndurance, loc.goalStayHealthy,
          ]},
        ];
      case 'maintain':
        return [
          {'key': 'activity_level', 'question': loc.activityLevel, 'type': 'select', 'options': [
            loc.activityLow, loc.activityMedium, loc.activityHigh,
          ]},
          {'key': 'daily_steps', 'question': loc.dailySteps, 'type': 'select', 'options': [
            loc.stepsLess3000, loc.steps30005000, loc.steps50008000, loc.steps800010000, loc.stepsMore10000,
          ]},
          {'key': 'workout_type', 'question': loc.workoutType, 'type': 'multi', 'options': [
            loc.workoutStrength, loc.workoutCardio, loc.workoutBoth,
          ]},
          {'key': 'eating_habits', 'question': loc.currentEatingHabits, 'type': 'select', 'options': [
            loc.eatingHealthy, loc.eatingModerate, loc.eatingUnhealthy,
          ]},
          {'key': 'water_intake', 'question': loc.waterIntake, 'type': 'select', 'options': [
            loc.waterLess1L, loc.water1_2L, loc.water2_3L, loc.waterMore3L,
          ]},
          {'key': 'stress_level', 'question': loc.stressLevel, 'type': 'select', 'options': [
            loc.stressLow, loc.stressMedium, loc.stressHigh,
          ]},
        ];
      case 'fitness':
        return [
          {'key': 'experience_level', 'question': loc.experienceLevel, 'type': 'select', 'options': [
            loc.beginner, loc.intermediate, loc.advanced,
          ]},
          {'key': 'workout_type', 'question': loc.workoutType, 'type': 'multi', 'options': [
            loc.workoutStrength, loc.workoutCardio, loc.workoutBoth,
          ]},
          {'key': 'workout_location', 'question': 'Where do you workout?', 'type': 'select', 'options': [
            loc.workoutHome, loc.workoutGym, loc.equipmentNone,
          ]},
          {'key': 'weekly_days', 'question': loc.fitnessSportDaysQuestion, 'type': 'select', 'options': [
            '1-2 days', '3-4 days', '5-6 days', 'Every day',
          ]},
          {'key': 'primary_goal', 'question': loc.primaryGoal, 'type': 'select', 'options': [
            loc.goalBuildMuscle, loc.goalLoseWeight, loc.goalImproveEndurance, loc.goalStayHealthy,
          ]},
          {'key': 'water_intake', 'question': loc.waterIntake, 'type': 'select', 'options': [
            loc.waterLess1L, loc.water1_2L, loc.water2_3L, loc.waterMore3L,
          ]},
        ];
      default:
        return [];
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _saving = true);
    
    final loc = AppLocalizations.of(context);
    final uid = AuthService.currentUser?.uid;
    if (uid == null) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.userNotFoundError)),
      );
      return;
    }

    try {
      await UserService.saveProgramAnswers(uid, widget.programKey, _answers);
      final userProfile = await UserService.getProfile(uid);
      Map<String, dynamic>? profileData;
      if (userProfile != null) {
        profileData = userProfile.toJson();
      }

      final programsResponse = await AIService.generateDietPrograms(
        programKey: widget.programKey,
        answers: _answers,
        userProfile: profileData,
      );

      setState(() => _saving = false);

      if (programsResponse == null || programsResponse['programs'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.dietGenerationError)),
        );
        return;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DietProgramsSelectionScreen(
              programKey: widget.programKey,
              programs: List<Map<String, dynamic>>.from(programsResponse['programs']),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.errorOccurred}${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtextColor = isDark ? Colors.white70 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF1E2A22) : Colors.white;
    final inputFillColor = isDark ? const Color(0xFF2A3A2E) : Colors.grey[100];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.questionScreenTitle, style: TextStyle(color: Colors.white)),
        backgroundColor: isDark ? const Color(0xFF121A14) : Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: isDark ? const Color(0xFF0F1F12) : Colors.transparent,
      body: _saving
          ? Center(child: CircularProgressIndicator(color: const Color(0xFF2E7D32)))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ..._questions.map((q) => _buildQuestionWidget(q, textColor, subtextColor, cardColor, inputFillColor, isDark)).toList(),
                  const SizedBox(height: 24),
                  _buildStyledButton(loc),
                ],
              ),
            ),
    );
  }

  Widget _buildStyledButton(AppLocalizations loc) {
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
            color: const Color(0xFF2E7D32).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submit,
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
            const Icon(Icons.arrow_forward, size: 22),
            const SizedBox(width: 10),
            Text(
              loc.continueBtn,
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

  Widget _buildQuestionWidget(
    Map<String, dynamic> q,
    Color textColor,
    Color subtextColor,
    Color cardColor,
    Color? inputFillColor,
    bool isDark,
  ) {
    final loc = AppLocalizations.of(context);
    final key = q['key'];
    final type = q['type'];
    final questionText = q['question'] as String;

    switch (type) {
      case 'select':
        return Card(
          color: cardColor,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: questionText,
                labelStyle: TextStyle(color: subtextColor),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              style: TextStyle(color: textColor),
              items: (q['options'] as List<String>).map((opt) => 
                DropdownMenuItem(value: opt, child: Text(opt, style: TextStyle(color: textColor)))
              ).toList(),
              initialValue: _answers[key],
              onChanged: (v) => setState(() => _answers[key] = v),
              validator: (v) => (v == null || v.isEmpty) ? loc.requiredField : null,
              dropdownColor: cardColor,
            ),
          ),
        );
      case 'multi':
        return Card(
          color: cardColor,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(questionText, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textColor)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (q['options'] as List<String>).map((opt) {
                    final selected = (_answers[key] ?? <String>[]) as List<String>;
                    final isSelected = selected.contains(opt);
                    return FilterChip(
                      label: Text(opt, style: TextStyle(
                        color: isSelected ? Colors.white : textColor,
                      )),
                      selected: isSelected,
                      selectedColor: const Color(0xFF2E7D32),
                      checkmarkColor: Colors.white,
                      backgroundColor: isDark ? const Color(0xFF2A3A2E) : Colors.grey[200],
                      side: BorderSide(color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent),
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            (_answers[key] ??= <String>[]).add(opt);
                          } else {
                            (_answers[key] as List<String>).remove(opt);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

