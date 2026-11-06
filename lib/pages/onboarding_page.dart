import 'package:flutter/material.dart';
import '../services/pref_service.dart';
import '../utils/route_transitions.dart';
import 'profile_page.dart';

class OnboardingPage extends StatelessWidget {
  final PrefService prefs;
  const OnboardingPage({super.key, required this.prefs});

  void _finishOnboarding(BuildContext context) {
    prefs.setHasSeenOnboarding();
    Navigator.pushReplacement(
      context,
      SmoothRoute(page: ProfilePage(prefs: prefs)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_pin_circle, size: 100, color: colors.primary),
              const SizedBox(height: 24),
              Text(
                'Selamat Datang!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Atur profil digitalmu dengan mudah. Semua data akan tersimpan aman di perangkatmu.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: () => _finishOnboarding(context),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Mulai Sekarang'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}