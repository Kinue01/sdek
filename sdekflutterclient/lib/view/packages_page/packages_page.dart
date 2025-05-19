import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/model/Warehouse.dart';
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
    'package_warehouse': null,
    'package_deliveryperson': null
  };

  @override
  void initState() {
    super.initState();
    _controller = get();
    Future.delayed(Duration.zero, () async {
      await _controller.init();
      setState(() {

      });
    });
  }

  // Dummy filter UI, can be extended
  Widget buildFilterChips() {
    return Wrap(
      spacing: 8,
      children: [
        DropdownMenu<PackageStatus>(
          label: Text("Status"),
          onSelected: (PackageStatus? status) {
            filters['package_status'] = status;
            filteredPackages();
          },
            dropdownMenuEntries: _controller.packStatuses
                .map<DropdownMenuEntry<PackageStatus>>((PackageStatus status) => DropdownMenuEntry<PackageStatus>(value: status, label: status.status_name!)).toList()
        ),
        DropdownMenu<PackageType>(
          label: Text("Type"),
            onSelected: (PackageType? status) {
              filters['package_type'] = status;
              filteredPackages();
            },
            dropdownMenuEntries: _controller.packTypes
                .map<DropdownMenuEntry<PackageType>>((PackageType status) => DropdownMenuEntry<PackageType>(value: status, label: status.type_name!)).toList()
        ),
        DropdownMenu<Client>(
          label: Text("Sender"),
            onSelected: (Client? status) {
              filters['package_sender'] = status;
              filteredPackages();
            },
            dropdownMenuEntries: _controller.clients
                .map<DropdownMenuEntry<Client>>((Client status) => DropdownMenuEntry<Client>(value: status, label: "${status.client_lastname!} ${status.client_firstname!} ${status.client_middlename!}")).toList()
        ),
        DropdownMenu<Client>(
          label: Text("Receiver"),
            onSelected: (Client? status) {
              filters['package_receiver'] = status;
              filteredPackages();
            },
            dropdownMenuEntries: _controller.clients
                .map<DropdownMenuEntry<Client>>((Client status) => DropdownMenuEntry<Client>(value: status, label: "${status.client_lastname!} ${status.client_firstname!} ${status.client_middlename!}")).toList()
        ),
        DropdownMenu<Warehouse>(
            label: Text("Warehouse"),
            onSelected: (Warehouse? status) {
              filters['package_warehouse'] = status;
              filteredPackages();
            },
            dropdownMenuEntries: _controller.warehouses
                .map<DropdownMenuEntry<Warehouse>>((Warehouse status) => DropdownMenuEntry<Warehouse>(value: status, label: status.warehouse_name!)).toList()
        ),
        DropdownMenu<DeliveryPerson>(
            label: Text("Delivery person"),
            onSelected: (DeliveryPerson? status) {
              filters['package_deliveryperson'] = status;
              filteredPackages();
            },
            dropdownMenuEntries: _controller.delivery
                .map<DropdownMenuEntry<DeliveryPerson>>((DeliveryPerson status) => DropdownMenuEntry<DeliveryPerson>(value: status, label: "${status.person_lastname!} ${status.person_firstname!} ${status.person_middlename!}")).toList()
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
              pkg.package_type!.type_id! == filters['package_type'].type_id!);

      final matchesStatus = filters['package_status'] == null ||
          (pkg.package_status != null &&
              pkg.package_status!.status_id! == filters['package_status'].status_id!);

      final matchesSender = filters['package_sender'] == null ||
          (pkg.package_sender != null &&
              pkg.package_sender!.client_id! == filters['package_sender'].client_id!);

      final matchesReceiver = filters['package_receiver'] == null ||
          (pkg.package_receiver != null &&
              pkg.package_receiver!.client_id! == filters['package_receiver'].client_id!);

      final matchesWarehouse = filters['package_warehouse'] == null ||
          (pkg.package_warehouse != null &&
              pkg.package_warehouse!.warehouse_id! == filters['package_warehouse'].warehouse_id!);

      final matchesDelivery = filters['package_deliveryperson'] == null ||
          (pkg.package_deliveryperson != null &&
              pkg.package_deliveryperson!.person_id! == filters['package_deliveryperson'].person_id!);

      return matchesSearch &&
          matchesType &&
          matchesStatus &&
          matchesSender &&
          matchesReceiver &&
          matchesWarehouse &&
          matchesDelivery;
    }).toList();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    var list = watchX((PackagesPageController c) => c.filteredPackages);

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
                  searchQuery = value;
                  filteredPackages();
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
