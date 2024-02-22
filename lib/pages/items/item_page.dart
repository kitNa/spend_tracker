import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class ItemPage extends StatefulWidget {
  final bool isDeposit;
  const ItemPage({super.key, required this.isDeposit});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final Map<String, dynamic> _formData = <String, dynamic>{};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _formData['isDeposit'] = widget.isDeposit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Item'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState?.save();
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
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (var value) => _descriptionValidator(value),
                  onSaved: (var value) => _saveDescription(value),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  validator: (var value) => _amountValidator(value),
                  onSaved: (var value) => _saveAmount(value),
                ),
                Row(
                  children: [
                    Checkbox(
                        activeColor: Colors.black87,
                        value: _formData['isDeposit'],
                        onChanged: (bool? value) {
                          setState(() {
                            _formData['isDeposit'] = value!;
                          });
                        }),
                    const Text('Is deposit? '),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        color: Colors.black87,
                        onPressed: () async {
                          //Существуют и другие виджеты, помогающие работать с датами:
                          // DayPicker, MonthPicker и YearPicker.
                          var date = await showDatePicker(
                            context: context,
                            firstDate:
                                DateTime.now().add(const Duration(days: -365)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date == null) return;

                          setState(() {
                            _dateTime = date;
                          });
                        },
                        icon: const Icon(Icons.date_range)),
                    Text(DateFormat('dd/MM/yyyy').format(_dateTime)),
                  ],
                ),
                //  const Padding(padding: EdgeInsets.only(right: 10)),
                DropdownButtonFormField<int>(
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                      labelText: 'Source',
                      iconColor: Colors.black87,
                      icon: Icon(Icons.source_outlined)),
                  iconDisabledColor: Colors.black87,
                  iconEnabledColor: Colors.black87,
                  //dropdownColor: Colors.orangeAccent,
                  //focusColor: Colors.black87,
                  items: const [
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text('Credit Card'),
                    ),
                    DropdownMenuItem<int>(value: 2, child: Text('Cash'))
                  ],
                  validator: (var value) => _descriptionValidator(value),
                  onChanged: (var value) {
                    _formData['accountId'] = value;
                  },
                ),
                DropdownButtonFormField<int>(
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                      labelText: 'Purpose',
                      iconColor: Colors.black87,
                      icon: Icon(Icons.source_outlined)),
                  iconDisabledColor: Colors.black87,
                  iconEnabledColor: Colors.black87,
                  //dropdownColor: Colors.orangeAccent,
                  //focusColor: Colors.black87,
                  items: const [
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text('products'),
                    ),
                    DropdownMenuItem<int>(value: 2, child: Text('medicine'))
                  ],
                  validator: (var value) => _descriptionValidator(value),
                  onChanged: (var value) {
                    _formData['purposeId'] = value;
                  },
                )
              ],
            ),
          ),
        ));
  }

  String? _descriptionValidator(var value) {
    if (value.isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? _amountValidator(var value) {
    if (value.isEmpty) {
      return 'Required';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid number';
    }
    return null;
  }

  void _saveDescription(var value) {
    _formData['description'] = value;
  }

  void _saveAmount(var value) {
    _formData['amount'] = double.parse(value);
  }
}
