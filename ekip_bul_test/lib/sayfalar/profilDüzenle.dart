import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

import '../constants/constants.dart';

class ProfilDuzenle extends StatefulWidget {
  @override
  _ProfilDuzenleState createState() => _ProfilDuzenleState();
}

class _ProfilDuzenleState extends State<ProfilDuzenle> {
  var foto;
  String _email = FirebaseAuth.instance.currentUser.email;
  String _durum, _bio, _okul, _fb, _ig, _tw;
  File _profilfoto;

  void initState() {
    super.initState();
    foto = "assets/profilephoto/photoedit.jpg";
  }

  Widget _Durum() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '(İsminizin altında gözükecek kısa durum bilgisi giriniz)',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            maxLength: 20,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                LineIcons.fontAwesome,
                color: Colors.white,
              ),
              hintText: 'Durum',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (x) {
              setState(() {
                _durum = x;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _Biyografi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            maxLength: 100,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                LineIcons.info,
                color: Colors.white,
              ),
              hintText: 'Biyografi',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (x) {
              setState(() {
                _bio = x;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _Okul() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '(Okumakta olduğunuz veya en son mezun olduğunuz okulu belirtin)',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
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
                LineIcons.graduationCap,
                color: Colors.white,
              ),
              hintText: 'Okul İsmi',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (x) {
              setState(() {
                _okul = x;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _Facebook() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                LineIcons.facebookF,
                color: Colors.white,
              ),
              hintText: 'Facebook',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (x) {
              setState(() {
                _fb = x;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _Instagram() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                LineIcons.instagram,
                color: Colors.white,
              ),
              hintText: 'Instagram',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (x) {
              setState(() {
                _ig = x;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _Twitter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                LineIcons.twitter,
                color: Colors.white,
              ),
              hintText: 'Twitter',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (x) {
              setState(() {
                _tw = x;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _kaydetBtn() {
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
          'KAYDET',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        onPressed: () => bilgiGuncelle(context),
      ),
    );
  }

  Future _profilfotoSec() async {
    final picker = ImagePicker();
    final _secilenfoto = (await picker.getImage(
        source: ImageSource.gallery)); //galeriden resim seç

    setState(
      () {
        _profilfoto = File(_secilenfoto.path); //seçilen resmin yolunu tut
        foto = "assets/profilephoto/tick.jpg";
      },
    );
  }

  Future bilgiGuncelle(BuildContext context) async {
    Reference ref = FirebaseStorage.instance //seçilen resmi Storage'a ekle
        .ref()
        .child("kullanici_foto")
        .child(_email)
        .child("profilfoto.png");
    firebase_storage.UploadTask uploadTask = ref.putFile(_profilfoto);
    var url = await (await uploadTask).ref.getDownloadURL();
    FirebaseFirestore.instance.collection('Kullanicilar').doc(_email).update(
      //kullanıcı bilgilerini göncelle
      {
        'Profil Foto': '$url',
        'Durum': _durum,
        'Biyografi': _bio,
        'Okul': _okul,
        'Facebook': 'https://www.facebook.com/' + _fb,
        'Instagram': 'https://www.instagram.com/' + _ig,
        'Twitter': 'https://www.twitter.com/' + _tw,
      },
    ).whenComplete(() => Navigator.pop(context)); //bittiğinde geri dön
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Profil Bilgilerini Düzenle',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      InkWell(
                        onTap: () => _profilfotoSec(),
                        child: CircleAvatar(
                          radius: 65.0,
                          backgroundImage: AssetImage(foto),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _Durum(),
                      SizedBox(height: 30.0),
                      _Biyografi(),
                      SizedBox(height: 30.0),
                      _Okul(),
                      SizedBox(height: 40.0),
                      Text(
                        '(Sosyal medya hesapları için kullandığınız kullanıcı adınızı giriniz)',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _Facebook(),
                      SizedBox(height: 30.0),
                      _Instagram(),
                      SizedBox(height: 30.0),
                      _Twitter(),
                      SizedBox(height: 30.0),
                      _kaydetBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
