import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/model/WarehouseType.dart';
import 'package:clientapp/view/warehouses_page/warehouses_page_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class WarehousePage extends StatelessWidget {
  const WarehousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WarehouseComponent();
  }
}

class WarehouseComponent extends StatefulWidget with GetItStatefulWidgetMixin {
  @override
  State<StatefulWidget> createState() {
    return WarehouseState();
  }
}

class WarehouseState extends State<WarehouseComponent> with GetItStateMixin {
  late WarehousePageController _controller;

  late TextEditingController _nameController;
  late TextEditingController _addressController;

  late Warehouse selectedWarehouse = Warehouse();

  @override
  void initState() {
    super.initState();
    _controller = get();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    Future.delayed(Duration.zero, () async => await _controller.init());
  }

  @override
  Widget build(BuildContext context) {
    final list = watchX((WarehousePageController c) => c.warehouses);
    final typs = watchX((WarehousePageController c) => c.warehouseTypes);

    return Scaffold(
      appBar: AppBar(
        title: Text('Warehouses'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    selectedWarehouse = Warehouse();

                    _nameController.text = "";
                    _addressController.text = "";

                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.question,
                      title: "Add warehouse",
                      desc: "Add new warehouse",
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Имя",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _nameController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Адрес",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _addressController,
                            ),
                            DropdownMenu<WarehouseType>(
                                label: Text("Тип"),
                                onSelected: (WarehouseType? pos) {
                                  selectedWarehouse.warehouse_type = pos;
                                },
                                dropdownMenuEntries: typs.map<DropdownMenuEntry<WarehouseType>>((WarehouseType pos) => DropdownMenuEntry<WarehouseType>(value: pos, label: pos.type_name!)).toList()
                            )
                          ],
                        ),
                      ),
                      btnOkOnPress: () {
                        Warehouse warehouse = Warehouse(
                          warehouse_name: _nameController.text,
                          warehouse_type: selectedWarehouse.warehouse_type,
                          warehouse_address: _addressController.text,
                          warehouse_id: 0
                        );

                        _controller.addWarehouse(warehouse);
                      },
                    ).show();
                  },
                  child: Text("Add")
              ),
              TextButton(
                  onPressed: () {
                    if (selectedWarehouse.warehouse_id == 0 || selectedWarehouse.warehouse_id == null) {
                      AwesomeDialog(
                        context: context,
                        title: "Not selected",
                        desc: "Warehouse not selected",
                        dialogType: DialogType.error,
                      ).show();
                    }

                    _nameController.text = selectedWarehouse.warehouse_name!;
                    _addressController.text = selectedWarehouse.warehouse_address!;

                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.info,
                      title: "Update warehouse",
                      desc: "Update existing warehouse",
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Имя",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _nameController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Адрес",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _addressController,
                            ),
                            DropdownMenu<WarehouseType>(
                                label: Text("Position"),
                                initialSelection: selectedWarehouse.warehouse_type,
                                onSelected: (WarehouseType? pos) {
                                  selectedWarehouse.warehouse_type = pos;
                                },
                                dropdownMenuEntries: typs.map<DropdownMenuEntry<WarehouseType>>((WarehouseType pos) => DropdownMenuEntry<WarehouseType>(value: pos, label: pos.type_name!)).toList()
                            )
                          ],
                        ),
                      ),
                      btnOkOnPress: () {
                        Warehouse warehouse = Warehouse(
                            warehouse_name: _nameController.text,
                            warehouse_type: selectedWarehouse.warehouse_type,
                            warehouse_address: _addressController.text,
                            warehouse_id: selectedWarehouse.warehouse_id
                        );

                        _controller.updateWarehouse(warehouse);
                      },
                    ).show();
                  },
                  child: Text("Update")
              ),
              TextButton(
                  onPressed: () {
                    if (selectedWarehouse.warehouse_id == 0 || selectedWarehouse.warehouse_id == null) {
                      AwesomeDialog(
                        context: context,
                        title: "Not selected",
                        desc: "Warehouse not selected",
                        dialogType: DialogType.error,
                      ).show();
                    }

                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.info,
                      title: "Delete warehouse",
                      desc: "Delete warehouse",
                      body: Center(
                        child: Text("Вы уверены, что хотите удалить склад ${selectedWarehouse.warehouse_name}"),
                      ),
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        _controller.deleteWarehouse(selectedWarehouse);
                      },
                    ).show();
                  },
                  child: Text("Delete")
              ),
            ],
          ),
          Expanded(
            child: DataTable2(
                empty: Center(
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.grey[200],
                        child: const Text('No data'))),
                columns: [
                  DataColumn2(
                      label: Text("Name")
                  ),
                  DataColumn2(
                      label: Text("Address")
                  ),
                  DataColumn2(
                      label: Text("Type")
                  ),
                ],
                rows: List<DataRow2>.generate(
                    list.length,
                        (index) => DataRow2(
                            onTap: () {
                              selectedWarehouse = list[index];
                              },
                        cells: [
                          DataCell(
                              Text(list[index].warehouse_name!)
                          ),
                          DataCell(
                              Text(list[index].warehouse_address!)
                          ),
                          DataCell(
                              Text(list[index].warehouse_type!.type_name!)
                          ),
                        ]
                    )
                )
            ),
          )
        ],
      ),
    );
  }
}