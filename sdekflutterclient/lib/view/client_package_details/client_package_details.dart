import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/view/client_package_details/client_package_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ClientPackageDetails extends StatelessWidget {
  const ClientPackageDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClientPackageComponent();
  }
}

class ClientPackageComponent extends StatefulWidget with GetItStatefulWidgetMixin {
  ClientPackageComponent({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return ClientPackageState();
  }
}

class ClientPackageState extends State<ClientPackageComponent> with GetItStateMixin {
  late ClientPackageDetailsController controller;

  @override
  void initState() {
    controller = get<ClientPackageDetailsController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Посылка ${controller.package.package_uuid!}")
      ),
      body: _Content(package: controller.package),
    );
  }
}

class _Content extends StatelessWidget with GetItMixin {
  final Package package;

  _Content({
    required this.package
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Дата отправки: ${package.package_send_date}"),
            Text("Дата получения: ${package.package_receive_date}"),
            Text("Вес: ${package.package_weight} kg"),
            Text("Статус посылки: ${package.package_status?.status_name}"),
            const SizedBox(height: 16),

            // Sender Info
            const Text("Отправитель:"),
            Text("Имя: ${package.package_sender?.client_lastname} ${package.package_sender?.client_firstname}"),
            // Text("Email: ${package.package_sender?.client_user.user_email}"),
            // Text("Phone: ${package.package_sender?.client_user.user_phone}"),
            const SizedBox(height: 16),

            // Receiver Info
            const Text("Получатель:"),
            Text("Имя: ${package.package_receiver?.client_lastname} ${package.package_receiver?.client_firstname}"),
            // Text("Email: ${package.package_receiver?.client_user.user_email}"),
            // Text("Phone: ${package.package_receiver?.client_user.user_phone}"),
            const SizedBox(height: 16),

            // Delivery Person Info
            const Text("Курьер:"),
            Text("Имя: ${package.package_deliveryperson?.person_lastname} ${package.package_deliveryperson?.person_firstname}"),
            // Text("Email: ${packageData['package_deliveryperson']['person_user']['user_email']}"),
            Text("Телефон: ${package.package_deliveryperson?.person_user?.user_phone}"),
            Text("Транспорт: ${package.package_deliveryperson?.person_transport?.transport_name}"),
            Text("Статус транспорта: ${package.package_deliveryperson?.person_transport?.transport_status?.status_name}"),
            const SizedBox(height: 16),

            // Payment Type
            Text("Вид оплаты: ${package.package_paytype?.type_name}"),
            const SizedBox(height: 16),

            // Package Items
            const Text("Предметы:"),
            for (var item in package.package_items!)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Название: ${item.item_name}"),
                  Text("Описание: ${item.item_description}"),
                  Text("Размеры: ${item.item_length} x ${item.item_width} x ${item.item_heigth} cm"),
                  Text("Вес: ${item.item_weight} kg"),
                  const SizedBox(height: 8),
                ],
              ),
          ],
        ),
      )
    );
  }
}