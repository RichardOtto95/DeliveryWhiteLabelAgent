import 'package:cached_network_image/cached_network_image.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../profile_store.dart';

class ProfileAppBar extends StatelessWidget {
  final ProfileStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).viewPadding.top + wXD(60, context),
      width: maxWidth(context),
      padding: EdgeInsets.only(
          bottom: wXD(5, context), top: MediaQuery.of(context).viewPadding.top),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(3),
        ),
        color: getColors(context).surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Color(0x30000000),
            offset: Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.bottomLeft,
      child: Observer(builder: (context) {
        return GestureDetector(
          onTap: () => Modular.to.pushNamed('/profile/edit-profile'),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: wXD(53, context),
                width: wXD(53, context),
                margin: EdgeInsets.only(
                    left: wXD(30, context), right: wXD(20, context)),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // color: getColors(context).primary.withOpacity(.8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: store.profileData.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              getColors(context).primary,
                            ),
                          ),
                        )
                      : store.profileData['avatar'] == null ||
                              store.profileData['avatar'] == ''
                          ? Image.asset(
                              "./assets/images/defaultUser.png",
                              fit: BoxFit.fill,
                            )
                          : CachedNetworkImage(
                              imageUrl: store.profileData['avatar'],
                              fit: BoxFit.fill,
                            ),
                ),
              ),
              Container(
                height: wXD(53, context),
                width: wXD(270, context),
                padding: EdgeInsets.symmetric(vertical: wXD(4, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    store.profileData.isEmpty
                        ? Container(
                            height: wXD(14, context),
                            width: wXD(130, context),
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                getColors(context).primary.withOpacity(.7),
                              ),
                              backgroundColor:
                                  getColors(context).primary.withOpacity(.5),
                            ),
                          )
                        : Text(
                            store.profileData['username'],
                            style: textFamily(
                              context,
                              color: getColors(context).primary,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                    const Spacer(),
                    Text(
                      'Editar perfil',
                      style: textFamily(
                        context,
                        color: getColors(context).primary,
                        fontWeight: FontWeight.w200,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
