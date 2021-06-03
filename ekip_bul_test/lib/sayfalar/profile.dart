import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekip_bul_test/sayfalar/profilD%C3%BCzenle.dart';
import 'package:ekip_bul_test/widgets/gonderiListele.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  String email; //profili ziyaret edilen kullanıcının emaili

  Profile({Key key, @required this.email}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _myemail =
      FirebaseAuth.instance.currentUser.email; //şuanki kullanıcının emaili
  Color cardcolor = Colors.white;
  bool takipEdiyorMu = false;
  int takipciSayisi = 0;
  int takipSayisi = 0;

  CollectionReference takipciRef =
      FirebaseFirestore.instance.collection('Followers');
  CollectionReference takipRef =
      FirebaseFirestore.instance.collection('Following');

  void initState() {
    super.initState();
    takipKontrol();
    takipciSayAl();
    takipSayAl();
  }

  //Kullanıcı takip ediliyormu diye kontrol et
  takipKontrol() async {
    DocumentSnapshot doc = await takipciRef
        .doc(widget.email)
        .collection('userFollowers')
        .doc(_myemail)
        .get();
    setState(() {
      takipEdiyorMu = doc.exists;
    });
  }

  //Takipçi syısını al
  takipciSayAl() async {
    QuerySnapshot snapshot =
        await takipciRef.doc(widget.email).collection('userFollowers').get();
    setState(() {
      takipciSayisi = snapshot.docs.length;
    });
  }

  //Takip edilen sayısını al
  takipSayAl() async {
    QuerySnapshot snapshot =
        await takipRef.doc(widget.email).collection('userFollowing').get();
    setState(() {
      takipSayisi = snapshot.docs.length;
    });
  }

  //Profili düzenle ve ya takip et butonunu düzenle
  buildProfileButton() {
    //bu profilin sahibi şuanki kullanıcı mı?
    bool profilSahibi = _myemail == widget.email;
    if (profilSahibi) {
      return buildButton(
        text: "Profili Düzenle",
        function: profilDuzenle,
      );
    } else if (takipEdiyorMu) {
      return buildButton(
        text: "Takibi Bırak",
        function: takipBirak,
      );
    } else if (!takipEdiyorMu) {
      return buildButton(
        text: "Takip Et",
        function: takipEt,
      );
    }
  }

  //takip et
  takipEt() {
    setState(() {
      takipEdiyorMu = true;
    });
    // Kullanıcının takipçilerine ekle
    takipciRef.doc(widget.email).collection('userFollowers').doc(_myemail).set({
      'Email': widget.email,
    });
    // Bu hesabın takip edilenlerine ekle
    takipRef.doc(_myemail).collection('userFollowing').doc(widget.email).set({
      'Email': _myemail,
    });
  }

  //takipi bırak
  takipBirak() {
    setState(() {
      takipEdiyorMu = false;
    });
    // kullanıcıdan sil
    takipciRef
        .doc(widget.email)
        .collection('userFollowers')
        .doc(_myemail)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // bu hesaptan sil
    takipRef
        .doc(_myemail)
        .collection('userFollowing')
        .doc(widget.email)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  //profili düznle
  profilDuzenle() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilDuzenle()));
  }

  //Buton oluştur
  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: takipEdiyorMu ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: takipEdiyorMu ? Colors.white : Colors.blue,
            border: Border.all(
              color: takipEdiyorMu ? Colors.grey : Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  //Kullanıcı bilgileri
  Container BilgilerContainer(doc) {
    return Container(
      child: Column(
        children: [
          Card(
            color: cardcolor,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      child: Column(
                    children: [
                      Text(
                        'Takip',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        takipSayisi.toString(),
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      )
                    ],
                  )),
                  Container(
                    child: Column(children: [
                      Text(
                        'Takipçi',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        takipciSayisi.toString(),
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            color: cardcolor,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bilgiler",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          LineIcons.info,
                          color: Colors.blueAccent[400],
                          size: 35,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Biyografi",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              doc['Biyografi'],
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          LineIcons.graduationCap,
                          color: Colors.purple[400],
                          size: 35,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Okul Bilgileri",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              doc['Okul'],
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.people_alt_outlined,
                          color: Colors.green[400],
                          size: 35,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ekip",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              doc['Ekip'],
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => gListele(
                              email: widget.email,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            color: Colors.pinkAccent[400],
                            size: 35,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            "Paylaşımlar",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            width: 290,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey[800],
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            color: cardcolor,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sosyal Medya Hesapları",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    InkWell(
                      onTap: () => _launchInBrowser(doc['Facebook']),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            LineIcons.facebookF,
                            color: Colors.blueAccent[400],
                            size: 35,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            "Facebook",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            width: 301,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey[800],
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () => _launchInBrowser(doc['Instagram']),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            LineIcons.instagram,
                            color: Color(0xFFbc2a8d),
                            size: 35,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            "Instagram",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            width: 300,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey[800],
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () => _launchInBrowser(doc['Twitter']),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            LineIcons.twitter,
                            color: Color(0xFF1DA1F2),
                            size: 35,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            "Twitter",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            width: 320,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey[800],
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Sosyal medya linklerini aç
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Bağlantı başarısız $url';
    }
  }

  //Kullanıcı varsayılan profil resmini kullanıyor mu diye kontrol et ve profile resmini göster
  Widget resim(img) {
    if (img == "assets/profilephoto/profilephoto.jpg") {
      return CircleAvatar(
        radius: 65.0,
        backgroundImage: AssetImage(img),
        backgroundColor: Colors.white,
      );
    } else {
      return CircleAvatar(
        radius: 65.0,
        backgroundImage: NetworkImage(img),
        backgroundColor: Colors.white,
      );
    }
  }

  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Kullanicilar')
          .doc(widget.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.3,
            alignment: FractionalOffset.center,
            child: CircularProgressIndicator(),
          );
        }
        var doc = snapshot.data;
        return new Column(
          children: [
            Container(
              height: 400,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF7f7fd5),
                                Color(0xFF86a8e7),
                                Color(0xFF91eae4),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 90.0,
                              ),
                              resim(doc['Profil Foto']),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                doc['Ad Soyad'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                doc['Durum'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              buildProfileButton(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BilgilerContainer(doc),
          ],
        );
      },
    );
  }
}
