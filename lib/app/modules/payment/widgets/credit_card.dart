import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

import '../payment_store.dart';

class CreditCard extends StatelessWidget {
  final PaymentStore store = Modular.get();
  final double? width;
  CreditCard({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Modular.to.pushNamed('/payment/card-details'),
      child: Container(
        height: wXD(144, context),
        width: width ?? wXD(212, context),
        margin: EdgeInsets.symmetric(horizontal: wXD(6, context)),
        padding: EdgeInsets.fromLTRB(
          wXD(18, context),
          wXD(14, context),
          wXD(19, context),
          wXD(20, context),
        ),
        decoration: const BoxDecoration(
          // border: Border.all(color: getColors(context).onBackground.withOpacity(.7)),
          gradient: LinearGradient(
            colors: [Color(0xffFAB1A0), Color(0xffE27A62)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(3)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4), color: Color(0x15000000), blurRadius: 4)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    SizedBox(width: wXD(40, context), height: wXD(25, context)),
                    Positioned(
                      left: 0,
                      child: Container(
                        height: wXD(25, context),
                        width: wXD(25, context),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffEA1D25),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        height: wXD(25, context),
                        width: wXD(25, context),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffF69E1E),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '00/00',
                  style: GoogleFonts.rubik(
                      fontSize: 11, color: const Color(0xffE27A62)),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'Lorem ipsum',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: getColors(context).onSurface),
                ),
                const Spacer(),
                Text(
                  '• • • •  0000',
                  style: GoogleFonts.rubik(
                      fontSize: 11, color: getColors(context).onSurface),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
