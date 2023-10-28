import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/confirm_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'payment_store.g.dart';

class PaymentStore = _PaymentStoreBase with _$PaymentStore;

abstract class _PaymentStoreBase with Store {
  @observable
  ObservableList cards = [{}].asObservable();

  @observable
  late OverlayEntry confirmDeleteOverlay = OverlayEntry(
    builder: (context) => ConfirmPopup(
        height: wXD(160, context),
        text: 'Tem certeza que deseja excluir este cartão?',
        onCancel: () => confirmDeleteOverlay.remove(),
        onConfirm: () {
          confirmDeleteOverlay.remove();
          Modular.to.pop();
        }),
  );
}
