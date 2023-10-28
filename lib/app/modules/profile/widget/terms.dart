import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Terms extends StatelessWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('info').get(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return const LinearProgressIndicator();
                }
                QuerySnapshot infoQuery = snapshot.data!;
                DocumentSnapshot infoDoc = infoQuery.docs[0];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: viewPaddingTop(context) + wXD(60, context)),
                    Text(
                      'Termos e condições',
                      style: textFamily(
                        context,
                        color: getColors(context).primary,
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: maxWidth(context),
                      height: wXD(800, context),
                      child: SfPdfViewer.network(
                        infoDoc['privacy_policy'],
                        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details){
                          print('details: $details');
                          print('details: ${details.description}');
                          print('details: ${details.error}');
                        },
                        onDocumentLoaded: (PdfDocumentLoadedDetails details){
                          print('details: $details');
                          print('details: ${details.document}');
                        },  
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
          DefaultAppBar('Termos de uso'),
        ],
      ),
    );
  }
}
