import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekip_bul_test/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Paylas extends StatefulWidget {
  bool gonderi;
  Paylas({Key key, @required this.gonderi}) : super(key: key);
  @override
  _PaylasState createState() => _PaylasState();
}

class _PaylasState extends State<Paylas> {
  Widget _body;
  String _textHint, _text, _boyut, _secilenBoyut, _ekipismi;
  var _maxLegth;
  String _email = FirebaseAuth.instance.currentUser.email;
  File _secilenresim;

  List<String> _EkipBoyutu = ['2', '3', '4', '5'];

  void initState() {
    super.initState();
    if (widget.gonderi == true) {
      _textHint = 'Ne Düşünüyorsun?';
      _maxLegth = 250;
      _body = GonderiPaylas();
    } else {
      _textHint = 'Ekibine katılmak isteyenler için birşeyler yaz...';
      _maxLegth = 500;
      _body = EkipKur();
    }
  }

  Widget GonderiPaylas() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 150.0),
        Text(
          'Takipçilerinle Düşüncelerini Paylaş',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.0),
        Divider(),
        SizedBox(height: 20.0),
        _buildTextF(),
        SizedBox(height: 15.0),
        Divider(),
        SizedBox(height: 15.0),
        _buildPaylasBtn(),
      ],
    );
  }

  Widget EkipKur() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Ekip Kuramak İçin Bir Gönderi Paylaş',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.0),
        Divider(),
        SizedBox(height: 20.0),
        Text(
          'Gönderinize resim eklemek için aşağıdaki resime tıklanyınız.\n'
          '(Resim eklemezseniz gönderiniz aşağıdaki resim ile paylaşılacaktır.)',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          width: 250,
          decoration: BoxDecoration(),
          child: InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image.asset(
                "assets/post_img/team.jpg",
                fit: BoxFit.fitWidth,
              ),
            ),
            onTap: () => _resimsec(),
          ),
        ),
        SizedBox(height: 20.0),
        Divider(),
        SizedBox(height: 20.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.group,
                color: Colors.white,
              ),
              hintText: 'Ekip için isim giriniz',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (x) {
              setState(() {
                _ekipismi = x;
              });
            },
          ),
        ),
        SizedBox(height: 20.0),
        Divider(),
        SizedBox(height: 20.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          padding: const EdgeInsets.all(0.0),
          child: DropdownButton<String>(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            dropdownColor: Colors.black45,
            iconEnabledColor: Colors.white,
            hint: Text(
              "Ekibiniz Kaç Kişilik Olacak?",
              style: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              ),
            ),
            isExpanded: true,
            value: _secilenBoyut,
            onChanged: (String newValue) {
              secBoyut(newValue);
            },
            items: _EkipBoyutu.map((location) {
              return DropdownMenuItem(
                child: Center(
                  child: new Text(location),
                ),
                value: location,
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 40.0),
        _buildTextF(),
        SizedBox(height: 20.0),
        Divider(),
        SizedBox(height: 20.0),
        _buildPaylasBtn(),
      ],
    );
  }

  Widget _buildTextF() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 170.0,
      child: TextField(
        maxLength: _maxLegth,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        minLines: 10,
        maxLines: 15,
        autocorrect: false,
        decoration: InputDecoration(
          hintStyle: kHintTextStyle,
          hintText: _textHint,
          filled: true,
        ),
        onChanged: (x) {
          setState(() {
            _text = x;
          });
        },
      ),
    );
  }

  Widget _buildPaylasBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: RaisedButton(
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Paylaş',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        onPressed: () {
          if (widget.gonderi == true) {
            _gndPaylas();
          } else {
            _ekipKur();
          }
        },
      ),
    );
  }

  Future _resimsec() async {
    final picker = ImagePicker();
    final _secilenfoto = (await picker.getImage(source: ImageSource.gallery));

    setState(
      () {
        _secilenresim = File(_secilenfoto.path);
      },
    );
  }

  String getRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future<void> _gndPaylas() async {
    await FirebaseFirestore.instance
        .collection("Kullanicilar")
        .doc(_email)
        .snapshots()
        .listen(
      (doc) async {
        FirebaseFirestore.instance.collection("Gonderiler").doc().set(
          {
            "Mesaj": _text,
            'Gonderi Sahibi': doc.get('Ad Soyad'),
            'Email': doc.get('Email'),
            'Profil Foto': doc.get('Profil Foto'),
          },
        ).then(
          (value) => Navigator.pop(context),
        );
      },
    );
  }

  void _ekipKur() async {
    if (_secilenresim == null) {
      //resim seçilmemişse varsayılan resmi kullan
      if (_text != null && _boyut != null) {
        FirebaseFirestore.instance.collection("Ekipler").doc(_email).set(
          {
            'Ekip İsmi': _ekipismi,
            'Ekip Lideri': _email,
            'Ekip Boyutu': _boyut,
            'Gonderi Mesaji': _text,
            'EkipID': _email,
            'Resim': "assets/post_img/team.jpg",
          },
        ).then(
          (value) => FirebaseFirestore.instance
              .collection('Kullanicilar')
              .doc(_email)
              .update({
            'Ekip': _ekipismi,
          }).whenComplete(
            () async {
              await FirebaseFirestore.instance
                  .collection("Kullanicilar")
                  .doc(_email)
                  .snapshots()
                  .listen(
                (doc) {
                  FirebaseFirestore.instance
                      .collection('EkipUyeleri')
                      .doc(_email)
                      .collection('Uyeler')
                      .doc(_email)
                      .set({
                    'Email': _email,
                    'Ad Soyad': doc['Ad Soyad'],
                    'Durum': doc['Durum'],
                    'Profil Foto': doc['Profil Foto']
                  }).whenComplete(() => Navigator.pop(context));
                },
              );
            },
          ),
        );
      }
    } else {
      var isim = getRandomString(5);
      Reference ref = FirebaseStorage.instance //seçilen resmi Storage'a ekle
          .ref()
          .child("ekip_foto")
          .child(_email)
          .child('$isim.jpg');
      firebase_storage.UploadTask uploadTask = ref.putFile(_secilenresim);
      var url = await (await uploadTask).ref.getDownloadURL();
      FirebaseFirestore.instance.collection("Ekipler").doc(_email).set(
        //ekip bilgilerini veritabanına ekle
        {
          'Ekip İsmi': _ekipismi,
          'Ekip Lideri': _email,
          'Ekip Boyutu': _boyut,
          'Ekip Uyeleri': [_email],
          'Gonderi Mesaji': _text,
          'EkipID': _email,
          'Resim': url,
        },
      ).then(
        (value) => FirebaseFirestore.instance
            .collection('Kullanicilar')
            .doc(_email)
            .update({
          'Ekip': _ekipismi,
        }).whenComplete(
          //kullanıcı ekip bilgisini güncelle
          () async {
            await FirebaseFirestore.instance
                .collection("Kullanicilar")
                .doc(_email)
                .snapshots()
                .listen(
              (doc) {
                FirebaseFirestore.instance
                    .collection('EkipUyeleri')
                    .doc(_email)
                    .collection('Uyeler')
                    .doc(_email)
                    .set({
                  'Email': _email,
                  'Ad Soyad': doc['Ad Soyad'],
                  'Durum': doc['Durum'],
                  'Profil Foto': doc['Profil Foto']
                }).whenComplete(() => Navigator.pop(context));
              },
            );
          },
        ),
      );
    }
  }

  void secBoyut(String value) {
    setState(() {
      _secilenBoyut = value;
      _boyut = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF7f7fd5),
                      Color(0xFF86a8e7),
                      Color(0xFF91eae4),
                    ],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: _body,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
