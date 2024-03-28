import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:spend_tracker/support/icon_helper.dart';
import 'package:spend_tracker/pages/icons/icon_holder.dart';

class TypePage extends StatefulWidget {
  const TypePage({super.key, this.type});

  final ItemType? type;

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  Map<String, dynamic>? _data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.type != null){
      _data = widget.type!.toMap();
    } else {
      _data = <String, dynamic>{};
      _data!['codePoint'] = Icons.add.codePoint;
    }
  }

  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DBProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Type'),
          actions: <Widget>[
            IconButton(
                onPressed: () => _saveNewAccountInfo(_data!, dbProvider),
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
                      newIcon: IconHelper.createIconData(_data!['codePoint']),
                      onIconChange: (IconData iconData) {
                        setState(() {
                          _data!['codePoint'] = iconData.codePoint;
                        });
                      }),
                  TextFormField(
                    initialValue: widget.type != null ? widget.type?.name: '',
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (var value) => _nameValidator(value),
                    onSaved: (var value) => _data!['name'] = value,
                  )
                ],
              ),
            )));
  }

  void _saveNewAccountInfo(Map<String, dynamic> data, var dbProvider) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    var type = ItemType.fromMap(data);
    if (type.id == null) {
      await dbProvider.createType(type);
    } else {
      await dbProvider.updateType(type);
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  String? _nameValidator(var value) {
    if (value == null || value.isEmpty) return 'Required';
    return null;
  }
}
