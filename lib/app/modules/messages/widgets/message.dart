import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/models/message_model.dart';
import '../../../core/models/time_model.dart';
import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';

class MessageWidget extends StatelessWidget {
  final Message messageData;
  final bool isAuthor;
  final bool messageBold;

  const MessageWidget({
    Key? key,
    required this.messageData,
    required this.isAuthor,
    required this.messageBold,
  }) : super(key: key);

  @override
  Widget build(context) {
    return Container(
      width: maxWidth(context),
      // padding: EdgeInsets.only(top: wXD(18, context)),
      alignment: isAuthor ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isAuthor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          messageData.fileType != null &&
                  messageData.fileType!.startsWith("image/")
              ? Container(
                  padding: EdgeInsets.all(wXD(7, context)),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    color: isAuthor
                        ? getColors(context).primary.withOpacity(.8)
                        : getColors(context).primary.withOpacity(.3),
                  ),
                  margin: EdgeInsets.only(
                    top: wXD(8, context),
                    right: wXD(10, context),
                    left: wXD(10, context),
                  ),
                  height: wXD(285, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: wXD(250, context),
                        constraints: BoxConstraints(
                            minWidth: wXD(150, context),
                            maxWidth: wXD(250, context)),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                          child: CachedNetworkImage(
                            imageUrl: messageData.file!,
                            fit: BoxFit.fitHeight,
                            progressIndicatorBuilder: (context, _, a) =>
                                const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: wXD(3, context)),
                      Text(
                        messageData.createdAt != null
                            ? Time(messageData.createdAt!.toDate()).hour()
                            : "",
                        textAlign: isAuthor ? TextAlign.right : TextAlign.left,
                        style: textFamily(
                          context,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: getColors(context).onPrimary,
                        ),
                      ),
                    ],
                  ),
                )
              // Container(
              //     padding: EdgeInsets.all(wXD(7, context)),
              //     margin: EdgeInsets.only(
              //       top: wXD(8, context),
              //       left: isAuthor ? wXD(100, context) : wXD(10, context),
              //       right: isAuthor ? wXD(10, context) : wXD(100, context),
              //     ),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(3)),
              //       color: isAuthor ? getColors(context).onBackground : getColors(context).primary,
              //     ),
              //     alignment: Alignment.center,
              //     child: Column(
              //       crossAxisAlignment: isAuthor
              //           ? CrossAxisAlignment.end
              //           : CrossAxisAlignment.start,
              //       children: [
              //         ClipRRect(
              //           borderRadius: BorderRadius.all(Radius.circular(3)),
              //           child: CachedNetworkImage(
              //             imageUrl: messageData.file!,
              //             progressIndicatorBuilder: (context, _, a) =>
              //                 CircularProgressIndicator(
              //               valueColor:
              //                   AlwaysStoppedAnimation(getColors(context).primary),
              //             ),
              //           ),
              //         ),
              //         SizedBox(height: wXD(3, context)),
              //         Text(
              //           messageData.createdAt != null ?
              //           Time(messageData.createdAt!.toDate()).hour() : "",
              //           textAlign: isAuthor ? TextAlign.right : TextAlign.left,
              //           style: textFamily(context,
              //             fontSize: 11,
              //             fontWeight: FontWeight.w400,
              //             color: isAuthor
              //                 ?getColors(context).onSurface
              //                 : getColors(context).onBackground,
              //           ),
              //         ),
              //       ],
              //     ),
              //   )
              : Container(
                  padding: EdgeInsets.
                      // symmetric(
                      //     horizontal: wXD(20, context), vertical: wXD(16, context)),
                      fromLTRB(
                    wXD(isAuthor ? 30 : 23, context),
                    wXD(16, context),
                    wXD(isAuthor ? 23 : 30, context),
                    wXD(5, context),
                  ),
                  margin: EdgeInsets.only(
                    left: isAuthor ? wXD(36, context) : 0,
                    right: isAuthor ? 0 : wXD(36, context),
                    top: wXD(8, context),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(isAuthor ? 3 : 0),
                      right: Radius.circular(isAuthor ? 0 : 3),
                    ),
                    color: isAuthor
                        ? getColors(context).primary.withOpacity(.8)
                        : getColors(context).primary.withOpacity(.3),
                  ),
                  child: Column(
                    crossAxisAlignment: isAuthor
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        messageData.text!,
                        textAlign: TextAlign.left,
                        style: textFamily(
                          context,
                          fontSize: 14,
                          fontWeight:
                              messageBold ? FontWeight.bold : FontWeight.w400,
                          color: getColors(context).onPrimary,
                        ),
                      ),
                      SizedBox(height: wXD(3, context)),
                      Text(
                        messageData.createdAt != null
                            ? Time(messageData.createdAt!.toDate()).hour()
                            : "",
                        textAlign: isAuthor ? TextAlign.right : TextAlign.left,
                        style: textFamily(
                          context,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: getColors(context).onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
