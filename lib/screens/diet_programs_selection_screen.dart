import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../widgets/app_scaffold.dart';

class DietProgramsSelectionScreen extends StatefulWidget {
  final String programKey;
  final List<Map<String, dynamic>> programs;

  const DietProgramsSelectionScreen({
    Key? key,
    required this.programKey,
    required this.programs,
  }) : super(key: key);

  @override
  State<DietProgramsSelectionScreen> createState() => _DietProgramsSelectionScreenState();
}

class _DietProgramsSelectionScreenState extends State<DietProgramsSelectionScreen> {
  int? _selectedProgramIndex;
  bool _saving = false;

  Future<void> _saveSelectedProgram() async {
    if (_selectedProgramIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir program seçin!')),
      );
      return;
    }

    setState(() => _saving = true);

    final uid = AuthService.currentUser?.uid;
    if (uid == null) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı oturumu bulunamadı!')),
      );
      return;
    }

    try {
      final selectedProgram = widget.programs[_selectedProgramIndex!];
      await UserService.saveSelectedDietProgram(uid, widget.programKey, selectedProgram);
      
      setState(() => _saving = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Program başarıyla kaydedildi!')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diyet Programı Seç'),
      ),
      body: _saving
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Size özel hazırlanmış ${widget.programs.length} alternatif program bulundu. Lütfen size en uygun olanı seçin:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  ...widget.programs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final program = entry.value;
                    return _buildProgramCard(index, program);
                  }).toList(),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saving ? null : _saveSelectedProgram,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Seçili Programı Kaydet'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProgramCard(int index, Map<String, dynamic> program) {
    final isSelected = _selectedProgramIndex == index;
    final programName = program['name'] ?? 'Program ${index + 1}';
    final dailyCalories = program['dailyCalories'] ?? 0;
    final description = program['description'] ?? '';

    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Color(0xFF2E7D32) : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedProgramIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      programName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Color(0xFF2E7D32) : Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isSelected ? Color(0xFF2E7D32) : Colors.grey,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    'Günlük Kalori: $dailyCalories kcal',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              if (description.isNotEmpty) ...[
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
              if (program['nutritionTargets'] != null) ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildNutritionChip('Protein', '${program['nutritionTargets']['protein'] ?? 0}g'),
                    SizedBox(width: 8),
                    _buildNutritionChip('Karbonhidrat', '${program['nutritionTargets']['carbs'] ?? 0}g'),
                    SizedBox(width: 8),
                    _buildNutritionChip('Yağ', '${program['nutritionTargets']['fat'] ?? 0}g'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(fontSize: 12, color: Color(0xFF2E7D32)),
      ),
    );
  }
}

