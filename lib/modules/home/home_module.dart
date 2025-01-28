import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/modules/home/pages/add_prod_page.dart';
import 'package:supa_app/modules/home/pages/home_page.dart';

import 'package:supa_app/modules/home/pages/search_product_page.dart';
import 'package:supa_app/modules/services/supa_service.dart';
import 'package:supa_app/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => Supabase.instance.client),
    Bind.singleton((i) => ProductService(i.get<SupabaseClient>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Routes.home.home, child: (_, args) => ProductListScreen()),
    ChildRoute(
      Routes.home.products,
      child: (_, args) => AddProductScreen(),
    ),
    ChildRoute(
      Routes.home.search,
      child: (_, args) => ProductSearchPage(),
    ),
  ];
}
