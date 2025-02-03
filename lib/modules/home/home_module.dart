import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/modules/home/pages/add_prod_page.dart';
import 'package:supa_app/modules/home/pages/bottom_bar.dart';
import 'package:supa_app/modules/home/pages/product_details_page.dart';
import 'package:supa_app/modules/home/pages/search_product_page.dart';
import 'package:supa_app/routes/routes.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  @override
  final List<ModularRoute> routes = [
    ChildRoute(Routes.home.home, child: (_, args) => const BottomNavigator()),
    ChildRoute(
      Routes.home.products,
      child: (_, args) => AddProductScreen(),
    ),
    ChildRoute(
      Routes.home.search,
      child: (_, args) => const ProductSearchPage(),
    ),
    ChildRoute(
      Routes.home.details,
      child: (_, args) => ProductDetailsPage(productId: args.data),
    ),
  ];
}
