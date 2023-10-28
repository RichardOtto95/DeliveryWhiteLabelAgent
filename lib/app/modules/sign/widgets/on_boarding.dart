import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController pageController = PageController();
  bool firstPage = true;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).background),
      child: WillPopScope(
        onWillPop: () async {
          if (pageController.page == 1) {
            pageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
            return false;
          } else {
            return false;
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: hXD(523, context),
                child: PageView(
                  onPageChanged: (val) {
                    // print('val: $val');
                    if (val == 1) {
                      setState(() {
                        firstPage = false;
                      });
                    } else {
                      setState(() {
                        firstPage = true;
                      });
                    }
                  },
                  controller: pageController,
                  children: const [
                    WellCome(),
                    Delivery(),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: wXD(102, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                            setState(() {
                              firstPage = true;
                            });
                          },
                          child: Container(
                            height: wXD(8, context),
                            width: wXD(47, context),
                            decoration: BoxDecoration(
                              color:
                                  getColors(context).primary.withOpacity(.32),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(3)),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            print('pageController: ${pageController.page}');
                            pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                            setState(() {
                              firstPage = false;
                            });
                          },
                          child: Container(
                            height: wXD(8, context),
                            width: wXD(47, context),
                            decoration: BoxDecoration(
                              color:
                                  getColors(context).primary.withOpacity(.32),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(3)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedPositioned(
                    left: firstPage ? 0 : wXD(55, context),
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      height: wXD(8, context),
                      width: wXD(47, context),
                      decoration: BoxDecoration(
                        color: getColors(context).primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  // print('pageController: ${pageController.page}');
                  if (pageController.page == 0) {
                    pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  } else {
                    await Modular.to.pushNamed('/sign');
                    pageController.jumpToPage(0);
                  }
                },
                child: Container(
                  width: wXD(92, context),
                  height: wXD(52, context),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(3),
                    ),
                    border: Border.all(
                      color: getColors(context).onBackground,
                    ),
                    color: getColors(context).primary,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        offset: Offset(0, 3),
                        color: Color(0x30000000),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward,
                    size: wXD(25, context),
                    color: getColors(context).onPrimary,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class WellCome extends StatelessWidget {
  const WellCome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          'Bem vindo!',
          style: GoogleFonts.montserrat(
            color: getColors(context).onBackground.withOpacity(.8),
            fontStyle: FontStyle.italic,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: wXD(10, context)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: wXD(30, context)),
          child: Text(
            'Lorem ipsum Lorem ipsum Lorem ipsum\n Lorem ipsum Lorem ipsum\nLorem ipsum.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: getColors(context).onBackground,
              fontStyle: FontStyle.italic,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Spacer(),
        brightness == Brightness.light
            ? Image.asset(
                "./assets/images/logo.png",
                height: wXD(240, context),
                fit: BoxFit.fill,
              )
            : Image.asset(
                "./assets/images/logo_dark.png",
                height: wXD(240, context),
                fit: BoxFit.fill,
              ),
        const Spacer(),
      ],
    );
  }
}

class Delivery extends StatelessWidget {
  const Delivery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          'Delivery',
          style: GoogleFonts.montserrat(
            color: getColors(context).onBackground.withOpacity(.8),
            fontStyle: FontStyle.italic,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: wXD(10, context)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: wXD(30, context)),
          child: Text(
            'Lorem ipsum Lorem ipsum\nLorem ipsum, Lorem ipsum\nLorem ipsum Lorem ipsum.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: getColors(context).onBackground,
              fontStyle: FontStyle.italic,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Spacer(),
        brightness == Brightness.light
            ? Image.asset(
                "./assets/images/logo.png",
                height: wXD(240, context),
                fit: BoxFit.fill,
              )
            : Image.asset(
                "./assets/images/logo_dark.png",
                height: wXD(240, context),
                fit: BoxFit.fill,
              ),
        const Spacer(),
      ],
    );
  }
}
