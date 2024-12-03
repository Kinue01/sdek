import 'package:clientapp/view/account_page/account_page.dart';
import 'package:clientapp/view/home_page/view/home_view.dart';
import 'package:clientapp/view/send_package_page/page/send_package_page.dart';
import 'package:clientapp/view/track_package_page/page/track_package_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainComponent();
  }

}

class MainComponent extends StatefulWidget {
  const MainComponent({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainState();
  }

}

class MainState extends State<MainComponent> {
  int _index = 0;

  final List<Widget> _views = [
    const HomePage(),
    const SendPackagePage(),
    // const TrackPackagePage(),
    const AccountPage()
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int index) => {
          setState(() {
            _index = index;
          })
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Дом'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Отправить'
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.track_changes),
          //   label: 'Отследить'
          // ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Аккаунт'
          ),
        ]
      ),
    );
  } 
}