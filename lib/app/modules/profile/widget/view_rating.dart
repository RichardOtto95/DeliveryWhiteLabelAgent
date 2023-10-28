import 'package:delivery_agent_white_label/app/modules/profile/widget/type_evaluation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/rating_model.dart';
import '../../../core/models/time_model.dart';
import '../../../shared/utilities.dart';
import '../../../shared/widgets/default_app_bar.dart';
import '../../../shared/widgets/side_button.dart';
import '../profile_store.dart';

class AnswerRating extends StatefulWidget {
  final RatingModel ratingModel;

  const AnswerRating({Key? key, required this.ratingModel}) : super(key: key);

  @override
  _AnswerRatingState createState() => _AnswerRatingState();
}

class _AnswerRatingState extends State<AnswerRating> {
  final ProfileStore store = Modular.get();
  String answer = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        wXD(16, context),
                        viewPaddingTop(context) + wXD(60, context),
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
                            'Responda à avaliação',
                            style: textFamily(
                              context,
                              color: getColors(context).onBackground,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            Time(widget.ratingModel.createdAt!.toDate())
                                .dayDate(),
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
                      rating: widget.ratingModel.rating!.toDouble(),
                      text: widget.ratingModel.answer ?? "",
                      title: 'Opinião referente a entrega',
                      opinion: widget.ratingModel.opnion ?? "",
                      onChanged: (String value) {
                        answer = value;
                      },
                    ),
                    SizedBox(height: wXD(35, context)),
                    SideButton(
                      onTap: () async {
                        print(
                            'ontap _formKey.currentState!.validate(): ${_formKey.currentState!.validate()} - $answer');
                        if (_formKey.currentState!.validate()) {
                          await store.answerRating(
                              widget.ratingModel.id!, answer, context);
                          setState(() {
                            answer = "";
                          });
                        }
                      },
                      height: wXD(52, context),
                      width: wXD(150, context),
                      title: 'Responder',
                    ),
                    SizedBox(height: wXD(25, context)),
                  ],
                ),
              ),
            ),
            DefaultAppBar('Avaliação'),
          ],
        ),
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
