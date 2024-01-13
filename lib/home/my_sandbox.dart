import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_log_2/my_flutter_elements/my_tab.dart';

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
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Flexible(
                  flex: 0,
                  // fit: FlexFit.tight,
                  child: Container(
                    color: Colors.amber,
                    child: Text('Super text long'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.red,
                    // width: 100,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      '2. Ultra long texto 1234567689123345667871231231238',
                    ),
                  ),
                ),
                Flexible(
                  flex: 0,
                  // fit: FlexFit.tight,
                  child: Container(
                    color: Colors.green,
                    child: Text('text'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
