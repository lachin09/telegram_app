import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/modules/login_module/pages/sign_up_page.dart';
import 'package:supa_app/modules/login_module/pages/sing_in_page.dart';
import 'package:supa_app/routes/routes.dart';

class LoginModule extends Module {
  @override
  final List<Bind> binds = [];
  @override
  final List<ModularRoute> routes = [
    ChildRoute(Routes.login.signUp, child: (_, args) => const SignUpPage()),
    ChildRoute(
      Routes.login.signIn,
      child: (_, args) => const SignInPage(),
    ),
  ];
}
