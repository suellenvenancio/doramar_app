import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/list.store.dart';
import '../utils/input_formater.dart';

class ListFormModal extends StatefulWidget {
  const ListFormModal({super.key});

  @override
  ListFormModalState createState() {
    return ListFormModalState();
  }
}

class ListFormModalState extends State<ListFormModal> {
  final TextEditingController _listName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listName.text = '';
  }

  @override
  void dispose() {
    _listName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ListStore>(context);
    final isLoading = store.createListIsLoading;

    if (isLoading) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Criando lista...'),
          ],
        ),
      );
    }

    return AlertDialog(
      title: TextField(
        controller: _listName,
        keyboardType: TextInputType.text,
        inputFormatters: [LowerCaseTextFormatter()],
        decoration: InputDecoration(labelText: 'Nome da Lista'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Fechar', style: TextStyle(color: Colors.pink)),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.pink),
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          onPressed: () async {
            await store.createList(_listName.text);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lista criada com sucesso!'),
                backgroundColor: Colors.pink,
              ),
            );
            Navigator.of(context).pop();
          },
          child: Text('Criar Lista', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
