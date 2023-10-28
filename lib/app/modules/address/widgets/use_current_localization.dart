import 'package:flutter/material.dart';

import '../../../shared/utilities.dart';

class UseCurrentLocalization extends StatelessWidget {
  const UseCurrentLocalization({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
          left: wXD(27, context),
          top: wXD(34, context),
          bottom: wXD(24, context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.my_location,
            size: wXD(20, context),
            color:
                getColors(context).onBackground.withOpacity(.7).withOpacity(.5),
          ),
          SizedBox(width: wXD(12, context)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Usar localização atual',
                style: textFamily(
                  context,
                  fontSize: 15,
                  color: getColors(context).primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: wXD(225, context),
                child: Text(
                  'St. Hab. Vicente Pires Chácara 26 - Taguatinga, Brasília - DF ',
                  style: textFamily(
                    context,
                    fontSize: 13,
                    color: getColors(context)
                        .onBackground
                        .withOpacity(.7)
                        .withOpacity(.55),
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
