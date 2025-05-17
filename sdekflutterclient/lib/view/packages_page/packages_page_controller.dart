import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/usecase/pack/GetPackagesUseCase.dart';
import 'package:flutter/cupertino.dart';

class PackagesPageController {
  late List<Package> packages;

  final filteredPackages = ValueNotifier(<Package>[]);

  final GetPackagesUseCase getPackagesUseCase;
  PackagesPageController({
    required this.getPackagesUseCase
  });

  Future<void> getPackages() async {
    packages = await getPackagesUseCase.exec();
    filteredPackages.value = packages;
  }
}