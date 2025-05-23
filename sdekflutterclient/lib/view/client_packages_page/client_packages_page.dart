import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/view/client_package_details/client_package_details_controller.dart';
import 'package:clientapp/view/client_package_item/client_package_item.dart';
import 'package:clientapp/view/client_packages_page/client_packages_page_controller.dart';
import 'package:clientapp/view/navigation_service/FluroApp.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ClientPackagesPage extends StatelessWidget {
  const ClientPackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClientPackagesComponent();
  }
}

class ClientPackagesComponent extends StatefulWidget with GetItStatefulWidgetMixin {
  ClientPackagesComponent({super.key});

  @override
  State<StatefulWidget> createState() {
    return ClientPackagesState();
  }
}

class ClientPackagesState extends State<ClientPackagesComponent> with GetItStateMixin {
  late ClientPackagesPageController _controller;
  late TextEditingController _searchController;
  var search = "";

  @override
  void initState() {
    super.initState();

    _controller = get<ClientPackagesPageController>();
    _searchController = TextEditingController();

    Future.delayed(Duration.zero, () async => {
      await _controller.getPackages()
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = watchX((ClientPackagesPageController c) => c.packages);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              leading: Icon(Icons.search),
              title: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: 'Search', border: InputBorder.none),
                onChanged: (text) {
                  search = text;
                },
              ),
              trailing: IconButton(
                  onPressed: () {
                    if (search.trim().isEmpty) {
                      Future.delayed(Duration.zero, () async => {
                        await _controller.getPackages()
                      });
                    }

                    var temp = _controller.packages.value;
                    _controller.packages.value = temp.where((p) => p.package_uuid!.contains(search)).toList(growable: true);
                  },
                  icon: Icon(Icons.search)
              )
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TextButton(
                  onPressed: () {
                    var temp = List<Package>.empty();
                    Future.delayed(Duration.zero, () async {
                      await _controller.getPackages();
                      temp = _controller.packages.value;
                      _controller.packages.value = temp.where((p) => p.package_status?.status_id == 2).toList(growable: true);
                    });
                  },
                  child: Text('Вывести посылки в пути')
              ),
              TextButton(
                  onPressed: () {
                    var temp = List<Package>.empty();
                    Future.delayed(Duration.zero, () async {
                      await _controller.getPackages();
                      temp = _controller.packages.value;
                      _controller.packages.value = temp.where((p) => p.package_status?.status_id == 3).toList(growable: true);
                    });
                  },
                  child: Text('Вывести доставленные посылки')
              ),
              TextButton(
                  onPressed: () {
                    Future.delayed(Duration.zero, () async => {
                      await _controller.getPackages()
                    });
                  },
                  child: Text('Сбросить')
              )
            ],
          )
        ),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return ClientPackageItem(item: item, onTap: _goToDetails);
            },
          ),
        )
      ],
    );
  }

  void _goToDetails(Package character) {
    get<ClientPackageDetailsController>().package = character;
    FluroApp.router.navigateTo(context, "/details");
  }
}