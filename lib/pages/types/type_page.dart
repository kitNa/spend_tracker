import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.type != null) {
      _data = widget.type!.toMap();
    } else {
      _data = <String, dynamic>{};
      _data!['codePoint'] = Icons.add.codePoint;
    }
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<FirebaseBloc>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Type'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  _saveNewAccountInfo(_data!, bloc);
                  setState(() {
                    _isSaving = true;
                  });
                },
                icon: const Icon(Icons.save)),
          ],
        ),
        body: _isSaving
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      IconHolder(
                          tagUrlId:
                              widget.type == null ? '0' : widget.type!.urlId,
                          newIcon:
                              IconHelper.createIconData(_data!['codePoint']),
                          onIconChange: (IconData iconData) {
                            setState(() {
                              _data!['codePoint'] = iconData.codePoint;
                            });
                          }),
                      TextFormField(
                        initialValue:
                            widget.type != null ? widget.type?.name : '',
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (var value) => _nameValidator(value),
                        onSaved: (var value) => _data!['name'] = value,
                      )
                    ],
                  ),
                )));
  }

  void _saveNewAccountInfo(Map<String, dynamic> data, var bloc) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    var type = ItemType.fromMap(data);
    if (type.urlId == null) {
      await bloc.createType(type);
    } else {
      await bloc.updateType(type);
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  String? _nameValidator(var value) {
    if (value == null || value.isEmpty) return 'Required';
    return null;
  }
}
