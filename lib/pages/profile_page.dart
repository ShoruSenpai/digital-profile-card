import 'package:flutter/material.dart';
import '../models/profile_data.dart';
import '../services/pref_service.dart';
import '../utils/route_transitions.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final PrefService prefs;
  const ProfilePage({super.key, required this.prefs});

  Future<void> _edit(BuildContext context) async {
    final result = await Navigator.push<ProfileData>(
      context,
      SmoothRoute(page: EditProfilePage(initial: prefs.profile)),
    );
    if (result == null) return;

    await prefs.saveProfile(result);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui!')),
    );
  }

  Future<void> _reset(BuildContext context) async {
    await prefs.clearProfile();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil dikembalikan ke bawaan')),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return 'Belum pernah diedit';
    final date = DateTime.parse(isoDate);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final profile = prefs.profile;
    final initial = profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?';

    final themeColors = [
      Colors.indigo, Colors.teal, Colors.deepOrange, Colors.blue, Colors.purple
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit profil',
            onPressed: () => _edit(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: colors.primaryContainer,
                    foregroundColor: colors.onPrimaryContainer,
                    child: Text(initial, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  Text(profile.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(profile.title, style: TextStyle(color: colors.primary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Text(profile.bio, textAlign: TextAlign.center),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 14, color: colors.outline),
                      const SizedBox(width: 4),
                      Text(
                        'Terakhir diedit: ${_formatDate(profile.lastEdited)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          Text('Pengaturan Tema', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('Sistem'), icon: Icon(Icons.brightness_auto)),
              ButtonSegment(value: ThemeMode.light, label: Text('Terang'), icon: Icon(Icons.light_mode)),
              ButtonSegment(value: ThemeMode.dark, label: Text('Gelap'), icon: Icon(Icons.dark_mode)),
            ],
            selected: {prefs.themeMode},
            onSelectionChanged: (newSelection) => prefs.setThemeMode(newSelection.first),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            children: themeColors.map((color) {
              final isSelected = prefs.themeColor.value == color.value;
              return GestureDetector(
                onTap: () => prefs.setThemeColor(color),
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 20,
                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () => _reset(context),
            icon: const Icon(Icons.restore),
            label: const Text('Reset Data Profil'),
            style: OutlinedButton.styleFrom(foregroundColor: colors.error),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Kartu ini sudah dibuka ${prefs.openCount} kali',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.outline),
            ),
          ),
        ],
      ),
    );
  }
}