import 'package:flutter/material.dart';

import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';

class SearchMessages extends StatefulWidget {
  final void Function(String) onChanged;

  SearchMessages({Key? key, required this.onChanged}) : super(key: key);
  @override
  _SearchMessagesState createState() => _SearchMessagesState();
}

class _SearchMessagesState extends State<SearchMessages> {
  FocusNode searchFocus = FocusNode();
  bool searching = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOutQuart,
      width: maxWidth(context) - wXD(16, context),
      height: wXD(41, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        border: Border.all(
            color: getColors(context)
                .onBackground
                .withOpacity(.9)
                .withOpacity(.2)),
        color: getColors(context).background,
        boxShadow: [
          BoxShadow(
              blurRadius: 4, offset: Offset(0, 3), color: Color(0x10000000)),
        ],
      ),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // print('searchFocus: ${searchFocus.hasFocus}');
            if (!searching) {
              searchFocus.requestFocus();
            } else {
              searchFocus.unfocus();
            }
            setState(() => searching = !searching);
          },
          borderRadius: BorderRadius.all(Radius.circular(3)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: wXD(65, context),
                ),
                Container(
                  // duration: Duration(seconds: 1),
                  // curve: Curves.easeInOutQuart,
                  width: wXD(200, context),
                  alignment: Alignment.center,
                  child: TextField(
                    onChanged: widget.onChanged,
                    focusNode: searchFocus,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Buscar mensagens',
                      hintStyle: textFamily(
                        context,
                        fontSize: 14,
                        color: Color(0xff8F9AA2).withOpacity(.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: wXD(65, context),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: searching ? wXD(35, context) : 0),
                    child: Icon(
                      Icons.search,
                      size: wXD(26, context),
                      color: Color(0xff8f9aa2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
