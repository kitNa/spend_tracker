import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  widget({required Text child}) {}

  @override
  Widget build(BuildContext context) {
    var color = Theme
        .of(context)
        .primaryColor;
    var bloc = Provider.of<FirebaseBloc>(context);
    return SizedBox(
      width: 150,
      //return  SingleChildScrollView(
      // scrollDirection: Axis.vertical,
      child: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                // height: 500,
                alignment: Alignment.center,
                child: Text(
                  'MENU',
                  style: TextStyle(
                    fontSize: 20,
                    color: color,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                color: Colors.black,
              ),
              _MenuItem(
                  title: 'Accounts',
                  color: color,
                  icon: Icons.account_balance,
                  onTap: () {
                    bloc.getAccounts();
                    onNavigation(context,'/accounts');
                    }
              ),
              const Divider(
                height: 20,
                color: Colors.black,
              ),
              _MenuItem(
                color: color,
                title: 'Budget Items',
                icon: Icons.attach_money,
                onTap: () {
                  bloc.getItems();
                  onNavigation(context, '/items');
                },
              ),
              const Divider(
                height: 20,
                color: Colors.black,
              ),
              _MenuItem(
                color: color,
                title: 'Types',
                icon: Icons.widgets,
                onTap: () {
                  bloc.getTypes();
                  onNavigation(context, '/types');
                }
              ),
              const Divider(
                height: 20,
                color: Colors.black,
              ),
              _MenuItem(
                color: color,
                title: 'Bar Chart',
                icon: Icons.bar_chart,
                onTap: () {
                  bloc.balance;
                  onNavigation(context, '/bar_chart');
                },
              ),
              const Divider(
                height: 20,
                color: Colors.black,
              ),
              _MenuItem(
                color: color,
                title: 'Animation example',
                icon: Icons.add_a_photo_outlined,
                onTap: () => onNavigation(context, '/animation'),
              ),
              _MenuItem(
                color: color,
                title: 'Logout',
                icon: Icons.security,
                onTap: () => onNavigation(context, '/'),
              ),
              //  ListTile(
              //    title: const Text('Accounts'),
              //      onTap: () => Navigator.of(context).pushNamed('/accounts'),
              //  ),
              //  ListTile(
              //    title: const Text('Budget Items'),
              //    onTap: () => Navigator.of(context).pushNamed('/items'),
              //  ),
              // ListTile(
              //   title: const Text('Types'),
              //   onTap: () => Navigator.of(context).pushNamed('/types'),
              // ),
            ],
          )),
    );
  }

  void onNavigation(BuildContext context, String uri) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(uri);
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.color,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Opacity(
            opacity: 0.6,
            child: Container(
              height: 70,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Icon(
                    icon,
                    color: color,
                    size: 40,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            )));
  }
}
