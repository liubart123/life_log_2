import 'package:flutter/material.dart';
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
    builder: (ctx) => MyDraggableScrollableSheet(bottomSheetBody),
  );
}

class MyDraggableScrollableSheet extends StatefulWidget {
  const MyDraggableScrollableSheet(
    this.bottomSheetBody, {
    super.key,
  });
  final Widget bottomSheetBody;

  @override
  State<MyDraggableScrollableSheet> createState() => _MyDraggableScrollableSheetState();
}

class _MyDraggableScrollableSheetState extends State<MyDraggableScrollableSheet> {
  final DraggableScrollableController _scrollableController = DraggableScrollableController();

  @override
  void initState() {
    _scrollableController.addListener(_scrollableControllerListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollableController.removeListener(_scrollableControllerListener);
    super.dispose();
  }

  void _scrollableControllerListener() {
    if (_scrollableController.size < 0.01) {
      _scrollableController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.8,
      minChildSize: 0,
      initialChildSize: 0.4,
      expand: false,
      snap: true,
      snapSizes: const [0.4],
      controller: _scrollableController,
      shouldCloseOnMinExtent: true,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Get.theme.colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: widget.bottomSheetBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
