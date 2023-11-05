final class MyInputResult<T> {
  final T? value;
  final String? errorMessage;

  const MyInputResult({this.value, this.errorMessage});

  bool IsValid() {
    if (errorMessage != null) return false;
    return true;
  }
}

enum EInputFormStatus {
  initialLoading,

  ///no loading is happening. Data is up-to-date with DB
  idleRelevant,

  ///no lading is happening. Data was locally changed but changes haven't been loaded to DB
  idleDirty,
  loading,
}
