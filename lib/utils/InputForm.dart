import 'package:equatable/equatable.dart';

//todo:refactor
final class MyInputResult<T> extends Equatable {
  final T? value;
  final String? errorMessage;

  const MyInputResult({this.value, this.errorMessage});

  bool IsValid() {
    if (errorMessage != null) return false;
    return true;
  }

  @override
  List<Object?> get props => [value, errorMessage];
}

enum EInputFormStatus {
  initialLoading,

  ///no loading is happening. Data is up-to-date with DB
  idleRelevant,

  ///no lading is happening. Data was locally changed but changes haven't been loaded to DB
  idleDirty,
  loading,
}
