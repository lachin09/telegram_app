import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/constants/constants.dart';
import 'package:supa_app/modules/home/home_module.dart';
import 'package:supa_app/modules/home/services/product_service.dart';
import 'package:supa_app/modules/home/vms/product_cubit.dart';
import 'package:supa_app/modules/login_module/login_module.dart';
import 'package:supa_app/modules/login_module/services/auth_service.dart';
import 'package:supa_app/modules/login_module/vms/login_cubit.dart';

import 'package:supa_app/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => SupabaseClient(
          supabaseUrl,
          supabaseAnonkey,
          authOptions:
              const AuthClientOptions(authFlowType: AuthFlowType.implicit),
        )),
    Bind.singleton((i) => ProductService(i.get<SupabaseClient>())),
    Bind.singleton((i) => ImageService(i.get<SupabaseClient>())),
    Bind.singleton((i) => AuthService(i.get<SupabaseClient>())),
    Bind.singleton((i) => ProductCubit(i.get<ProductService>())),
    Bind.singleton((i) => AuthCubit())
  ];

  @override
  final List<ModularRoute> routes = [
    // Маршрут для HomeModule
    ModuleRoute(
      Routes.home.module,
      module: HomeModule(),
    ),

    // Маршрут для LoginModule
    ModuleRoute(
      Routes.login.module,
      module: LoginModule(),
    ),
  ];
}
