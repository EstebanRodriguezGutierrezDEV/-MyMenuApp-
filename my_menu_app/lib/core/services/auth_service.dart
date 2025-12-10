import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class AuthService {
  // Use a getter to access the client lazily. This prevents a crash during object instantiation
  // if Supabase hasn't been initialized yet (or failed to initialize).
  SupabaseClient get _supabase => Supabase.instance.client;

  // Stream to listen for authentication changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName}, // Stored in auth.users metadata
      );

      // Note: We need a Trigger in Supabase (Postgres) to automatically create
      // a row in 'public.profiles' when a user signs up.
      // Alternatively, we can insert it manually here if the trigger isn't set up,
      // but the trigger is the "Relational Way".
      // For simplicity in this dart-only context, let's assume we might need to insert if not using triggers,
      // but Supabase best practice for 'profiles' usually involves a trigger.

      // Let's try to update the profile immediately just in case
      if (response.user != null) {
        await _updateProfileHeader(response.user!.id, fullName);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _updateProfileHeader(String userId, String fullName) async {
    // Upsert into profiles table
    await _supabase.from('profiles').upsert({
      'id': userId,
      'full_name': fullName,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Update User Profile (Name and Photo URL)
  Future<void> updateProfile({String? name, String? photoUrl}) async {
    final user = currentUser;
    if (user != null) {
      // Update Supabase Auth Meta Data (Optional, but good for consistency)
      // await _supabase.auth.updateUser(
      //   UserAttributes(data: {
      //     if (name != null) 'full_name': name,
      //     if (photoUrl != null) 'avatar_url': photoUrl,
      //   }),
      // );

      // Update Public Profiles Table (Relational Data)
      await _supabase
          .from('profiles')
          .update({
            if (name != null) 'full_name': name,
            if (photoUrl != null) 'avatar_url': photoUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);
    }
  }

  // Update Password
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  // Upload Profile Image
  Future<String?> uploadProfileImage(String filePath) async {
    final user = currentUser;
    if (user == null) return null;

    final File file = File(filePath);
    final String fileExt = filePath.split('.').last;
    final String fileName = '${user.id}/profile.$fileExt'; // Organize by Folder

    try {
      // Upload to 'avatars' bucket
      await _supabase.storage
          .from('avatars')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      // Get Public URL
      final String publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      print('Error uploading to Supabase Storage: $e');
      rethrow;
    }
  }

  // Get User Preferences
  Future<Map<String, dynamic>?> getUserPreferences() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select('allergies, intolerances')
          .eq('id', user.id)
          .maybeSingle();

      return response;
    } catch (e) {
      print('DEBUG: Error fetching preferences: $e');
      return null;
    }
  }

  // Update User Preferences
  Future<void> updateUserPreferences({
    required List<String> allergies,
    required List<String> intolerances,
  }) async {
    final user = currentUser;
    if (user != null) {
      await _supabase
          .from('profiles')
          .update({
            'allergies': allergies,
            'intolerances': intolerances,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);
    }
  }
}
