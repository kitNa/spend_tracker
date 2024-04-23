import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
import 'package:spend_tracker/models/account.dart';
import 'package:spend_tracker/models/item.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:spend_tracker/pages/home/home_page.dart';
import 'package:spend_tracker/routes.dart';

class ItemPage extends StatefulWidget {
  final bool isDeposit;

  const ItemPage({super.key, required this.isDeposit});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

// Flutter дозволяє нам підключитися до системи маршрутизації за допомогою
// кількох класів: RouteObserver і RouteAware. RouteAware — це міксин, який ми
// додаємо до віджета, який хоче підписатися на події маршруту. RouteObserver —
// це клас, на який підписуються віджети RouteAware. RouteObserver сповіщає
// віджети RouteAware про зміни маршруту.
class _ItemPageState extends State<ItemPage> with RouteAware {
  final Map<String, dynamic> _formData = <String, dynamic>{};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //List<Account> _accounts = [];
  //List<ItemType> _types = [];
  DateTime _dateTime = DateTime.now();
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _formData['isDeposit'] = widget.isDeposit;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _loadDropdownData();
    //віджет підписався на routeObserver
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  // Коли віджет підписаний на routeObserver, ми також повинні його видалити.
  // Пам'ятайте, що в життєвому циклі віджета State метод dispose викликається,
  // коли стан видаляється з дерева назавжди.
  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  //методи, didPop і didPush, не працюватимуть на домашній сторінці, але
  // працюватимуть на інших сторінках. Це пов'язано з тим, що наша домашня
  // сторінка є нашим початковим маршрутом. Він не штовхається і не вискакує на
  // стек з іншої сторінки. Це наша початкова сторінка.
  void didPop() {
    print('item_page did pop');
  }

  void didPush() {
    print('item_page did push');
  }

  // void _loadDropdownData() async {
  //   var dbProvider = Provider.of<DBProvider>(context, listen: false);
  //   var accounts = await dbProvider.getAccounts();
  //   var types = await dbProvider.getTypes();
  //
  //   //проверяем, смонтировано ли состояние.
  //   if (!mounted) return;
  //
  //   //устанавливаем состояние
  //   setState(() {
  //     _accounts = accounts;
  //     _types = types;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<FirebaseBloc>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Item'),
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState?.save();
                  setState(() {
                    _isSaving = true;
                  });
                  //В обработчиках событий, таких как onPressed , OnTap ,
                  // onLongPressed и т. д., мы должны использовать
                  // Provider.of<T>(context,listen:false)
                  // причина в том, что они не будут прослушивать какие-либо
                  // изменения в обновлениях, а вместо этого несут
                  // ответственность за внесение изменений. Тогда как виджеты,
                  // такие как текст и т. д., отвечают за отображение...
                  // следовательно, их необходимо обновлять при каждом
                  // внесенном изменении.... поэтому используйте
                  // Provider.of<T>(context,listen:true)  //by default is listen:true
                  // context.read<T>() is same as Provider.of<T>(context, listen: false)
                  // context.watch<T>() is same as Provider.of<T>(context)```
                  var dbProvider = context.read<DBProvider>();
                  _formData['date'] =
                      DateFormat('MM/dd/yyyy').format(_dateTime);
                  var item = Item.fromMap(_formData);
                  await bloc.createItem(item);
                  if (context.mounted) Navigator.of(context).pop();
                },
                icon: const Icon(Icons.save))
          ],
        ),
        body: _isSaving
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Description'),
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
                                  firstDate: DateTime.now()
                                      .add(const Duration(days: -365)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
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
                      _AccountsDropdownButton(
                        bloc: bloc,
                        urlId: _formData['accountUrlId'],
                        onChanged: (var value) {
                          _hasChanges = true;
                          setState(() {
                            _formData['accountUrlId'] = value;
                          });
                        },
                      ),
                      _TypesDropdownButton(
                        bloc: bloc,
                        urlId: _formData['typeUrlId'],
                        onChanged: (var value) {
                          _hasChanges = true;
                          setState(() {
                            _formData['typeUrlId'] = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ));
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

String? _descriptionValidator(var value) {
  if (value == null) {
    return 'Required';
  }
  return null;
}

class _TypesDropdownButton extends StatelessWidget {
  const _TypesDropdownButton({
    required this.bloc,
    required this.urlId,
    required this.onChanged,
  });

  final FirebaseBloc bloc;
  final String? urlId;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemType>>(
        stream: bloc.itemTypes,
        builder: (_, AsyncSnapshot<List<ItemType>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          var types = snapshot.data;
          if (types!.isEmpty) {
            return const Center(
              child: Text('No Records'),
            );
          }
          return DropdownButtonFormField<String>(
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
                labelText: 'Purpose',
                iconColor: Colors.black87,
                icon: Icon(Icons.source_outlined)),
            iconDisabledColor: Colors.black87,
            iconEnabledColor: Colors.black87,
            //dropdownColor: Colors.orangeAccent,
            //focusColor: Colors.black87,
            value: urlId,
            items: types
                .map((type) => DropdownMenuItem<String>(
                      value: type.urlId,
                      child: Text(type.name),
                    ))
                .toList(),
            validator: (var value) => _descriptionValidator(value),
            onChanged: onChanged,
          );
        });
  }
}

class _AccountsDropdownButton extends StatelessWidget {
  const _AccountsDropdownButton({
    required this.bloc,
    required this.urlId,
    required this.onChanged,
  });

  final FirebaseBloc bloc;
  final String? urlId;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Account>>(
        stream: bloc.accounts,
        builder: (_, AsyncSnapshot<List<Account>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          //FutureBuilder возвращает список, поэтому  snapshot
          // будет содержать список учетных записей.
          var accounts = snapshot.data;
          if (accounts!.isEmpty) {
            return const Center(
              child: Text('No Records'),
            );
          }

          return DropdownButtonFormField<String>(
              value: urlId,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                  labelText: 'Source',
                  iconColor: Colors.black87,
                  icon: Icon(Icons.source_outlined)),
              iconDisabledColor: Colors.black87,
              iconEnabledColor: Colors.black87,
              //dropdownColor: Colors.orangeAccent,
              //focusColor: Colors.black87,
              items: accounts
                  .map((account) => DropdownMenuItem<String>(
                        value: account.urlId,
                        child: Text(account.name),
                      ))
                  .toList(),
              validator: _descriptionValidator,
              onChanged: onChanged);
        });
  }
}

//В течение жизненного цикла виджета State последовательно вызываются и задаются
// несколько методов и свойств. Во-первых, это createState. Фреймворк вызывает
// этот метод после того, как элемент был добавлен в дерево. Вызывается только
// один раз. Затем свойству mount присваивается значение true.
// После этого идет initState. Это инициализирует состояние. Он вызывается
// только один раз в процессе создания. После этого вызывается
// didChangeDependencies. Вызывается при изменении зависимости состояния.
// Вызывается не только при первоначальном создании, но и при последующих
// обновлениях.
// Лучше всего, чтобы в этом методе выполнялись сетевые и другие асинхронные
// вызовы. После вызова этого метода вызывается метод сборки. Он вызывается
// всякий раз, когда состояние первоначально создается или обновляется.
// После этого вызывается метод didUpdateWidget. Вызывается при изменении
// конфигурации виджета. Оттуда у нас есть deactivate, вызываемый, когда виджет
// удаляется из дерева. Я удивлюсь, если вы когда-нибудь переопределите этот
// метод. Оттуда вызывается утилизация. Вызывается, когда объект удаляется
// из дерева навсегда.
