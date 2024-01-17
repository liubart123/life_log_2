import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

Future<void> showMyModalBottomSheet(
  BuildContext context,
  Widget bottomSheetBody,
) async {
  await showModalBottomSheet<void>(
    isScrollControlled: true,
    elevation: 2,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    enableDrag: true,
    builder: (ctx) => DraggableScrollableSheet(
      maxChildSize: 0.8,
      minChildSize: 0,
      initialChildSize: 0.4,
      expand: false,
      snap: true,
      snapSizes: const [0.4],
      shouldCloseOnMinExtent: true,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Get.theme.colorScheme.surfaceVariant,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SingleChildScrollView(
            //   controller: scrollController,
            //   child: Column(
            //     children: [
            //       // const Gap(14),
            //       // Center(
            //       //   widthFactor: 2,
            //       //   child: SizedBox(
            //       //     height: 5,
            //       //     width: 35,
            //       //     child: Container(
            //       //       decoration: BoxDecoration(
            //       //         borderRadius: BorderRadius.circular(5),
            //       //         color: Color.lerp(
            //       //           Get.theme.colorScheme.surfaceVariant,
            //       //           Get.theme.colorScheme.onSurfaceVariant,
            //       //           0.3,
            //       //         ),
            //       //       ),
            //       //     ),
            //       //   ),
            //       // ),
            //       // const Gap(14),
            //       // const Divider(height: 0),
            //       // Gap(5),
            //     ],
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: bottomSheetBody,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
