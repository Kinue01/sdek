import 'package:clientapp/view/navigation_service/FluroApp.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeComponent();
  }
}

class HomeComponent extends StatefulWidget with GetItStatefulWidgetMixin {
  HomeComponent({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeComponent> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Package Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Send Package Page
                FluroApp.router.navigateTo(context, "/send_package");
              },
              child: const Text('Send a Package'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Track Package Page
                FluroApp.router.navigateTo(context, "/track_package");
              },
              child: const Text('Track a Package'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent Packages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(child: RecentPackagesList()),
          ],
        ),
      ),
    );
  }
}

class RecentPackagesList extends StatelessWidget {
  final List<String> packages = [
    'Package 1 - Delivered',
    'Package 2 - In Transit',
    'Package 3 - Pending',
  ];

  RecentPackagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: packages.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(packages[index]),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to package details page (not implemented)
            },
          ),
        );
      },
    );
  }
}