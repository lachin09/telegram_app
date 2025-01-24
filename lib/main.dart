import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supa_app/constants/constants.dart';
import 'package:supa_app/modules/app_module.dart';

import 'package:supa_app/modules/services/telegram_bot.dart';
import 'package:supa_app/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonkey,
  );
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
  startTelegramBot();
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute(Routes.login.getModule());
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routeInformationParser: Modular.routeInformationParser,
            routerDelegate: Modular.routerDelegate,
          );
        });
  }
}
