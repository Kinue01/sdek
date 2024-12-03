import 'package:clientapp/domain/model/Package.dart';
import 'package:flutter/material.dart';

typedef OnPackageListItemTap = void Function(Package character);

class ClientPackageItem extends StatelessWidget {
  final Package item;
  final OnPackageListItemTap? onTap;

  const ClientPackageItem({
    super.key,
    required this.item,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(item),
      child: Card(
        elevation: 0,
        child: _ItemDescription(item: item)
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------

class _ItemDescription extends StatelessWidget {
  const _ItemDescription({super.key, required this.item});

  final Package item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            item.package_uuid ?? 'invalid uuid',
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

// class _ItemPhoto extends StatelessWidget {
//   const _ItemPhoto({super.key, required this.item});

//   final Package item;

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.all(Radius.circular(12)),
//       child: SizedBox(
//         height: 122,
//         child: Hero(
//           tag: item.id!,
//           child: CachedNetworkImage(
//             height: 122,
//             width: 122,
//             imageUrl: item.image!,
//             fit: BoxFit.cover,
//             errorWidget: (ctx, url, err) => const Icon(Icons.error),
//             placeholder: (ctx, url) => const Icon(Icons.image),
//           ),
//         ),
//       ),
//     );
//   }
// }