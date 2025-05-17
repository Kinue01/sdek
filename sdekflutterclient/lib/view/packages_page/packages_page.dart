import 'package:clientapp/view/client_package_details/client_package_details.dart';
import 'package:clientapp/view/packages_page/packages_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../../domain/model/Package.dart';
import '../client_package_details/client_package_details_controller.dart';
import '../navigation_service/FluroApp.dart';

class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PackagesComponent();
  }
}

class PackagesComponent extends StatefulWidget with GetItStatefulWidgetMixin {
  @override
  State<StatefulWidget> createState() {
    return PackagesState();
  }
}

class PackagesState extends State<PackagesComponent> with GetItStateMixin {
  late PackagesPageController _controller;

  String searchQuery = '';
  Map<String, dynamic> filters = {
    'package_type': null,
    'package_status': null,
    'package_sender': null,
    'package_receiver': null,
    // Add more filters as needed
  };

  @override
  void initState() {
    super.initState();
    _controller = get();
  }

  // Dummy filter UI, can be extended
  Widget buildFilterChips() {
    return Wrap(
      spacing: 8,
      children: [
        FilterChip(
          label: Text('Type'),
          selected: filters['package_type'] != null,
          onSelected: (_) {
            setState(() {
              filters['package_type'] =
                  filters['package_type'] == null ? 'Electronics' : null;
              filteredPackages();
            });
          },
        ),
        FilterChip(
          label: Text('Status'),
          selected: filters['package_status'] != null,
          onSelected: (_) {
            setState(() {
              filters['package_status'] =
                  filters['package_status'] == null ? 'Delivered' : null;
              filteredPackages();
            });
          },
        ),
        FilterChip(
          label: Text('Sender'),
          selected: filters['package_sender'] != null,
          onSelected: (_) {
            setState(() {
              filters['package_sender'] =
                  filters['package_sender'] == null ? 'John Doe' : null;
              filteredPackages();
            });
          },
        ),
        FilterChip(
          label: Text('Receiver'),
          selected: filters['package_receiver'] != null,
          onSelected: (_) {
            setState(() {
              filters['package_receiver'] =
                  filters['package_receiver'] == null ? 'Jane Smith' : null;
              filteredPackages();
            });
          },
        ),
      ],
    );
  }

  // Method to filter packages based on search and filter criteria
  void filteredPackages() {
    _controller.filteredPackages.value = _controller.packages.where((pkg) {
      // Search by package_uuid
      final matchesSearch = pkg.package_uuid != null &&
          pkg.package_uuid!.toLowerCase().contains(searchQuery.toLowerCase());

      // Apply additional filters
      final matchesType = filters['package_type'] == null ||
          (pkg.package_type != null &&
              pkg.package_type!.type_name!
                  .toLowerCase()
                  .contains(filters['package_type'].toLowerCase()));

      final matchesStatus = filters['package_status'] == null ||
          (pkg.package_status != null &&
              pkg.package_status!.status_name!
                  .toLowerCase()
                  .contains(filters['package_status'].toLowerCase()));

      final matchesSender = filters['package_sender'] == null ||
          (pkg.package_sender != null &&
              pkg.package_sender!.client_lastname!
                  .toLowerCase()
                  .contains(filters['package_sender'].toLowerCase()));

      final matchesReceiver = filters['package_receiver'] == null ||
          (pkg.package_receiver != null &&
              pkg.package_receiver!.client_lastname!
                  .toLowerCase()
                  .contains(filters['package_receiver'].toLowerCase()));

      return matchesSearch &&
          matchesType &&
          matchesStatus &&
          matchesSender &&
          matchesReceiver;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = watchX((PackagesPageController c) => c.filteredPackages);

    return Scaffold(
        appBar: AppBar(title: Text('Посылки')),
        body: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search by Package UUID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            // Filter Chips
            buildFilterChips(),
            // Grid View
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust as needed
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final pkg = list[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to details page
                      get<ClientPackageDetailsController>().package = list[index];
                      FluroApp.router.navigateTo(context, "/details");
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UUID: ${pkg.package_uuid}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Type: ${pkg.package_type?.type_name ?? 'N/A'}',
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Status: ${pkg.package_status?.status_name ?? 'N/A'}',
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Weight: ${pkg.package_weight ?? 0} kg',
                            ),
                            // Add more info as needed
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
