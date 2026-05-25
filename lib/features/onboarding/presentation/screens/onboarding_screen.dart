import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:aquaguard/core/widgets/water_effect.dart';
import 'package:aquaguard/features/auth/application/providers/auth_provider.dart';
import 'package:aquaguard/features/user/application/providers/user_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  String? selected;
  bool isLoading = false;

  late final AnimationController intro;
  late final AnimationController breathe;

  @override
  void initState() {
    super.initState();

    intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    breathe = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    intro.dispose();
    breathe.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (selected == null) return;

    setState(() => isLoading = true);

    try {
      final user = ref.read(authStateProvider).value?.session?.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not found. Please login again.")),
        );
        return;
      }

      await Supabase.instance.client.from('users_profile').upsert({
        'id': user.id,
        'email': user.email,
        'name': user.userMetadata?['name'] ?? 'User',
        'aquatic_type': selected,
      }, onConflict: 'id');

      ////////////////////////////////////////////////////////////
      /// 🔥 ONLY THIS (NO NAVIGATION)
      ////////////////////////////////////////////////////////////
      ref.invalidate(userDataProvider);
    } catch (e) {
      debugPrint("Onboarding error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RepaintBoundary(
            child: WaterEffect(child: _AnimatedBackground()),
          ),
          Center(
            child: FadeTransition(
              opacity: intro,
              child: _CardContainer(
                selected: selected,
                onSelect: (v) {
                  HapticFeedback.lightImpact();
                  setState(() => selected = v);
                },
                onContinue: _continue,
                isLoading: isLoading,
                breathe: breathe,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// BACKGROUND
////////////////////////////////////////////////////////////

class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B0F1A), Color(0xFF121826)],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// CARD CONTAINER
////////////////////////////////////////////////////////////

class _CardContainer extends StatelessWidget {
  final String? selected;
  final Function(String) onSelect;
  final VoidCallback onContinue;
  final bool isLoading;
  final AnimationController breathe;

  const _CardContainer({
    required this.selected,
    required this.onSelect,
    required this.onContinue,
    required this.isLoading,
    required this.breathe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AnimatedTitle(selected: selected),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _FarmCard(
                  type: "fish",
                  selected: selected,
                  onTap: onSelect,
                  breathe: breathe,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _FarmCard(
                  type: "shrimp",
                  selected: selected,
                  onTap: onSelect,
                  breathe: breathe,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: (selected == null || isLoading) ? null : onContinue,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Continue"),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// TITLE
////////////////////////////////////////////////////////////

class _AnimatedTitle extends StatelessWidget {
  final String? selected;

  const _AnimatedTitle({required this.selected});

  @override
  Widget build(BuildContext context) {
    final text = switch (selected) {
      "fish" => "Smart Fish Farming",
      "shrimp" => "Precision Shrimp Culture",
      _ => "Select Your Farm Type",
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Text(
        text,
        key: ValueKey(text),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// FARM CARD
////////////////////////////////////////////////////////////

class _FarmCard extends StatelessWidget {
  final String type;
  final String? selected;
  final Function(String) onTap;
  final AnimationController breathe;

  const _FarmCard({
    required this.type,
    required this.selected,
    required this.onTap,
    required this.breathe,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == type;

    return GestureDetector(
      onTap: () => onTap(type),
      child: AnimatedBuilder(
        animation: breathe,
        builder: (_, __) {
          final scale = isSelected
              ? 1 + 0.01 * sin(breathe.value * 2 * pi)
              : 1.0;

          return Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isSelected
                    ? Colors.cyan.withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
              ),
              child: Column(
                children: [
                  Image.asset(
                    type == "fish"
                        ? 'assets/animations/fish.gif'
                        : 'assets/animations/shrimp.gif',
                    height: 70,
                  ),
                  const SizedBox(height: 10),
                  Text(type.toUpperCase()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
