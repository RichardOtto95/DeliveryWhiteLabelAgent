import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../../../core/models/ads_model.dart';
import '../../../core/models/rating_model.dart';
// import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';
import '../../../shared/widgets/center_load_circular.dart';
import '../../main/main_store.dart';
import '../profile_store.dart';
import 'ratings_app_bar.dart';

class Ratings extends StatefulWidget {
  const Ratings({Key? key}) : super(key: key);

  @override
  State<Ratings> createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  final MainStore mainStore = Modular.get();
  final ProfileStore store = Modular.get();
  final User? _userAuth = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    store.clearNewRatings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Observer(
            builder: (context) {
              print("concluded: ${store.concluded}");
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("agents")
                    .doc(_userAuth!.uid)
                    .collection("ratings")
                    .where("answered", isEqualTo: store.concluded)
                    .orderBy("created_at", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  if (!snapshot.hasData) {
                    return CenterLoadCircular();
                  }
                  List<DocumentSnapshot<Map<String, dynamic>>> ratings =
                      snapshot.data!.docs;
                  print("ratings: $ratings");
                  if (ratings.isEmpty) {
                    return Container(
                      width: maxWidth(context),
                      height: maxHeight(context),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_border_rounded,
                              size: wXD(200, context),
                              color: getColors(context).onBackground),
                          Observer(
                            builder: (context) {
                              return Text("Sem avaliações ainda",
                                  style: textFamily(
                                    context,
                                  ));
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: viewPaddingTop(context) + wXD(60, context)),
                        ...ratings.map(
                          (rating) => Rating(
                            ratingModel: RatingModel.fromDocSnapshot(rating),
                            onTap: () => Modular.to.pushNamed(
                                '/profile/view-rating',
                                arguments: RatingModel.fromDocSnapshot(rating)),
                          ),
                        ),
                        SizedBox(height: wXD(120, context))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          RatingsAppbar(),
        ],
      ),
    );
  }
}

class Rating extends StatelessWidget {
  final RatingModel ratingModel;
  final void Function() onTap;
  final ProfileStore store = Modular.get();

  Rating({
    Key? key,
    required this.ratingModel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: wXD(6, context),
              left: wXD(4, context),
              top: wXD(20, context),
            ),
            child: Text(
              getRatingDate(ratingModel.createdAt!.toDate()),
              style: textFamily(
                context,
                fontSize: 14,
                color: getColors(context).onBackground.withOpacity(.8),
              ),
            ),
          ),
          Container(
            height: wXD(105, context),
            width: wXD(352, context),
            padding: EdgeInsets.fromLTRB(
              wXD(19, context),
              wXD(15, context),
              wXD(15, context),
              wXD(7, context),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffF1F1F1)),
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: getColors(context).surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 3),
                  color: Color(0x20000000),
                )
              ],
            ),
            alignment: Alignment.center,
            child: FutureBuilder<DocumentSnapshot>(
                future: store.getAdsDoc(ratingModel.orderId!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(getColors(context).primary),
                    );
                  }
                  AdsModel ads = AdsModel.fromDoc(snapshot.data!);

                  return InkWell(
                    onTap: onTap,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: wXD(12, context)),
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: ads.images.first,
                              height: wXD(65, context),
                              width: wXD(62, context),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          width: wXD(220, context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                ads.title,
                                style: textFamily(context,
                                    color: getColors(context).onBackground),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: wXD(3, context)),
                              Text(
                                ads.description,
                                style: textFamily(context,
                                    color: getColors(context)
                                        .onBackground
                                        .withOpacity(.5),
                                    fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // SizedBox(height: wXD(3, context)),
                              // Text(
                              //   '${grade.toString()} item',
                              //   style: textFamily(context,
                              //       color: getColors(context).onBackground.withOpacity(.7).withOpacity(.7)),
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                              RatingBar(
                                initialRating: ratingModel.rating!.toDouble(),
                                onRatingUpdate: (value) {},
                                ignoreGestures: true,
                                glowColor:
                                    getColors(context).primary.withOpacity(.4),
                                unratedColor:
                                    getColors(context).primary.withOpacity(.4),
                                allowHalfRating: true,
                                itemSize: wXD(25, context),
                                ratingWidget: RatingWidget(
                                  full: Icon(Icons.star_rounded,
                                      color: getColors(context).primary),
                                  empty: Icon(Icons.star_outline_rounded,
                                      color: getColors(context).primary),
                                  half: Icon(Icons.star_half_rounded,
                                      color: getColors(context).primary),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: wXD(10, context)),
                        Icon(
                          Icons.arrow_forward,
                          size: wXD(14, context),
                          color: getColors(context)
                              .onBackground
                              .withOpacity(.7)
                              .withOpacity(.7),
                        ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  // double getRatingMedia() {
  // double ratingMedia = (ratingModel.sellerRating! +
  //         ratingModel.productRating! +
  //         ratingModel.deliveryRating!) /
  //     3;
  //   return 0.0;
  // }

  String getRatingDate(DateTime date) {
    String strDate = '';

    String weekDay = DateFormat('EEEE').format(date);
    // print("weekDay: $weekDay");

    String month = DateFormat('MMMM').format(date);
    // print("month: $month");

    strDate =
        "${weekDay.substring(0, 1).toUpperCase()}${weekDay.substring(1, 3)} ${date.day} $month ${date.year}";
    // print("strDate: $strDate");

    return strDate;
  }
}

class StarsCharging extends StatefulWidget {
  const StarsCharging({Key? key}) : super(key: key);

  @override
  _StarsChargingState createState() => _StarsChargingState();
}

class _StarsChargingState extends State<StarsCharging>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 5000),
    );
    animationController.forward();
    animationController.addListener(() {
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
    return Row(
      children: List.generate(
        5,
        (index) => RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
          child: Icon(
            Icons.star_outline_rounded,
            color: getColors(context).primary,
            size: wXD(25, context),
          ),
        ),
      ),
    );
  }
}
