import 'package:delivery_agent_white_label/app/modules/orders/widgets/token.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';

import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'status_forecast.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List steps = [
      {
        'title': 'Aguardando confirmação',
        'sub_title': 'Aguarde a confirmação da loja',
      },
      {
        'title': 'Em preparação',
        'sub_title': 'O vendedor está preparando o seu pacote.',
      },
      {
        'title': 'A caminho',
        'sub_title': 'Seu pacote está a caminho',
      },
      {
        'title': 'Entregue',
        'sub_title': 'Seu foi entregue às 13:00 PM',
      },
    ];
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: wXD(101, context)),
                StatusForecast(),
                Token("ABC123"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: wXD(32, context), right: wXD(40, context)),
                      child: Column(
                        children: getBools(steps.length, 0),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...steps.map(
                          (step) => Step(
                            title: step['title'],
                            subTitle: step['sub_title'],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.9)
                                  .withOpacity(.2)))),
                ),
                Container(
                  width: maxWidth(context),
                  padding: EdgeInsets.symmetric(
                    horizontal: wXD(16, context),
                    vertical: wXD(24, context),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: wXD(25, context),
                            color: getColors(context).primary,
                          ),
                          SizedBox(width: wXD(12, context)),
                          Text(
                            'Rua 3C Chácara 26 Casa 25 \nVicente Pires, 25 - Brasília - DF \nCondomínio Hawai - O Condomínio fica \nde frente para o último balão da via \nmarginal com a estrutural \n72.005-505',
                            style: TextStyle(
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                              wXD(38, context),
                              wXD(20, context),
                              wXD(40, context),
                              wXD(24, context),
                            ),
                            height: wXD(116, context),
                            width: wXD(279, context),
                            color: getColors(context)
                                .onBackground
                                .withOpacity(.5)
                                .withOpacity(.2),
                          ),
                          Icon(
                            Icons.location_on,
                            size: wXD(25, context),
                            color: getColors(context).primary,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // EvaluateOrderCard(
                //     onTap: () => Modular.to.pushNamed('/orders/evaluation')),
              ],
            ),
          ),
          DefaultAppBar('Detalhes do envio'),
        ],
      ),
    );
  }

  List<Widget> getBools(int steps, int step) {
    List<Widget> balls = [];
    for (var i = 0; i <= ((steps - 1) * 6); i++) {
      bool sixMultiple = i % 6 == 0;
      bool lessMultiple = (i + 1) % 6 != 0;
      if (sixMultiple) {
        print('$i é multiplo de 6');
        balls.add(Ball(orange: i <= step * 6));
      } else {
        print('$i não é multiplo de 6');
        balls.add(LittleBall(
          orange: i <= step * 6,
          padding: lessMultiple,
        ));
      }
    }
    return balls;
  }
}

class EvaluateOrderCard extends StatelessWidget {
  final void Function() onTap;
  EvaluateOrderCard({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: wXD(100, context),
          width: wXD(343, context),
          margin: EdgeInsets.symmetric(vertical: wXD(24, context)),
          padding: EdgeInsets.symmetric(
            horizontal: wXD(16, context),
            vertical: wXD(13, context),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: getColors(context).onSurface,
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  offset: Offset(0, 3),
                  color: getColors(context).onBackground.withOpacity(.2))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Avalie o seu pedido',
                style: TextStyle(
                  color: getColors(context).onBackground,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                ),
              ),
              RatingBar(
                onRatingUpdate: (value) {},
                ignoreGestures: true,
                glowColor: getColors(context).primary.withOpacity(.4),
                unratedColor: getColors(context).primary.withOpacity(.4),
                allowHalfRating: true,
                itemSize: wXD(35, context),
                ratingWidget: RatingWidget(
                  full: Icon(Icons.star_rounded,
                      color: getColors(context).primary),
                  empty: Icon(Icons.star_outline_rounded,
                      color: getColors(context).primary),
                  half: Icon(Icons.star_half_rounded,
                      color: getColors(context).primary),
                ),
              ),
              Text(
                'Escolha de 1 a 5 estrelas para classificar',
                style: TextStyle(
                  color: getColors(context).onBackground.withOpacity(.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Ball extends StatelessWidget {
  final bool orange;

  const Ball({Key? key, required this.orange}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: wXD(7, context)),
      height: wXD(6, context),
      width: wXD(6, context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: orange ? getColors(context).primary : Color(0xffbdbdbd),
      ),
    );
  }
}

class LittleBall extends StatelessWidget {
  final bool orange;
  final bool padding;

  const LittleBall({
    Key? key,
    required this.orange,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('padding: $padding');
    return Container(
      margin: EdgeInsets.only(bottom: padding ? wXD(6, context) : 0),
      height: wXD(4, context),
      width: wXD(4, context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: orange
            ? getColors(context).primary.withOpacity(.5)
            : Color(0xff78849e).withOpacity(.3),
      ),
    );
  }
}

class Step extends StatelessWidget {
  final String title, subTitle;
  const Step({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: wXD(28, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: getColors(context).onBackground,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
          Text(
            subTitle,
            style: TextStyle(
              color: getColors(context).onBackground.withOpacity(.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
