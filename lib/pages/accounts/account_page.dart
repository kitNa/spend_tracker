import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/pages/icons/icons_page.dart';
import 'package:spend_tracker/database/db_provider.dart';
import '../../models/account.dart';
import '../../support/icon_helper.dart';
import '../icons/icon_holder.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({this.account, super.key});

  final Account? account;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, dynamic>? _data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  IconData _newIcon = Icons.add;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _data = widget.account!.toMap();
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
        title: const Text('Account'),
        actions: <Widget>[
          IconButton(
              onPressed: () => _saveNewAccountInfo(_data!, dbProvider),
              icon: const Icon(Icons.save)),
        ],
      ),
      body: Form(
        key: _formKey,
        canPop: !_hasChanges,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          _showDialog();
        },
        onChanged: () => _hasChanges = true,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              IconHolder(
                //codePoint - свойство типа int для идентификации значка в
                // файле шрифта
                newIcon: IconHelper.createIconData(_data!['codePoint']),
                onIconChange: (IconData iconData) {
                  _hasChanges = true;
                  setState(() {
                    _data!['codePoint'] = iconData.codePoint;
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
                initialValue:
                widget.account != null ? widget.account!.name : '',
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (var value) => _nameValidator(value),
                onSaved: (value) => _data?['name'] = value,
              ),
              TextFormField(
                initialValue: widget.account != null
                    ? widget.account!.balance.toString()
                    : '',
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Balance',
                ),
                validator: (var value) => _balanceValidator(value),
                onSaved: (value) => _data?['balance'] = double.parse(value!),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog() async {
    final bool? shouldDiscard = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Any unsaved changes will be lost!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes, discard my changes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/');
                },
              ),
              TextButton(
                child: const Text('No, continue editing'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }

  void _saveNewAccountInfo(Map<String, dynamic> data, var dbProvider) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    var account = Account.fromMap(data);
    if (account.id == null) {
      await dbProvider.createAccount(account);
    } else {
      await dbProvider.updateAccount(account);
    }
    if (context.mounted) Navigator.of(context).pop();
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
