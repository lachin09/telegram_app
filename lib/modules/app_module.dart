import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/modules/home/home_module.dart';
import 'package:supa_app/modules/login_module/login_modul.dart';
import 'package:supa_app/routes/routes.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [];
  @override
  final List<ModularRoute> routes = [
    ModuleRoute(
      Routes.home.module,
      module: HomeModule(),
    ),
    ModuleRoute(
      Routes.login.module,
      module: LoginModul(),
    ),
  ];
}
