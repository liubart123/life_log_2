import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/my_flutter_elements/my_constants.dart';

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
          // borderRadius: BorderRadius.circular(2),
          color: Get.theme.colorScheme.surfaceVariant,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Gap(MEDIUM_CARD_PADDING),
                  Center(
                    widthFactor: 2,
                    child: SizedBox(
                      height: 4,
                      width: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1, 2),
                              blurRadius: 1,
                              color: Color.lerp(
                                Get.theme.colorScheme.surfaceVariant,
                                Get.theme.colorScheme.onSurfaceVariant,
                                0.6,
                              )!,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: Color.lerp(
                            Get.theme.colorScheme.surfaceVariant,
                            Get.theme.colorScheme.onSurfaceVariant,
                            0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(5),
                  Divider(height: 5),
                  // Gap(5),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                // controller: scrollController,
                child: bottomSheetBody,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
