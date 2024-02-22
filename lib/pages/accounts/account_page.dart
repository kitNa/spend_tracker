import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/icons/icons_page.dart';

import '../icons/icon_holder.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final Map<String, dynamic> _data = <String, dynamic>{};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  IconData _newIcon = Icons.add;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Account'),
        actions: <Widget>[
          IconButton(
              onPressed: () => _saveNewAccountInfo(),
              icon: const Icon(Icons.save))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              IconHolder(
                newIcon: _newIcon,
                onIconChange: (IconData iconData) {
                  setState(() {
                    _newIcon = iconData;
                  });
                },
              ),
              //Существует два виджета, которые позволяют захватывать текстовый
              // ввод: Text Field и TextFormField. Оба наследуются от
              // StatefulWidget, но TextFormField является производным
              // непосредственно от класса FormField. Класс FormField добавляет
              // дополнительные вспомогательные функции, которые при использовании
              // с виджетом Form упрощают проверку и сохранение данных из
              // нескольких полей одновременно.
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (var value) => _nameValidator(value),
                onSaved: (value) => _data['name'] = value,
              ),
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Balance',
                ),
                validator: (var value) => _balanceValidator(value),
                onSaved: (value) => _data['balance'] = double.parse(value!),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveNewAccountInfo() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    Navigator.of(context).pop();
  }

  String? _nameValidator(var value) {
    if (value == null || value.isEmpty) return 'Required';
    return null;
  }

  String? _balanceValidator(var value) {
    if (value == null || value.isEmpty) return 'Required';
    if (double.tryParse(value) == null) return 'Invalid number';
    return null;
  }
}
