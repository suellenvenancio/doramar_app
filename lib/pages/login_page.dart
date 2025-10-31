import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/store/auth.store.dart';

import '../component/app_bar.dart';
import '../utils/input_formater.dart';
import 'create_account_page.dart';
import 'home_page.dart';
import 'reset_password_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Login'),
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(255, 174, 201, 1),
      body: SafeArea(child: SingleChildScrollView(child: LoginForm())),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late AuthStore authStore;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  String errorMessage = '';
  bool _hideText = true;

  @override
  void initState() {
    super.initState();
    authStore = context.read<AuthStore>();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Image.asset('assets/logo.png', height: 100, width: 100),
            const SizedBox(height: 20),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [LowerCaseTextFormatter()],
              style: const TextStyle(color: Colors.black, fontSize: 20),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(25),
                errorStyle: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(150, 0, 60, 1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(150, 0, 60, 1)),
                ),
                labelText: 'Enter your email',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(150, 0, 60, 1),
                  fontSize: 20,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: password,
              textCapitalization: TextCapitalization.none,
              obscureText: _hideText,
              style: const TextStyle(color: Colors.black, fontSize: 20),
              keyboardType: TextInputType.visiblePassword,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(25),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hideText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _hideText = !_hideText;
                    });
                  },
                ),
                errorStyle: const TextStyle(
                  color: Colors.redAccent, // deep pink para erro
                  fontWeight: FontWeight.w600,
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(150, 0, 60, 1)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(150, 0, 60, 1)),
                ),
                labelText: 'Enter your password',
                labelStyle: const TextStyle(
                  color: Color.fromRGBO(150, 0, 60, 1),
                  // cor do texto de erro
                  fontSize: 20,
                ),
              ),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Text(errorMessage, style: TextStyle(color: Colors.redAccent)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountPage(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(LinearBorder.bottom()),
                  ),
                  child: Text(
                    'Cadastre-se',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.pink,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordPage(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(LinearBorder.bottom()),
                  ),
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.pink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Builder(
              builder: (context) {
                final store = Provider.of<AuthStore>(context);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(25),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromRGBO(233, 30, 99, 1),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          store
                              .signIn(
                                email: email.text,
                                password: password.text,
                              )
                              .then((_) {
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MenuPage(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              })
                              .catchError((error) {
                                setState(() {
                                  errorMessage = error.toString();
                                });
                              });
                        }
                      },
                      child: store.isLoading
                          ? const SizedBox(
                              height: 24.0, // Defina um tamanho fixo
                              width: 24.0,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3.0,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
