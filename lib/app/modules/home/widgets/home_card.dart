import 'package:delivery_agent_white_label/app/modules/home/home_store.dart';
import 'package:delivery_agent_white_label/app/modules/main/main_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/color_theme.dart';

class HomeCard extends StatefulWidget {
  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends ModularState<HomeCard, HomeStore>
    with SingleTickerProviderStateMixin {
  final MainStore mainStore = Modular.get();
  late AnimationController animationController;
  bool montantVisible = false;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    );
    animationController.forward();
    animationController.addListener(() {
      // print('animationController.addListener');
      mainStore.nowDate = DateTime.now();
      // setState(() {
      if (animationController.status == AnimationStatus.completed) {
        animationController.repeat();
      }
      // });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: wXD(265, context),
        width: wXD(342, context),
        padding: EdgeInsets.symmetric(
            horizontal: wXD(21, context), vertical: wXD(14, context)),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(color: getColors(context).onSurface),
          color: getColors(context).surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: getColors(context).shadow,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Column(
                //   children: [
                //     Text(
                //       'Nível 1',
                //       style: textFamily(context,
                //         fontSize: 16,
                //         color: getColors(context).onBackground,
                //       ),
                //     ),
                //     Text(
                //       '21 XP',
                //       style: textFamily(context,
                //         fontSize: 12,
                //         color: getColors(context).primary,
                //       ),
                //     ),
                //   ],
                // ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      montantVisible ? Icons.visibility : Icons.visibility_off,
                      color: getColors(context).onBackground,
                      size: wXD(25, context),
                    ),
                    Column(
                      children: [
                        SizedBox(height: wXD(4, context)),
                        FutureBuilder<String>(
                            future: store.getTotalAmount(),
                            builder: (context, snapshot) {
                              print('snapshot.hasError: ${snapshot.hasError}');
                              print('snapshot.hasData: ${snapshot.hasData}');
                              if (snapshot.hasError) {
                                print(snapshot.error);
                              }
                              if (!snapshot.hasData) {
                                return Container(
                                  height: wXD(17, context),
                                  width: wXD(98, context),
                                  margin:
                                      EdgeInsets.only(left: wXD(3, context)),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    // color: getColors(context).onBackground.withOpacity(.7).withOpacity(.3),
                                  ),
                                  child: LinearProgressIndicator(
                                    color: getColors(context).primary,
                                    backgroundColor: getColors(context)
                                        .primary
                                        .withOpacity(0.5),
                                  ),
                                );
                              }
                              String value = snapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    montantVisible = !montantVisible;
                                  });
                                },
                                child: montantVisible
                                    ? Text(
                                        ' R\$ ' + value,
                                        style: textFamily(
                                          context,
                                          fontSize: 16,
                                          color:
                                              getColors(context).onBackground,
                                        ),
                                      )
                                    : Container(
                                        height: wXD(17, context),
                                        width: wXD(98, context),
                                        margin: EdgeInsets.only(
                                            left: wXD(3, context)),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(3)),
                                          color: getColors(context)
                                              .onBackground
                                              .withOpacity(.7)
                                              .withOpacity(.3),
                                        ),
                                      ),
                              );
                            }),
                        Text(
                          'Ganho semanal',
                          style: textFamily(
                            context,
                            height: 1.4,
                            fontSize: 12,
                            color: getColors(context).primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Observer(builder: (context) {
              String hour = mainStore.nowDate.hour.toString().padLeft(2, '0');
              String minute =
                  mainStore.nowDate.minute.toString().padLeft(2, '0');
              return mainStore.agentMap.isEmpty
                  ? Container(
                      height: wXD(160, context),
                      width: wXD(160, context),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(getColors(context).primary),
                      ),
                    )
                  : SizedBox(
                      height: wXD(160, context),
                      width: wXD(160, context),
                      child: GestureDetector(
                        onTap: () =>
                            mainStore.setOnline(!mainStore.agentMap["online"]),
                        child: Stack(
                          fit: StackFit.loose,
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: wXD(160, context),
                              width: wXD(160, context),
                              child: RotationTransition(
                                turns: Tween(begin: 0.0, end: 1.0)
                                    .animate(animationController),
                                child: SizedBox(
                                  height: wXD(160, context),
                                  width: wXD(160, context),
                                ),
                              ),
                            ),
                            // AnimatedBuilder(
                            //   animation: animationController,
                            //   builder: (context, child) {
                            //     return
                            //      SizedBox(
                            //       height: wXD(160, context),
                            //       width: wXD(160, context),
                            //       child: CustomPaint(
                            //         painter: Painter(),
                            //       ),
                            //     );
                            //   },
                            // ),
                            Text(
                              hour + ':' + minute,
                              style: GoogleFonts.montserrat(
                                  fontSize: 44,
                                  color: getColors(context).onBackground,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 0,
                                      color: getColors(context).shadow,
                                      offset: Offset(2, 0),
                                    )
                                  ],
                                  fontWeight: FontWeight.normal),
                            ),
                            Positioned(
                              right: wXD(15, context),
                              bottom: wXD(8, context),
                              child: GestureDetector(
                                onTap: () {
                                  // print("agentMap: ${mainStore.agentMap}");
                                  print(mainStore.agentMap["online"]);
                                  mainStore
                                      .setOnline(!mainStore.agentMap["online"]);
                                },
                                child: Container(
                                  height: wXD(25, context),
                                  width: wXD(25, context),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: getColors(context).onSurface),
                                    color: mainStore.agentMap["online"]
                                        ? green
                                        : getColors(context).error,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
            }),
            Observer(builder: (context) {
              if (mainStore.agentMap.isEmpty) {
                return Container();
              }
              return GestureDetector(
                onTap: () {
                  mainStore.setOnline(!mainStore.agentMap["online"]);
                },
                child: Container(
                  height: wXD(32, context),
                  alignment: Alignment.center,
                  width: wXD(250, context),
                  child: Text(
                    mainStore.agentMap["online"]
                        ? 'Toque para ficar offline'
                        : 'Toque para ficar online',
                    style: textFamily(
                      context,
                      fontSize: 16,
                      color: getColors(context).onBackground,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// class ShadowPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     double radius = size.width / 2;
//     canvas.translate(size.width / 2, size.height / 2);
//     Path oval = Path()
//       ..addOval(Rect.fromCircle(center: Offset(0, 3), radius: radius));

//     Paint shadowPaint = Paint()
//       ..color = Colors.black.withOpacity(.3)
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 5;
//     canvas.drawPath(oval, shadowPaint);
//   }

//   @override
//   bool shouldRepaint(ShadowPainter oldDelegate) {
//     return false;
//   }
// }

// class Painter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     double radius = size.width / 2;
//     canvas.translate(size.width / 2, size.height / 2);
//     Offset center = const Offset(0.0, 0.0);
//     // draw shadow first
//     // Path oval = Path()
//     //   ..addOval(Rect.fromCircle(center: Offset(0, 3), radius: radius));

//     // Paint shadowPaint = Paint()
//     //   ..color = Colors.black.withOpacity(.3)
//     //   ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3)
//     //   ..style = PaintingStyle.stroke
//     //   ..strokeWidth = 5;
//     // canvas.drawPath(oval, shadowPaint);
//     // draw circle
//     Paint thumbPaint = Paint()
//       ..shader = LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 getColors(context).primary,
//                 getColors(context).error,
//                 getColors(context).secondary,
//               ],
//               tileMode: TileMode.mirror)
//           .createShader(Rect.fromCircle(center: center, radius: radius))
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 5;
//     // canvas.drawCircle(center, radius, thumbPaint);
//     canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 50, 50,
//         false, thumbPaint);
//   }

//   @override
//   bool shouldRepaint(Painter oldDelegate) {
//     return false;
//   }
// }
