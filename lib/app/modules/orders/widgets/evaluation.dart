import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/core/models/time_model.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';

import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Evaluation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                    wXD(16, context),
                    wXD(95, context),
                    wXD(12, context),
                    wXD(12, context),
                  ),
                  width: maxWidth(context),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: getColors(context)
                              .onBackground
                              .withOpacity(.9)
                              .withOpacity(.2)),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avalie seu pedido',
                        style: textFamily(
                          context,
                          color: getColors(context).onBackground,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        TimeModel().date(Timestamp.now()),
                        style: textFamily(
                          context,
                          color: getColors(context)
                              .onBackground
                              .withOpacity(.9)
                              .withOpacity(.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TypeEvaluation(
                  title: 'Você gostou do produto?',
                  complement: 'do produto',
                ),
                TypeEvaluation(
                  title: 'O que achou do atendimento do vendedor?',
                  complement: 'do vendedor',
                ),
                TypeEvaluation(
                  title: 'O que achou da entrega?',
                  complement: 'da entrega',
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    wXD(19, context),
                    wXD(12, context),
                    wXD(17, context),
                    wXD(17, context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avalie a Scorefy também.',
                        style: textFamily(
                          context,
                          color: getColors(context).onBackground,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Em uma escala de 0 a 10, qual é a chance de você indicar a Scorefy para um amigo?',
                        style: textFamily(
                          context,
                          color: getColors(context)
                              .onBackground
                              .withOpacity(.9)
                              .withOpacity(.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wXD(15, context)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: getBalls()),
                ),
                SizedBox(height: wXD(35, context)),
                SideButton(
                  onTap: () {},
                  height: wXD(52, context),
                  width: wXD(142, context),
                  title: 'Avaliar',
                ),
                SizedBox(height: wXD(25, context)),
              ],
            ),
          ),
          DefaultAppBar('Avaliação'),
        ],
      ),
    );
  }

  List<Ball> getBalls() {
    List<Ball> balls = [];
    for (var i = 1; i <= 10; i++) {
      balls.add(Ball(i));
    }
    return balls;
  }
}

class Ball extends StatelessWidget {
  final int number;

  Ball(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(26, context),
      width: wXD(26, context),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: getColors(context).primary.withOpacity(.15)),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: textFamily(
          context,
          fontSize: 16,
          color: getColors(context).onBackground.withOpacity(.9),
        ),
      ),
    );
  }
}

class TypeEvaluation extends StatelessWidget {
  final String title;
  final String complement;
  TypeEvaluation({required this.title, required this.complement});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        wXD(16, context),
        wXD(12, context),
        wXD(16, context),
        wXD(21, context),
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
            title,
            style: textFamily(
              context,
              color: getColors(context).onBackground,
              fontSize: 14,
            ),
          ),
          Text(
            'Escolha de 1 a 5 estrelas para classificar.',
            style: textFamily(
              context,
              color: getColors(context)
                  .onBackground
                  .withOpacity(.9)
                  .withOpacity(.6),
              fontSize: 12,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: wXD(15, context)),
          RatingBar(
            onRatingUpdate: (value) {},
            glowColor: getColors(context).primary.withOpacity(.4),
            unratedColor: getColors(context).primary.withOpacity(.4),
            allowHalfRating: true,
            itemSize: wXD(35, context),
            ratingWidget: RatingWidget(
              full: Icon(Icons.star_rounded, color: getColors(context).primary),
              empty: Icon(Icons.star_outline_rounded,
                  color: getColors(context).primary),
              half: Icon(Icons.star_half_rounded,
                  color: getColors(context).primary),
            ),
          ),
          SizedBox(height: wXD(28, context)),
          Row(
            children: [
              Text(
                'Deixar uma opinião',
                style: textFamily(
                  context,
                  color: getColors(context).onBackground,
                  fontSize: 14,
                ),
              ),
              Spacer(),
              Text(
                '0/300',
                style: textFamily(
                  context,
                  color: getColors(context)
                      .onBackground
                      .withOpacity(.9)
                      .withOpacity(.8),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Container(
            height: wXD(52, context),
            width: wXD(343, context),
            decoration: BoxDecoration(
                border: Border.all(
                    color: getColors(context).primary.withOpacity(.65)),
                borderRadius: BorderRadius.all(Radius.circular(3))),
            margin: EdgeInsets.only(top: wXD(16, context)),
            padding: EdgeInsets.symmetric(
                horizontal: wXD(10, context), vertical: wXD(13, context)),
            alignment: Alignment.topLeft,
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: 'Deixe sua opinião a respeito $complement',
                hintStyle: textFamily(
                  context,
                  color: getColors(context)
                      .onBackground
                      .withOpacity(.9)
                      .withOpacity(.55),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
