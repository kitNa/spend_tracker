import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/icons/icons_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, dynamic> _data = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  IconData _newIcon = Icons.add;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Account'),
        actions: <Widget>[
          IconButton(
              onPressed: (){
                if(!_formKey.currentState!.validate())return;
                _formKey.currentState!.save();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget> [
              InkWell(
                onTap: () async {
                  var iconData = await Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => IconsPage(),
                  ),
                  );
                  setState(() {
                    _newIcon == _newIcon ?? Icons.add;
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width:2,
                      color: Colors.black87,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 60,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              //Существует два виджета, которые позволяют захватывать текстовый
              // ввод: Text Field и TextFormField. Оба наследуются от
              // StatefulWidget, но TextFormField является производным
              // непосредственно от класса FormField. Класс FormField добавляет
              // дополнительные вспомогательные функции, которые при использовании
              // с виджетом Form упрощают проверку и сохранение данных из
              // нескольких полей одновременно.
              TextFormField(
                decoration: const InputDecoration (
                  labelText: 'Name',
                ),
                validator: (var value){
                  if(value == null || value.isEmpty) return 'Required';
                },
                onSaved: (value) => _data['name'] = value,
              ),
              TextFormField(
                keyboardType:TextInputType.numberWithOptions(
                    decimal: true
                ) ,
                decoration: const InputDecoration(
                  labelText: 'Balance',
                ),
                validator: (var value) {
                  if(value == null || value.isEmpty) return 'Required';
                  if(double.tryParse(value) == null) return 'Invalid number';
                },
                onSaved: (value) => _data['balance'] = double.parse(value!),
              )
            ],
          ),
        ),
      ),
    );
  }
}
