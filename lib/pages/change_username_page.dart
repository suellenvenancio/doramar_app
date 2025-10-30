import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import '../utils/input_formater.dart';

class ChangeUsernamePage extends StatelessWidget {
  const ChangeUsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 174, 201, 1),
      appBar: AppBar(
        title: Text(
          'Alterar Username',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: const Color.fromRGBO(233, 30, 99, 1),
      ),
      body: const ChangeUsernameForm(),
    );
  }
}

class ChangeUsernameForm extends StatefulWidget {
  const ChangeUsernameForm({super.key});

  @override
  ChangeUsernameFormState createState() {
    return ChangeUsernameFormState();
  }
}

class ChangeUsernameFormState extends State<ChangeUsernameForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController username = TextEditingController();

  void handleCreate() async {
    try {
      await authService.value.updateUsername(username: username.text);
      showSnackBar();
    } on FirebaseAuthException catch (e) {
      showSnackBarError(e);
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
          'Username alterado com sucesso!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  showSnackBarError(FirebaseAuthException e) {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.pink,
        behavior: SnackBarBehavior.floating,
        content: Text(
          e.message ?? 'Erro ao alterar o username!',
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
              controller: username,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
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
                labelText: 'username',
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
                  onPressed: () {
                    handleCreate();

                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text(
                    'Atualizar',
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
