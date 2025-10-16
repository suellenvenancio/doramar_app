import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/app_bar.dart';
import '../service/auth_service.dart';
import '../utils/input_formater.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 174, 201, 1),
      appBar: CustomAppBar(title: 'Redefinir Senha'),
      body: const ResetPasswordForm(),
    );
  }
}

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  ResetPasswordFormState createState() {
    return ResetPasswordFormState();
  }
}

class ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();

  void resetPassword() async {
    try {
      await authService.value.resetPassword(email: email.text);
      showSnackBar();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  showSnackBar() {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.pink,
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Por favor, cheque seu email!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 250, left: 10, right: 10),
        child: Column(
          children: [
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(25),
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
                labelText: 'Enter your email',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(150, 0, 60, 1),
                  fontSize: 20,
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
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
                    resetPassword();
                  },
                  child: const Text(
                    'Reenviar Senha',
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
