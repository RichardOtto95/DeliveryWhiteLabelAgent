import 'package:delivery_agent_white_label/app/shared/utilities.dart';

import 'package:flutter/material.dart';

class CustomAppBarWithTabs extends StatefulWidget
    implements PreferredSizeWidget {
  CustomAppBarWithTabs({Key? key, required this.title})
      : preferredSize = Size.fromHeight(80.0),
        super(key: key);
  @override
  final Size preferredSize;
  final String title;

  @override
  _CustomAppBarWithTabsState createState() => _CustomAppBarWithTabsState();
}

class _CustomAppBarWithTabsState extends State<CustomAppBarWithTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(107, context),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 244, 228, 1),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(3)),
      ),
      child: DefaultTabController(
          length: 2,
          child: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.place_outlined),
                Text(widget.title,
                    style: TextStyle(
                        color: getColors(context).onSurface, fontSize: 12)),
              ],
            ),
            iconTheme: IconThemeData(color: getColors(context).onSurface),
            backgroundColor: Colors.black,
            bottom: TabBar(
              indicatorColor: Colors.orange,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.symmetric(vertical: 12),
              labelColor: Colors.orange,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelColor: getColors(context).onSurface,
              indicatorWeight: 3,
              tabs: [Text('Delivery em 2h'), Text('Encomenda')],
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(3))),
          )),
    );
  }
}
