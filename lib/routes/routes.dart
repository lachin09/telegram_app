class Routes {
  static final _Home home = _Home();
  static final _Login login = _Login();
}

class _Login extends RouteClass {
  @override
  String module = "/auth";
  String signUp = '/';
  String signIn = "/signIn";
}

class _Home extends RouteClass {
  @override
  String module = "/home";
  String home = '/';
  String products = "/products";
  String search = '/search';
  String details = "/details";
}

abstract class RouteClass {
  String module = '/';

  String getRoute(String moduleRoute) => module + moduleRoute;

  String getModule() => '$module/';
}
