import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:life_log_2/my_flutter_elements/my_input_widgets.dart';
import 'package:life_log_2/my_flutter_elements/my_tab.dart';
import 'package:life_log_2/my_flutter_elements/my_widgets.dart';
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
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 30,
        ),
        // width: 200,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: MyTimeInputField(
                initialValue: DateTime.now(),
                label: 'field',
                onSubmit: (newValue) {},
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: MyTimeInputField(
                initialValue: DateTime.now(),
                label: 'field',
                onSubmit: (newValue) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
