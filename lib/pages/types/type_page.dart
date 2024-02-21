import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/icons/icon_holder.dart';

class TypePage extends StatefulWidget {
  const TypePage({super.key});

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  final Map<String, dynamic> _data = <String, dynamic>{};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  IconData _newIcon = Icons.add;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Type'),
          actions: <Widget>[
            IconButton(
                onPressed: () => _saveNewAccountInfo(),
                icon: const Icon(Icons.save)),
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
                      }),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (var value) => _nameValidator(value),
                    onSaved: (var value) => _data['name'] = value,
                  )
                ],
              ),
            )
        )
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
}
