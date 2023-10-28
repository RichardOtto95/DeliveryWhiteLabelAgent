import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../profile_store.dart';

class RatingsAppbar extends StatelessWidget {
  final ProfileStore store = Modular.get();
  RatingsAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).viewPadding.top + wXD(70, context),
          padding: EdgeInsets.only(
            left: wXD(30, context),
            right: wXD(30, context),
            top: MediaQuery.of(context).viewPadding.top,
          ),
          width: maxWidth(context),
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(3)),
            color: getColors(context).surface,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                offset: Offset(0, 3),
                color: Color(0x30000000),
              ),
            ],
          ),
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Avaliações',
                style: textFamily(
                  context,
                  fontSize: 20,
                  color: getColors(context).primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: wXD(8, context)),
              DefaultTabController(
                length: 2,
                child: TabBar(
                  indicatorColor: getColors(context).primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.symmetric(vertical: 8),
                  labelColor: getColors(context).primary,
                  labelStyle: textFamily(context, fontWeight: FontWeight.bold),
                  unselectedLabelColor:
                      getColors(context).onBackground.withOpacity(.9),
                  indicatorWeight: 3,
                  onTap: (val) {
                    print("concluded: ${store.concluded}");
                    store.concluded = val == 1;
                    print("concluded: ${store.concluded}");
                  },
                  tabs: [
                    Text('Pendentes'),
                    Text('Concluídas'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: wXD(30, context),
          top: MediaQuery.of(context).viewPadding.top,
          child: GestureDetector(
            onTap: () => Modular.to.pop(),
            child: Icon(Icons.arrow_back,
                color: getColors(context).onBackground.withOpacity(.9),
                size: wXD(25, context)),
          ),
        )
      ],
    );
  }
}
