import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekip_bul_test/sayfalar/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bildirimSayfasi extends StatefulWidget {
  @override
  _bildirimSayfasiState createState() => _bildirimSayfasiState();
}

class _bildirimSayfasiState extends State<bildirimSayfasi> {
  String _myemail = FirebaseAuth.instance.currentUser.email;
  Widget _body;

  void initState() {
    super.initState();
    _body = bildirim(context);
  }

  Widget bildirim(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Bildirimler')
          .doc(_myemail)
          .collection('kBildirim')
          .snapshots(),
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
          childAspectRatio: 60 / 9.0,
          children: snapshot.data.docs.map(
            (doc) {
              return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(
                            height: 55,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _body = Profile(
                                  email: doc['Email'],
                                );
                              });
                            },
                            child: Text(
                              doc['Email'],
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                          Text(
                            'ekibinize katılmak istiyor.',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.check_circle_rounded),
                            onPressed: () {
                              Onayla(doc['Email']);
                            },
                            iconSize: 30,
                            color: Colors.green,
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle),
                            onPressed: () {
                              reddEt(doc['Email']);
                            },
                            iconSize: 30,
                            color: Colors.red,
                          )
                        ],
                      )
                    ],
                  ));
            },
          ).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _body;
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

  Future<void> Onayla(String email) async {
    await FirebaseFirestore.instance
        .collection("Kullanicilar")
        .doc(email)
        .snapshots()
        .listen(
      (doc) {
        FirebaseFirestore.instance
            .collection(
                'EkipUyeleri') //EkipUyeleri kolleksiyonuna yeni belge eklenir
            .doc(_myemail)
            .collection('Uyeler')
            .doc(email)
            .set({
          'Email': email,
          'Ad Soyad': doc['Ad Soyad'],
          'Durum': doc['Durum'],
          'Profil Foto': doc['Profil Foto']
        }).then((value) {
          //bu işlemlerden sonra kullanıcının ekibini güncelle
          FirebaseFirestore.instance
              .collection('Kullanicilar')
              .doc(email)
              .update({'EkipID': _myemail, 'Ekip': 'Test Ekip'}).whenComplete(
            () => reddEt(email),
          );
        });
      },
    );
  }

  reddEt(String email) {
    FirebaseFirestore.instance
        .collection(
            'Bildirimler') //Bildirimler koleksiyonundan bu bildirimi sil
        .doc(_myemail)
        .collection('kBildirim')
        .doc(email)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }
}
