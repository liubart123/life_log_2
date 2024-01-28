import 'package:get/get.dart';

class MySandboxController extends GetxController {
  String stringVar = 'initialValue';
  final rxStringVar = RxString('');
  final customClass = SandboxCustomClass().obs;
  final durationRx = Duration.zero.obs;
}

class SandboxCustomClass {
  String stringVar = 'initValue';
  String stringVar2 = 'initValue2';
  Duration duration = Duration.zero;
  List<SandboxSmallCustomClass> list = List.empty(growable: true);
}

class SandboxSmallCustomClass {
  String variable = 'initial';
}
