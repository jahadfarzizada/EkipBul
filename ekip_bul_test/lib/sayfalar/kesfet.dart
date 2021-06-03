import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'Ekip.dart';

class Kesfet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Ekipler')
          .snapshots(), //Tüm ekip bul gönderilerini listele
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.3,
            alignment: FractionalOffset.center,
            child: CircularProgressIndicator(),
          );
        }
        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: 1,
          padding: EdgeInsets.all(15),
          childAspectRatio: 20 / 9.0,
          children: snapshot.data.docs.map(
            (doc) {
              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Ekip(
                          EkipID: doc['EkipID'],
                          eIsim: doc['Ekip İsmi'],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      resim(doc['Resim']),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          doc['Ekip İsmi'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    height: 100,
                                    child: ListTile(
                                      subtitle: Text(
                                        doc['Gonderi Mesaji'],
                                        maxLines: 5,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    height: 15,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          LineIcons.share,
                                          size: 15,
                                          color: Colors.white54,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          doc['EkipID'],
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontFamily: 'OpenSans',
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

  Widget resim(img) {
    if (img == "assets/post_img/team.jpg") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(img, width: 200, height: 200, fit: BoxFit.cover),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(img, width: 200, height: 200, fit: BoxFit.cover),
      );
    }
  }
}
