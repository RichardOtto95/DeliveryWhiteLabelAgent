import 'package:mobx/mobx.dart';

part 'root_store.g.dart';

class RootStore = _RootStoreBase with _$RootStore;

abstract class _RootStoreBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
