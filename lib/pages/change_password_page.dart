import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import '../utils/input_formater.dart';

class ResetPasswordFromCurrentPasswordPage extends StatelessWidget {
  const ResetPasswordFromCurrentPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 174, 201, 1),
      appBar: AppBar(
        title: Text(
          'Registrar',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: const Color.fromRGBO(233, 30, 99, 1),
      ),
      body: const ResetPasswordFromCurrentPasswordForm(),
    );
  }
}

class ResetPasswordFromCurrentPasswordForm extends StatefulWidget {
  const ResetPasswordFromCurrentPasswordForm({super.key});

  @override
  ResetPasswordFromCurrentPasswordFormState createState() {
    return ResetPasswordFromCurrentPasswordFormState();
  }
}

class ResetPasswordFromCurrentPasswordFormState
    extends State<ResetPasswordFromCurrentPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController newPassword = TextEditingController();

  void handleChange() async {
    try {
      await authService.value.resetPasswordFromCurrentPassword(
        email: email.text,
        currentPassword: password.text,
        newPassword: newPassword.text,
      );
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
          'Senha alterada com sucesso!',
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
          spacing: 10,
          children: [
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: const InputDecoration(
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
                labelStyle: TextStyle(color: Color.fromRGBO(150, 0, 60, 1)),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: password,
              keyboardType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: const InputDecoration(
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
                labelText: 'password',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(150, 0, 60, 1),
                  // cor do texto de erro
                  fontWeight: FontWeight.bold,
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
            TextFormField(
              controller: newPassword,
              decoration: const InputDecoration(
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
                labelText: 'new password',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(150, 0, 60, 1),
                  // cor do texto de erro
                  fontWeight: FontWeight.bold,
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ButtonStyle(
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
                  handleChange();
                },
                child: const Text(
                  'Registrar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
