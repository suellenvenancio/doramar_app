import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/utils/input_formater.dart';

import '../component/app_bar.dart';
import '../service/auth_service.dart';
import '../store/user.store.dart';
import 'login_page.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Criar Conta'),
      backgroundColor: Color.fromRGBO(255, 174, 201, 1),
      body: const CreateAccountForm(),
    );
  }
}

class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({super.key});

  @override
  CreateAccountFormState createState() {
    return CreateAccountFormState();
  }
}

class CreateAccountFormState extends State<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  String errorMessage = '';
  bool _hideText = true;

  Future<void> handleCreate(UserStore userStore) async {
    setState(() => errorMessage = '');

    try {
      await authService.value.createAccount(
        email: email.text,
        password: password.text,
      );

      await _createUserProfile(userStore);
    } on FirebaseAuthException catch (e) {
      if (e.toString().contains('already in use')) {
        await _createUserProfile(userStore);
      } else {
        setState(
          () => errorMessage = e.message ?? 'Authentication error occurred',
        );
      }
    } catch (e) {
      setState(() => errorMessage = 'An unexpected error occurred');
    }
  }

  Future<void> _createUserProfile(UserStore userStore) async {
    await userStore.createUser(
      name.text,
      email.text,
      username.text,
      password.text,
    );

    if (userStore.error != null) {
      setState(() => errorMessage = userStore.error!);
    }
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    username.dispose();
    errorMessage = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userStore = Provider.of<UserStore>(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 250, left: 10, right: 10),
        child: Column(
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.black, fontSize: 20),
              controller: name,
              keyboardType: TextInputType.text,
              inputFormatters: [Capitalize()],
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20),
                errorStyle: TextStyle(
                  color: Colors.redAccent, // deep pink para erro
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
                labelText: 'nome',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(150, 0, 60, 1),
                  fontSize: 20,
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite um nome';
                }

                if (!(value.trim().split(RegExp(r'\s+')).length > 1)) {
                  return 'Digite seu nome completo';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            TextFormField(
              style: const TextStyle(color: Colors.black, fontSize: 20),
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20),
                errorStyle: TextStyle(
                  color: Colors.redAccent, // deep pink para erro
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
                labelText: 'email',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(150, 0, 60, 1),
                  fontSize: 20,
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite um email';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: password,
              keyboardType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [LowerCaseTextFormatter()],
              style: const TextStyle(color: Colors.black, fontSize: 20),
              obscureText: _hideText,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
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
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite uma senha';
                }
                if (value.length < 6) {
                  return 'A senha deve ter no mínimo 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: username,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [LowerCaseTextFormatter()],
              style: const TextStyle(color: Colors.black, fontSize: 20),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20),
                errorStyle: TextStyle(
                  color: Colors.redAccent, // deep pink para erro
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
                labelText: 'username',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(150, 0, 60, 1),
                  // cor do texto de erro
                  fontSize: 20,
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite um username';
                }

                return null;
              },
            ),
            if (errorMessage.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ],
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.all(25)),
                    backgroundColor: WidgetStateProperty.all(
                      Color.fromRGBO(233, 30, 99, 1),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      handleCreate(userStore);
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Criar',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
