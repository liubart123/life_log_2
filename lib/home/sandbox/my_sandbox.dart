import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/home/sandbox/my_sandbox_controller.dart';
import 'package:life_log_2/my_flutter_elements/my_input_widgets.dart';
import 'package:life_log_2/my_flutter_elements/my_tab.dart';
import 'package:life_log_2/my_flutter_elements/my_widgets.dart';
import 'package:life_log_2/utils/datetime/datetime_extension.dart';
import 'package:life_log_2/utils/duration/duration_extension.dart';
import 'package:life_log_2/utils/log_utils.dart';

class MySandboxTabControllerChild extends MyTabControllerChild {
  @override
  Tab buildTabBarIcon() {
    return const Tab(
      text: 'Sandbox tab',
    );
  }

  @override
  Widget buildTabBody() {
    return Container(
      color: Get.theme.colorScheme.surface,
      child: const MySandbox(),
    );
  }

  @override
  Widget? buildTabFAB(BuildContext context) {
    return null;
  }
}

class MySandbox extends StatelessWidget {
  const MySandbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Get.theme.colorScheme.surface,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 30,
        ),
        // width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _sandboxGetBuilder(),
            // _sandboxGetBuilder(),
          ],
        ),
      ),
    );
  }

  GetBuilder<MySandboxController> _sandboxGetBuilder() {
    return GetBuilder<MySandboxController>(
      init: MySandboxController(),
      initState: (state) {},
      builder: (controller) {
        MyLogger.widget2('MySandboxController builder');
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyDurationInputField(
                label: 'Duration',
                rxValue: Rx(controller.customClass.value.duration),
              ),
              Obx(
                () {
                  MyLogger.controller2('build obx duration');
                  return MyIntervalInputField(
                    initialValue: controller.customClass.value.duration,
                    label: 'Interval',
                    onSubmit: (newValue) {},
                  );
                },
              ),
              Obx(
                () {
                  MyLogger.controller2('build obx stringVar');
                  return Text(controller.customClass.value.stringVar);
                },
              ),
              Obx(
                () => MyTextButton(
                  text: 'D:${controller.customClass.value.duration.toFormattedString()}',
                  callback: () async {
                    MyLogger.debug('button clicked');
                    await Future.delayed(Duration(milliseconds: 1500));
                    controller.customClass.update((val) {
                      MyLogger.debug('updating value');
                      val!.duration = Duration(minutes: val.duration.inMinutes);
                    });
                  },
                ),
              ),
              MyTextButton(
                text: 'string update',
                callback: () async {
                  controller.customClass.update((val) {
                    val!.stringVar = DateTime.now().second.toString();
                  });
                },
              )
            ],
          ),
        );
      },
    );
  }
}
