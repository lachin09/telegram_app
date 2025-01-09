import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:supa_app/modules/services/supa_service.dart';
import 'package:supa_app/routes/routes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final productService = Modular.get<ProductService>();

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("fill the fields")));
      return;
    }
    try {
      await productService.signUpWithEmail(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully!')),
      );
      Modular.to.pushNamed(Routes.home.getRoute(Routes.home.home));
    } catch (e) {
      print("signing  error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registiration"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Add email',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Add password',
                  border: OutlineInputBorder(),
                ),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: () {
                        signIn();
                      },
                      child: Text("register")),
              TextButton(
                  onPressed: () {
                    Modular.to
                        .pushNamed(Routes.login.getRoute(Routes.login.signIn));
                  },
                  child: Text("do you have an account? got to SignIn")),
              TextButton(
                  onPressed: () {
                    Modular.to
                        .pushNamed(Routes.home.getRoute(Routes.home.home));
                  },
                  child: Text("continue as guest")),
            ],
          ),
        ),
      ),
    );
  }
}
