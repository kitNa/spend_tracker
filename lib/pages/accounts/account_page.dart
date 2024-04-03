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

//SingleTickerProviderStateMixin допомагає переконатися,що анімація запускається
// лише тоді, коли віджет видимий. Це запобіжить марнуванню циклів процесора
// анімацією, якщо віджет не видно на екрані.
class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //IconData _newIcon = Icons.add;
  bool _hasChanges = false;

  //_controller керує анімацією.
  late AnimationController _controller;

  //Анімація анімує Offset поля TextFormField.
  // За допомогою Зсуву ми можемо пересунути віджет з початкової позиції.
  // Зсув -3,0 переміщує віджет у 3 рази лівіше.
  late Animation<Offset> _animationName;
  late Animation<Offset> _animationBalance;

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _data = widget.account!.toMap();
    } else {
      _data = <String, dynamic>{};
      _data!['codePoint'] = Icons.add.codePoint;
    }
    //Параметр vsync name пов'язує контролер з віджетом, який реалізує
    // TickerProviderStateMixin. Тривалість - це те, як довго триватиме анімація.
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    //Тепер нам потрібно ініціалізувати наші анімації. Коли почнеться анімація,
    // ширина віджета буде втричі більшою за ширину ліворуч від початкової
    // позиції. Зсув - це відстань від початкового місця. Початковим
    // розташуванням є зсув (0,0). Зсув (-3,0) — це відстань ліворуч, яка втричі
    // більша за ширину віджета. Перше число в зміщенні - це вісь X. Друга -
    // вісь Y. Коли анімація завершиться, вони повернуться у вихідне положення.
    // Tween – це скорочення від in betwe. Якщо ви хочете відсунути від
    // наведеного вище, це буде Зсув (0, -3). Коли анімація буде завершена, вона
    // повернеться у вихідне положення зі зміщенням (0,0). Ми підключаємо
    // контролер до анімації методом .animate і передаємо _controller екземпляр.
    // _animationName =
    //     Tween<Offset>(begin: const Offset(-3, 0), end: const Offset(0, 0))
    //         .animate(_controller);
    _animationName =
        Tween<Offset>(begin: const Offset(-3, 0), end: const Offset(0, 0))

        // CurvedAnimation дозволяє нам додавати нелінійні криві або пряму лінію
        // до нашої анімації. Ми передаємо йому наш _controller як параметр
        // батьківського імені, і задаємо потрібний нам тип кривої. Тут ми даємо
        // йому часовий проміжок, коли починати і закінчувати. Інтервал 0.50 та
        // 1.0 вказує анімації починатися, коли контролер знаходиться на 50%
        // тривалості, і закінчувати анімацію в кінці тривалості.
            .animate(CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.50, 1.0, curve: Curves.easeInOutBack)));
    _animationBalance =
        Tween<Offset>(begin: const Offset(-3, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _controller,
            //Інтервал від 0.0 до 0.5 вказує анімації почати з початку
            // тривалості і закінчити до того моменту, коли контролер пройде
            // 50% від тривалості. Властивість кривої дозволяє нам сказати
            // анімації, як ми хочемо, щоб діяла наша нелінійна крива.
                curve: const Interval(0.0, 0.5, curve: Curves.easeInOutBack)));
    _controller.forward();
  }

  //дідPopNext викликається, коли ми повертаємося назад або витягуємо попередній
  //екран зі стека, щоб бути точнішим.
  // void didPopNext() async {
  //   _controller.forward();
  // }
  //
  // //didPushNext викликається, коли ми переходимо на інший екран.
  // void didPushNext() async {
  //   _controller.reset();
  // }

  @override
  void dispose() {
    super.dispose();
    //AnimationController має метод dispose, який потрібно викликати, коли
    // контролер більше не використовується, для очищення ресурсів. Для цього ми
    // перевизначаємо метод dispose віджета State і утилізуємо _controller.
    _controller?.dispose();
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
                tagId:
                    widget.account == null ? 0 : widget.account!.id as Object,
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

              //Цей віджет допомагає анімувати позицію віджета з його початкової
              // позиції за допомогою зсуву.
              SlideTransition(
                position: _animationName,
                child: TextFormField(
                  initialValue:
                      widget.account != null ? widget.account!.name : '',
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (var value) => _nameValidator(value),
                  onSaved: (value) => _data?['name'] = value,
                ),
              ),
              SlideTransition(
                position: _animationBalance,
                child: TextFormField(
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
                ),
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
