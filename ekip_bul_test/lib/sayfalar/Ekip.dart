import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekip_bul_test/widgets/kullaniciListele.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:line_icons/line_icons.dart';

class Ekip extends StatefulWidget {
  String EkipID, eIsim;
  Ekip({Key key, @required this.EkipID, this.eIsim}) : super(key: key);
  @override
  _EkipState createState() => _EkipState();
}

class _EkipState extends State<Ekip> {
  String _email = FirebaseAuth.instance.currentUser.email;
  String text;
  bool myteam;
  bool team;
  bool katilButton = false;
  int UyeSayisi = 0;

  initState() {
    super.initState();
    text = 'Ekibe Katıl';
    myteam_check();
    UyeSayAl();
  }

  myteam_check() async {
    await FirebaseFirestore.instance
        .collection("Kullanicilar")
        .doc(_email)
        .snapshots()
        .listen(
      (doc) {
        if (doc.get('Ekip') != widget.eIsim) {
          myteam = false;
          if (doc.get('Ekip') == 'Bir Ekipte Yer Almıyor') {
            team = false;
          } else {
            team = true;
          }
        } else {
          myteam = true;
          team = true;
        }
      },
    );
  }

  UyeSayAl() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('EkipUyeleri')
        .doc(widget.EkipID)
        .collection('Uyeler')
        .get();
    setState(() {
      UyeSayisi = snapshot.docs.length;
    });
  }

  _body(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Ekipler')
          .doc(widget.EkipID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Loading");
        }
        var doc = snapshot.data;
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: resim(doc['Resim']),
                ),
              ),
            ),
            Divider(),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Ekip Bilgileri',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              LineIcons.info,
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Açıklama",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 340,
                                  child: Text(
                                    doc['Gonderi Mesaji'],
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person_pin,
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ekip Lideri",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  doc['EkipID'],
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.white54,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.group,
                                color: Colors.white,
                                size: 35,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ekip Üyeleri" +
                                        '   -   ' +
                                        UyeSayisi.toString() +
                                        ' / ' +
                                        doc['Ekip Boyutu'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => kListele(
                                EkipID: doc['EkipID'],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    _buildkatilBtn(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        centerTitle: true,
        title: Text(widget.eIsim),
      ),
      body: SingleChildScrollView(
        child: _body(context),
      ),
    );
  }

  resim(img) {
    if (img == "assets/post_img/team.jpg") {
      return AssetImage(img);
    } else {
      return NetworkImage(img);
    }
  }

  Container buildButton({String text}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: () {
          if (!team) {
            ekibeKatil();
          } else {
            InfoAlertBox(
              context: context,
              title: 'Katılma Talebi Gönderilemiyor!',
              infoMessage:
                  'Bir ekipte bulunduğunuz için katılma talebi gönderilemiyor.',
              titleTextColor: Colors.red,
              buttonText: 'Kapat',
            );
          }
        },
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: katilButton ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: katilButton ? Colors.white : Colors.blue,
            border: Border.all(
              color: katilButton ? Colors.grey : Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  ekibeKatil() {
    FirebaseFirestore.instance
        .collection('Bildirimler')
        .doc(widget.EkipID)
        .collection('kBildirim')
        .doc(_email)
        .set({
      'Email': _email,
    });
  }

  _buildkatilBtn() {
    if (!myteam) {
      if (!katilButton) {
        return buildButton(
          text: text,
        );
      }
    } else {
      return Container();
    }
  }
}
