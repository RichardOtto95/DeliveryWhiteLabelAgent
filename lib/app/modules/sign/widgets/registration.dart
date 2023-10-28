import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  PageController pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: wXD(95, context)),
                Container(
                  height: wXD(473, context),
                  child: PageView(
                    onPageChanged: (page) => setState(() => _page = page),
                    controller: pageController,
                    children: [
                      VehicleAndDocument(),
                      BankData(),
                    ],
                  ),
                ),
                Spacer(),
                SideButton(
                  height: wXD(52, context),
                  width: wXD(142, context),
                  title: _page == 0 ? "Avançar" : "Próximo",
                  onTap: () async {
                    if (pageController.page == 0) {
                      await pageController.animateToPage(1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    } else {
                      await Modular.to.pushNamed("/address/address-setup");
                    }
                  },
                ),
                Spacer(flex: 2),
              ],
            ),
            DefaultAppBar('Cadstro'),
          ],
        ),
      ),
    );
  }
}

class BankData extends StatelessWidget {
  BankData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: wXD(30, context), right: wXD(30, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dados bancários",
                style: textFamily(
                  context,
                  fontSize: 17,
                  color: getColors(context).primary,
                ),
              ),
              SizedBox(height: wXD(7, context)),
              Text(
                "É necessário que a conta esteja no seu\nCPF. Não aceitaremos contas em nome\nde terceiros",
                style: textFamily(
                  context,
                  fontSize: 14,
                  color: getColors(context).onBackground.withOpacity(.7),
                ),
              ),
              SizedBox(height: wXD(37, context)),
            ],
          ),
        ),
        FloatField(title: "Banco", onChanged: (val) {}),
        SizedBox(height: wXD(25, context)),
        FloatField(title: "Agência", onChanged: (val) {}),
        SizedBox(height: wXD(25, context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatField(title: "Conta", onChanged: (val) {}, width: 185),
            SizedBox(width: wXD(9, context)),
            FloatField(title: "Dígito", onChanged: (val) {}, width: 145),
          ],
        )
      ],
    );
  }
}

class FloatField extends StatelessWidget {
  final double width;
  final String title;
  final void Function(String) onChanged;

  FloatField({
    Key? key,
    this.width = 339,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(52, context),
      width: wXD(width, context),
      padding: EdgeInsets.symmetric(
          horizontal: wXD(11, context), vertical: wXD(7, context)),
      decoration: BoxDecoration(
        border:
            Border.all(color: getColors(context).onBackground.withOpacity(.11)),
        borderRadius: BorderRadius.circular(3),
        color: getColors(context).onSurface,
        boxShadow: [
          BoxShadow(
            blurRadius: wXD(8, context),
            offset: Offset(0, wXD(7, context)),
            color: getColors(context).onBackground.withOpacity(.08),
          )
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context)
                      .onBackground
                      .withOpacity(.5)
                      .withOpacity(.6),
                ),
              ),
              Container(
                width: wXD(width - 44, context),
                child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration.collapsed(hintText: ""),
                ),
              ),
            ],
          ),
          SvgPicture.asset("./assets/svg/pen.svg", height: wXD(17, context)),
        ],
      ),
    );
  }
}

class VehicleAndDocument extends StatelessWidget {
  VehicleAndDocument({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: wXD(30, context), right: wXD(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Escolha seu veículo de entregas",
            style: textFamily(
              context,
              fontSize: 17,
              color: getColors(context).primary,
            ),
          ),
          SizedBox(height: wXD(7, context)),
          Text(
            "Você pode escolher qualquer um disponível.\nNão se preocupe, você conseguirá alterar\ndepois.",
            style: textFamily(
              context,
              fontSize: 14,
              color: getColors(context).onBackground.withOpacity(.7),
            ),
          ),
          SizedBox(height: wXD(12, context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Vehicle(
                title: "Bicicleta",
                child: SvgPicture.asset("./assets/svg/bike.svg"),
              ),
              Vehicle(
                title: "Moto",
                child: SvgPicture.asset("./assets/svg/moto.svg"),
              ),
              Vehicle(
                title: "Patinete",
                child: SvgPicture.asset("./assets/svg/patinete.svg"),
              ),
            ],
          ),
          SizedBox(height: wXD(22, context)),
          Text(
            "Fotos e documentos",
            style: textFamily(
              context,
              fontSize: 17,
              color: getColors(context).primary,
            ),
          ),
          Text(
            "Toque no ícones e siga as instruções\npara tirar as fotos.",
            style: textFamily(
              context,
              fontSize: 14,
              color: getColors(context).onBackground.withOpacity(.7),
            ),
          ),
          SizedBox(height: wXD(12, context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Document(
                title: "Foto CNH\nou RG",
                child: SvgPicture.asset("./assets/svg/document.svg"),
              ),
              Document(
                title: "Foto Rosto",
                child: SvgPicture.asset("./assets/svg/picture.svg"),
              ),
            ],
          ),
          SizedBox(height: wXD(30, context)),
        ],
      ),
    );
  }
}

class Vehicle extends StatelessWidget {
  final String title;
  final Widget child;
  Vehicle({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: wXD(77, context),
          width: wXD(77, context),
          margin:
              EdgeInsets.only(top: wXD(11, context), bottom: wXD(25, context)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: getColors(context).primary,
              width: wXD(2, context),
            ),
          ),
          alignment: Alignment.center,
          child: child,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SvgPicture.asset(
            "./assets/svg/remove.svg",
            height: wXD(18, context),
          ),
        ),
        Positioned(
          child: Text(
            title,
            style: textFamily(context,
                fontSize: 14,
                color: getColors(context)
                    .onBackground
                    .withOpacity(.7)
                    .withOpacity(.5)),
          ),
        ),
      ],
    );
  }
}

class Document extends StatelessWidget {
  final String title;
  final Widget child;
  Document({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: wXD(77, context),
          width: wXD(77, context),
          margin:
              EdgeInsets.only(top: wXD(11, context), bottom: wXD(33, context)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: getColors(context).primary,
              width: wXD(2, context),
            ),
          ),
          alignment: Alignment.center,
          child: child,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SvgPicture.asset(
            "./assets/svg/eye.svg",
            height: wXD(14, context),
          ),
        ),
        Positioned(
          child: Container(
            height: wXD(33, context),
            alignment: Alignment.topCenter,
            child: Text(
              title,
              style: textFamily(context,
                  fontSize: 14,
                  color: getColors(context)
                      .onBackground
                      .withOpacity(.7)
                      .withOpacity(.5)),
            ),
          ),
        ),
      ],
    );
  }
}
