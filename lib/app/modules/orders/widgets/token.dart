import 'package:delivery_agent_white_label/app/shared/utilities.dart';

import 'package:flutter/material.dart';

class Token extends StatelessWidget {
  final String token;

  Token(this.token);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        wXD(23, context),
        wXD(23, context),
        wXD(16, context),
        wXD(29, context),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.vpn_key,
                size: wXD(23, context),
                color: getColors(context).primary,
              ),
              SizedBox(width: wXD(9, context)),
              Text(
                'Token',
                style: textFamily(
                  context,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: getColors(context).onBackground,
                ),
              ),
              Spacer(),
              Text(
                token,
                style: textFamily(
                  context,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: getColors(context).onBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: wXD(17, context)),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: wXD(5, context),
                  right: wXD(7, context),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Color(0xffbdbdbd),
                  size: wXD(20, context),
                ),
              ),
              Text(
                'Forneça este token ao vendedor para realizar a \nretirada do pedido.',
                style: textFamily(
                  context,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xffbdbdbd),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
