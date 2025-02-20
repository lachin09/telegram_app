import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCubit extends Cubit<String?> {
  AuthCubit() : super(Supabase.instance.client.auth.currentUser?.id);

  void updateUser() {
    emit(Supabase.instance.client.auth.currentUser?.id);
  }
}
