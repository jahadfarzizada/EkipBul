import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekip_bul_test/sayfalar/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnaSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Gonderiler')
          .snapshots(), //tüm gönderileri listele
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
          childAspectRatio: 27 / 9.0,
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
                        builder: (context) => Profile(email: doc['Email']),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      resim(doc['Profil Foto']),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                doc['Gonderi Sahibi'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '( ' + doc['Email'] + ' )',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: 'OpenSans',
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                            width: 340,
                            child: Text(
                              doc['Mesaj'],
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'OpenSans',
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
    if (img == "assets/profilephoto/profilephoto.jpg") {
      return CircleAvatar(
        radius: 50.0,
        backgroundImage: AssetImage(img),
        backgroundColor: Colors.white,
      );
    } else {
      return CircleAvatar(
        radius: 50.0,
        backgroundImage: NetworkImage(img),
        backgroundColor: Colors.white,
      );
    }
  }
}
