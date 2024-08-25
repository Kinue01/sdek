import 'package:equatable/equatable.dart';

class PackageStatus with EquatableMixin {
  final int? status_id;
  final String? status_name;

  PackageStatus({
    this.status_id,
    this.status_name
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    status_id,
    status_name
  ];
}