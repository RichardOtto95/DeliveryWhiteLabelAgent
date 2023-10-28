import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class AnnouncementConfirm extends StatelessWidget {
  final Map group;
  final MainStore mainStore = Modular.get();

  AnnouncementConfirm({Key? key, required this.group}) : super(key: key);
  final AdvertisementStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    OverlayEntry? confirmPauseOverlay;
    return WillPopScope(
      onWillPop: () async {
        Modular.to.pop();
        Modular.to.pop();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: wXD(115, context)),
                  Text(
                    'Seu anúncio estará ativo em\nbreve!',
                    textAlign: TextAlign.center,
                    style: textFamily(context,
                        fontSize: 20, color: getColors(context).onBackground),
                  ),
                  Container(
                    height: wXD(290, context),
                    width: wXD(342, context),
                    decoration: BoxDecoration(
                      color: getColors(context).onSurface,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(color: Color(0xfff1f1f1)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          color: Color(0x30000000),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: wXD(16, context),
                        vertical: wXD(18, context)),
                    padding: EdgeInsets.fromLTRB(
                      wXD(7, context),
                      wXD(23, context),
                      wXD(7, context),
                      wXD(16, context),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: wXD(20, context),
                            right: wXD(20, context),
                            bottom: wXD(14, context),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: getColors(context)
                                          .onBackground
                                          .withOpacity(.9)
                                          .withOpacity(.2)))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Venda mais rápido seu anúncio:',
                                style: textFamily(
                                  context,
                                  fontSize: 16,
                                  color: getColors(context).onBackground,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: wXD(3, context)),
                              Text(
                                // '"Samsung Galaxy A51+"',
                                group['title'],
                                style: textFamily(
                                  context,
                                  fontSize: 16,
                                  color: getColors(context).onBackground,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: wXD(33, context)),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: textFamily(context,
                                        fontSize: 28,
                                        color: getColors(context)
                                            .onBackground
                                            .withOpacity(.9)),
                                    children: [
                                      const TextSpan(text: 'R\$'),
                                      TextSpan(
                                          style: textFamily(
                                            context,
                                            color: getColors(context).primary,
                                            fontSize: 28,
                                          ),
                                          text: '*30,00')
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: wXD(14, context)),
                              Center(
                                child: Material(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  color: getColors(context).primary,
                                  elevation: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      confirmPauseOverlay = OverlayEntry(
                                        builder: (context) => ConfirmPopup(
                                          height: wXD(140, context),
                                          text:
                                              'Tem certeza que deseja destacar esta publicação?',
                                          onConfirm: () async {
                                            await store.highlightAd(
                                                adsId: group['id'],
                                                context: context);
                                            confirmPauseOverlay!.remove();
                                            confirmPauseOverlay = null;
                                            Modular.to.pop();
                                            Modular.to.pop();
                                          },
                                          onCancel: () {
                                            confirmPauseOverlay!.remove();
                                            confirmPauseOverlay = null;
                                          },
                                        ),
                                      );
                                      Overlay.of(context)!
                                          .insert(confirmPauseOverlay!);
                                      // store.highlightAd(
                                      //     adsId: group['id'], context: context);
                                    },
                                    child: Container(
                                      height: wXD(41, context),
                                      width: wXD(217, context),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Destacar agora',
                                        style: textFamily(
                                          context,
                                          fontSize: 16,
                                          color: getColors(context).onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: wXD(6, context), top: wXD(14, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Anúncio ficará disponível no topo',
                                style: textFamily(context, fontSize: 12),
                              ),
                              SizedBox(height: wXD(2, context)),
                              Text(
                                'Anúncio ficará 7 dias com o selo "destaque"',
                                style: textFamily(context, fontSize: 12),
                              ),
                              SizedBox(height: wXD(2, context)),
                              Text(
                                'Lorem Impsum Lorem Ipsum Lorem Ipsum',
                                style: textFamily(context, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: wXD(15, context)),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            style: textFamily(
                              context,
                              fontSize: 14,
                              color: getColors(context).primary,
                            ),
                            text: 'Clique aqui ',
                          ),
                          TextSpan(
                            style: textFamily(
                              context,
                              fontSize: 14,
                              color: getColors(context).onBackground,
                            ),
                            text: 'para continuar sem destaque',
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            DefaultAppBar(
              'Anúncio inserido',
              onPop: () {
                Modular.to.pop();
                Modular.to.pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
