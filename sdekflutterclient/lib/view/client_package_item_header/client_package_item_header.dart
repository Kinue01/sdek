import 'package:flutter/material.dart';

class ClientPackageItemHeader extends StatelessWidget {
  final String firstPackageItem;

  const ClientPackageItemHeader({
    super.key,
    required this.firstPackageItem
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.person,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    firstPackageItem,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(
            height: 1,
          ),
        ),
      ],
    );
  } 
}