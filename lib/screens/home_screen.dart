import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'programs_screen.dart';
import '../widgets/app_scaffold.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Profil ekranındaki gibi: koyu modda koyu gri, açık modda beyaz
    final cardBg = isDark ? Color(0xFF121A14) : Colors.white;

    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: cardBg,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: cardBg,
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 48,
                    color: isDark ? Colors.white : Color(0xFF2E7D32),
                  ),
                  SizedBox(height: 12),
                  Text(
                    loc.welcome,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    loc.homeSubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          _buildMenuCard(
            context,
            icon: Icons.workspace_premium,
            title: loc.programsTitle,
            description: loc.programsDesc,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProgramsScreen()));
            },
          ),
          SizedBox(height: 16),
          _buildMenuCard(
            context,
            icon: Icons.camera_alt,
            title: loc.menuCameraTitle,
            description: loc.menuCameraDesc,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CameraScreen()));
            },
          ),
          SizedBox(height: 16),
          _buildMenuCard(
            context,
            icon: Icons.calendar_today,
            title: loc.menuRecordsTitle,
            description: loc.menuRecordsDesc,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bu özellik yakında açılacak.')),
              );
            },
            disabled: true,
          ),
        ],
      ),
    );

    return AppScaffold(
      title: 'Kalori Takip',
      currentIndex: 0,
      body: content,
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Profil ekranındaki gibi: koyu modda koyu gri, açık modda beyaz
    final cardBg = isDark ? Color(0xFF121A14) : Colors.white;
    
    final cardColor = cardBg;
    final disabledCardColor = isDark ? cardBg.withOpacity(0.75) : Colors.grey[200];
    final iconBgColor = isDark
        ? (disabled ? Colors.grey[700] : Colors.grey[900])
        : (disabled ? Colors.grey[300] : Color(0xFFC8E6C9));
    final iconColor = isDark
        ? (disabled ? Colors.grey[500] : Colors.white)
        : (disabled ? Colors.grey[500] : Color(0xFF2E7D32));
    final titleColor = isDark
        ? (disabled ? Colors.grey[500] : Colors.white)
        : (disabled ? Colors.grey[500] : Colors.black87);
    final descColor = isDark
        ? (disabled ? Colors.grey[600] : Colors.white70)
        : (disabled ? Colors.grey[400] : Colors.grey[600]);
    final arrowColor = isDark
        ? (disabled ? Colors.grey[600] : Colors.white70)
        : Colors.grey[400];
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: disabled ? disabledCardColor : cardColor,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBgColor,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: iconColor,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: descColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: arrowColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
