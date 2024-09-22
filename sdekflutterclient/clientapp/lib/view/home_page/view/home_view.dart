import 'package:flutter/material.dart';

class HomeComponent extends StatefulWidget {
  const HomeComponent({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeComponent> {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SendPackagePage()),
                );
              },
              child: const Text('Send a Package'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Track Package Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrackPackagePage()),
                );
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

class SendPackagePage extends StatelessWidget {
  const SendPackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Package')),
      body: const Center(child: Text('Send Package Form Here')),
    );
  }
}

class TrackPackagePage extends StatelessWidget {
  const TrackPackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Package')),
      body: const Center(child: Text('Track Package Form Here')),
    );
  }
}