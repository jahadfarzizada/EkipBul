import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekip_bul_test/sayfalar/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class kListele extends StatefulWidget {
  String EkipID;
  kListele({Key key, @required this.EkipID}) : super(key: key);
  _kListeleState createState() => _kListeleState();
}

class _kListeleState extends State<kListele> {
  String _title;
  Widget _body;

  initState() {
    super.initState();
    _title = 'Ekip Üyeleri';
    _body = _listele(context);
  }

  @override
  Widget _listele(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('EkipUyeleri')
          .doc(widget.EkipID)
          .collection('Uyeler')
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
          childAspectRatio: 40 / 9.0,
          children: snapshot.data.docs.map(
            (doc) {
              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _title = doc['Ad Soyad'];
                      _body = Profile(email: doc['Email']);
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: [
                          resim(doc['Profil Foto']),
                          SizedBox(
                            width: 80,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                doc['Ad Soyad'],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '( ' + doc['Email'] + ' )',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: 'OpenSans',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                doc['Durum'],
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: 'OpenSans',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        centerTitle: true,
        title: Text(_title),
      ),
      body: SingleChildScrollView(
        child: _body,
      ),
    );
  }
}
