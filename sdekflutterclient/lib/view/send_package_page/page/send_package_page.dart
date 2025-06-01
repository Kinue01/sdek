import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/PackageItem.dart';
import 'package:clientapp/domain/model/PackagePaytype.dart';
import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/model/Service.dart';
import 'package:clientapp/view/send_package_page/controller/send_package_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SendPackagePage extends StatelessWidget {
  const SendPackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SendPackageView();
  }
}

class SendPackageView extends StatefulWidget with GetItStatefulWidgetMixin {
  SendPackageView({super.key});

  @override
  State<StatefulWidget> createState() {
    return SendPackageViewState();
  }
}

class SendPackageViewState extends State<SendPackageView> with GetItStateMixin {
  late SendPackageController? controller;

  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem> dropItems = List.empty();
  List<DropdownMenuItem> clientItems = List.empty();
  List<DropdownMenuItem> serviceItems = List.empty();
  List<DropdownMenuItem> paytypesItems = List.empty();
  Service selectedService = Service();

  @override
  void initState() {
    super.initState();
    controller = get<SendPackageController>();
    Future.delayed(Duration.zero, () async => {
      await controller?.populatelLists()
    });
    controller?.packageTypes.addListener(() {
      setState(() {
        dropItems = controller!.packageTypes.value.map((PackageType type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type.type_name!),
          );
        }).toList();
      });
    });
    controller?.clients.addListener(() {
      setState(() {
        clientItems = controller!.clients.value.map((Client type) {
          return DropdownMenuItem(
            value: type,
            child: Text("${type.client_lastname} ${type.client_firstname}"),
          );
        }).toList();
      });
    });
    controller?.services.addListener(() {
      setState(() {
        serviceItems = controller!.services.value.map((Service serv) {
          return DropdownMenuItem(
            value: serv,
            child: Text(serv.service_name!),
          );
        }).toList();
      });
    });
    controller?.paytypes.addListener(() {
      setState(() {
        paytypesItems = controller!.paytypes.value.map((PackagePaytype type) {
          return DropdownMenuItem(
            value: type,
              child: Text(type.type_name!)
          );
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отправить посылку')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  //padding: const EdgeInsets.all(15),
                  child: DropdownButtonFormField(
                    //key: UniqueKey(),
                    decoration: const InputDecoration(labelText: 'Способ оплаты'),
                    items: paytypesItems,
                    onChanged: (value) {
                      setState(() {
                        controller?.paytype = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Выберите способ оплаты';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  //padding: const EdgeInsets.all(15),
                  child: DropdownButtonFormField(
                    //key: UniqueKey(),
                    decoration: const InputDecoration(labelText: 'Получатель'),
                    items: clientItems,
                    onChanged: (value) {
                      setState(() {
                        controller?.selectedClient = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Выберите получателя';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  //padding: const EdgeInsets.all(15),
                  child: DropdownButtonFormField(
                    //key: UniqueKey(),
                    decoration: const InputDecoration(labelText: 'Отправитель'),
                    items: clientItems,
                    onChanged: (value) {
                      controller?.selectedClientSender = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Выберите отправителя';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  //padding: const EdgeInsets.all(15),
                  child: DropdownButtonFormField(
                    //key: UniqueKey(),
                    decoration: const InputDecoration(labelText: 'Плательщик'),
                    items: const <DropdownMenuItem>[
                      DropdownMenuItem(
                          value: 1,
                          child: Text('Отправитель')
                      ),
                      DropdownMenuItem(
                          value: 2,
                          child: Text('Получатель')
                      ),
                    ],
                    onChanged: (value) {
                      controller?.payer = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Выберите тип посылки';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Список предметов:'),
                Text('Список услуг:')
              ],
            ),
            const SizedBox(width: 50),
            Row(
              children: <Widget>[
                Expanded(
                  //padding: const EdgeInsets.all(15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: controller?.items.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(controller!.items.value[index].item_name!, textAlign: TextAlign.center);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  //padding: const EdgeInsets.all(15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: controller?.selectedServices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(controller!.selectedServices[index].service_name!, textAlign: TextAlign.center,);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    showAdaptiveDialog(context: context, builder: (context) => AlertDialog(
                      title: const Text('Добавление предмета'),
                      content: Column(
                        children: <Widget>[
                          TextField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Название'
                            ),
                            onChanged: (value) => controller?.itemName.value = value,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Описание'
                            ),
                            onChanged: (value) => controller?.itemDesc.value = value,
                            maxLines: 3,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Длина'
                            ),
                            onChanged: (value) => controller?.itemLength.value = double.parse(value),
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Ширина'
                            ),
                            onChanged: (value) => controller?.itemWidth.value = double.parse(value),
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Высота'
                            ),
                            onChanged: (value) => controller?.itemHeigth.value = double.parse(value),
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Вес'
                            ),
                            onChanged: (value) => controller?.itemWeight.value = double.parse(value),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              setState(() {
                                controller?.items.value.add(PackageItem(
                                    item_name: controller?.itemName.value,
                                    item_description: controller?.itemDesc.value,
                                    item_length: controller?.itemLength.value,
                                    item_width: controller?.itemWidth.value,
                                    item_heigth: controller?.itemHeigth.value,
                                    item_weight: controller?.itemWeight.value,
                                    item_id: 1
                                ));
                              });
                            },
                            child: const Text('Добавить')
                        )
                      ],
                    ));
                  },
                  child: const Text('Добавить предмет'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showAdaptiveDialog(context: context, builder: (context) => AlertDialog(
                      title: const Text('Добавление услуги'),
                      content: Column(
                        children: <Widget>[
                          DropdownButtonFormField(
                            //key: UniqueKey(),
                            decoration: const InputDecoration(labelText: 'Сервис'),
                            items: serviceItems,
                            onChanged: (value) {
                              selectedService = value;
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Выберите тип посылки';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              setState(() {
                                controller?.selectedServices.add(selectedService);
                              });
                            },
                            child: const Text('Добавить')
                        )
                      ],
                    ));
                  },
                  child: const Text('Добавить услугу'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && controller!.selectedServices.isNotEmpty && controller!.items.value.isNotEmpty) {
                  _formKey.currentState!.save();
                  await controller?.addPackage();
                }
                else {
                  showAdaptiveDialog(context: context, builder: (builder) => const AlertDialog(
                    title: Text("Ошибка"),
                    content: Text("Заполните списки с предметами и услугами"),
                  ));
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}