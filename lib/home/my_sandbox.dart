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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                color: Colors.amber,
                child: Material(
                  color: Color.fromARGB(255, 168, 20, 20),
                  child: Ink(
                    decoration: const ShapeDecoration(
                      color: Colors.lightBlue,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.android,
                        // size: 60,
                      ),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
            Gap(20),
            IconButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.android,
                // size: 60,
              ),
              color: Colors.white,
              onPressed: () {},
            ),
            Gap(20),
            Center(
              child: Container(
                // color: Colors.amber,
                child: TextButton(
                  child: Text('test'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
