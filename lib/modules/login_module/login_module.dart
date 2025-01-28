import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/modules/login_module/pages/sign_up_page.dart';
import 'package:supa_app/modules/login_module/pages/sing_in_page.dart';
import 'package:supa_app/modules/services/supa_service.dart';
import 'package:supa_app/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => Supabase.instance.client),
    Bind.singleton((i) => ProductService(i.get<SupabaseClient>())),
  ];
  @override
  final List<ModularRoute> routes = [
    ChildRoute(Routes.login.signUp, child: (_, args) => const SignUpPage()),
    ChildRoute(
      Routes.login.signIn,
      child: (_, args) => const SignInPage(),
    ),
  ];
}
