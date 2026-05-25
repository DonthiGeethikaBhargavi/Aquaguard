import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 👤 USER PROFILE MODEL
class UserProfile {
  final String id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    this.fullName,
    this.email,
    this.phone,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Get initials from full name
  String getInitials() {
    if (fullName == null || fullName!.isEmpty) return '?';

    final parts = fullName!.split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  /// Get display name
  String getDisplayName() => fullName ?? 'User';
}

/// 👤 USER PROFILE PROVIDER
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    // Fetch from users_profile table
    final response = await supabase
        .from('users_profile')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      // Create profile with auth user data if not exists
      return UserProfile(
        id: user.id,
        email: user.email,
        fullName: user.userMetadata?['full_name'] as String?,
      );
    }

    return UserProfile.fromJson(response);
  } catch (_) {
    // Return basic profile from auth user
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    return UserProfile(
      id: user.id,
      email: user.email,
      fullName: user.userMetadata?['full_name'] as String?,
    );
  }
});
