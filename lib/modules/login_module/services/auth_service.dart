import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthService {
  Future<void> signUpWithEmail(String email, String password);
  Future<void> signInWithEmail(String email, String password);
}

class AuthService implements IAuthService {
  final SupabaseClient supabase;

  AuthService(this.supabase);

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      print("Registration successful! User: ${response.user!.email}");
    } else {
      print("Registration error");
    }
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session != null) {
      print("Sign-in successful! Token: ${response.session!.accessToken}");
    } else {
      print("Sign-in error");
    }
  }
}
