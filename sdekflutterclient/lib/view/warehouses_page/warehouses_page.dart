import 'package:awesome_dialog/awesome_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = get();
    Future.delayed(Duration.zero, () async => await _controller.init());
  }

  @override
  Widget build(BuildContext context) {
    final list = watchX((WarehousePageController c) => c.warehouses);

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
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.question,
                      title: "Add warehouse",
                      desc: "Add new warehouse",
                      body: Center(

                      ),
                      btnOkOnPress: () {

                      },
                    ).show();
                  },
                  child: Text("Add")
              ),
              TextButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.info,
                      title: "Update warehouse",
                      desc: "Update existing warehouse",
                      body: Center(
                        child: Column(

                        ),
                      ),
                      btnOkOnPress: () {

                      },
                    );
                  },
                  child: Text("Update")
              ),
              TextButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.info,
                      title: "Delete warehouse",
                      desc: "Delete warehouse",
                      body: Center(
                        child: Column(

                        ),
                      ),
                      btnOkOnPress: () {

                      },
                    );
                  },
                  child: Text("Delete")
              ),
            ],
          ),
          Expanded(
            child: DataTable2(
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