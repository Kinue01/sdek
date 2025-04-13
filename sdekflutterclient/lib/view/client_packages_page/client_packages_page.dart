import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/view/client_package_details/client_package_details_controller.dart';
import 'package:clientapp/view/client_package_item/client_package_item.dart';
import 'package:clientapp/view/client_package_item_header/client_package_item_header.dart';
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
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async => {
      await get<ClientPackagesPageController>().getPackages()
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = watchX((ClientPackagesPageController c) => c.packages);

    return Expanded(
      //padding: const EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return ClientPackageItem(item: item, onTap: _goToDetails);
        },
      ),
    );
  }

  void _goToDetails(Package character) {
    get<ClientPackageDetailsController>().package = character;
    FluroApp.router.navigateTo(context, "/details");
  }
}