import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekip_bul_test/sayfalar/AnaSayfa.dart';
import 'package:ekip_bul_test/sayfalar/bildirim.dart';
import 'package:ekip_bul_test/sayfalar/kesfet.dart';
import 'package:ekip_bul_test/sayfalar/paylas.dart';
import 'package:ekip_bul_test/sayfalar/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:unicorndial/unicorndial.dart';

import 'Ekip.dart';
import 'oturum_aç.dart';

class EkipBulGovde extends StatefulWidget {
  @override
  _EkipBulGovdeState createState() => _EkipBulGovdeState();
}

class _EkipBulGovdeState extends State<EkipBulGovde> {
  String _email = FirebaseAuth.instance.currentUser.email;
  bool ekip = false;
  Widget _body;
  int _selectedIndex = 0;
  bool
      gonderi; //gonderi true ise gönderi paylaşıyoruz, false ise ekip kurmak için gönderi paylaşıyoruz
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  void initState() {
    super.initState();
    ekipKontrol();
    _body = AnaSayfa(); //Uygulama başlarken Ana Sayfa gösterilir
  }

  ekipKontrol() async {
    await FirebaseFirestore.instance
        .collection("Kullanicilar")
        .doc(_email)
        .snapshots()
        .listen(
      (doc) {
        if (doc.get('Ekip') == 'Bir Ekipte Yer Almıyor') {
          setState(() {
            ekip = false;
          });
        } else {
          setState(() {
            ekip = true;
          });
        }
      },
    );
  }

//Navigation Bar sayfa geçişleri
  void onTabChange(int index) {
    _selectedIndex = index;
    if (index == 0) {
      gitAnasayfa();
    }
    if (index == 1) {
      gitKesfet();
    }
    if (index == 2) {
      gitBildirimler();
    }
    if (index == 3) {
      gitProfil();
    }
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = <UnicornButton>[];
    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Ekip Kur",
        currentButton: FloatingActionButton(
          heroTag: "EKip",
          backgroundColor: Color(0xFF91eae4),
          mini: true,
          child: Icon(Icons.group),
          onPressed: () {
            gitEkipKur();
          },
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Gönderi Paylaş",
        currentButton: FloatingActionButton(
          heroTag: "Gönderi",
          backgroundColor: Color(0xFF86a8e7),
          mini: true,
          child: Icon(Icons.post_add),
          onPressed: () => _paylas(true),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Color(0xFF7f7fd5),
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: childButtons),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 20,
        title: const Text('EkipBul'),
        actions: <Widget>[
          //Ekip Bilgileri Butonu
          IconButton(
            icon: const Icon(
              Icons.group_outlined,
            ),
            tooltip: 'Ekip',
            onPressed: () => gitEkip(),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              ConfirmAlertBox(
                context: context,
                infoMessage: 'Oturmu kapatmak istiyor musunuz?',
                title: 'Oturumu Kapat',
                buttonTextForNo: 'Hayır',
                buttonTextForYes: 'Evet',
                buttonColorForYes: Colors.lightGreen,
                onPressedYes: () {
                  oturumuKapat();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(child: _body),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300],
              hoverColor: Colors.grey[100],
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100],
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Ana Sayfa',
                ),
                GButton(
                  icon: Icons.explore_outlined,
                  text: 'Keşfet',
                ),
                GButton(
                  icon: Icons.auto_awesome,
                  text: 'Bildirimler',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) => onTabChange(index),
            ),
          ),
        ),
      ),
    );
  }

  _paylas(bool gnd) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Paylas(gonderi: gnd)),
    );
  }

  oturumuKapat() async {
    await FirebaseAuth.instance.signOut().then(
      (value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => OturumAc()),
            (Route<dynamic> route) => false);
      },
    );
  }

  gitEkipKur() {
    if (!ekip) {
      _paylas(false);
    } else {
      InfoAlertBox(
        context: context,
        title: 'Ekip Gönderisi Paylaşılamıyor!',
        infoMessage:
            'Bir ekipte bulunduğunuz için ekip gönderisi paylaşılamıyor',
        titleTextColor: Colors.red,
        buttonText: 'Kapat',
      );
    }
  }

  gitEkip() async {
    await FirebaseFirestore.instance
        .collection("Ekipler")
        .doc(_email)
        .snapshots()
        .listen((doc2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Ekip(
            EkipID: doc2.get('EkipID'),
            eIsim: doc2.get('Ekip İsmi'),
          ),
        ),
      );
    });
  }

  gitAnasayfa() {
    setState(() {
      _body = AnaSayfa();
    });
  }

  gitKesfet() {
    setState(
      () {
        _body = Kesfet();
      },
    );
  }

  gitBildirimler() {
    setState(() {
      _body = bildirimSayfasi();
    });
  }

  gitProfil() {
    setState(
      () {
        _body = Profile(email: _email);
      },
    );
  }
}
