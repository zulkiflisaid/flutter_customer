import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pelanggan/bottom_page/account.dart';
import 'package:pelanggan/bottom_page/inboxs.dart';
import 'package:pelanggan/bottom_page/orders.dart';
//import 'package:pelanggan/constans.dart';
import 'package:pelanggan/beranda/beranda_view.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:badges/badges.dart';

import 'helperClass.dart';

class LandingPage extends StatefulWidget {
  // LandingPage() : super();
  // LandingPage({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor
  // final String title;
  // final String uid; //include this

  LandingPage({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseUser currentUser;
  DocumentReference docRef;
  int _currentIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  List<Widget> _children;
  //PageController _pageController;
  bool badGas_1 = false;

  bool badGas_2 = false;
  bool badGas_3 = true;

  //GCM FIRBASE
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isSubscribed = false;
  String gcmToken = "";
  String _homeScreenText = "Waiting for token...";
  //String _messageText = "Waiting for message...";
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static const platform = const MethodChannel('com.startActivity/testChannel');

  @override
  void initState() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          // setState(() {
          // _messageText = "Push Messaging message: $message";
          // });
          print("onMessage landing: $message");
          //_closeActivity();
          showNotification(message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          // setState(() {
          // _messageText = "Push Messaging message: $message";
          // });
          print("onLaunch landing: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          // setState(() {
          //_messageText = "Push Messaging message: $message";
          //});
          print("onResume landing: $message");
        },
        /* onBackgroundMessage: (Map<String, dynamic> message) async {
        // setState(() {
        //_messageText = "Push Messaging message: $message";
        //});
        print("onBackgroundMessage: $message");
        if (message.containsKey('data')) {
          // Handle data message
          final dynamic data = message['data'];
        }

        if (message.containsKey('notification')) {
          // Handle notification message
          final dynamic notification = message['notification'];
        }
      },*/
        // onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler1 ,
        onBackgroundMessage: HelperClass.myBackgroundMessageHandler);
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String tokenGcm) {
      assert(tokenGcm != null);
      setState(() {
        this.gcmToken = tokenGcm;
        _homeScreenText = "Push Messaging gcm: $tokenGcm";
      });

      print(_homeScreenText);
    });

    _children = [
      BerandaPage(dataP: widget.dataP),
      Orders(dataP: widget.dataP),
      Inboxs(dataP: widget.dataP),
      Accounts(dataP: widget.dataP),
      // BerandaPage(data_p: widget.data_p),
    ];
    _setToken();
    // getCurrentUser();
    // _pageController = PageController();
    // getDataBadge();
    // getFirestoreBadge();

    super.initState();
  }

  @override
  void dispose() {
    //_pageController.dispose();
    super.dispose();
  }

  void _setToken() async {
    print("gcm di landing ${this.gcmToken}");
    var localStorage = await SharedPreferences.getInstance();
    await localStorage.setString('gcm', this.gcmToken);
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  //persedian notifikasi untuk aplikasi sedang jalan
  static showNotification(Map<String, dynamic> message) async {
    /* AndroidIntent intent = new AndroidIntent(
      action: 'action_view',
      data: 'https://play.google.com/store/apps/details?'
          'id=com.pribumisoftware.gojek',
      arguments: {'authAccount': "currentUserEmail"},
    );
    await intent.launch();*/

    // await platform1.invokeMethod('CloseSecondActivity');

    var android = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, message['data']['body'], message['data']['title'], platform,
        payload: message['data']['message']);
  }

  //jika notofikasi di atas di klik maka akan membuka ini
  Future onSelectNotification(String payload) {
    print("payload : $payload");
  }

  Widget getPage(int index) {
    print(index);
    if (index == 0) {
      return BerandaPage(dataP: widget.dataP);
    }
    if (index == 1) {
      return Orders(dataP: widget.dataP);
    }
    if (index == 2) {
      return Inboxs(dataP: widget.dataP);
    }
    if (index == 3) {
      return Accounts(dataP: widget.dataP);
    }
    // A fallback, in this case just PageOne
    return BerandaPage(dataP: widget.dataP);
  }

  Future<void> _startActivity() async {
    try {
      final String result = await platform.invokeMethod('StartSecondActivity');
      debugPrint('Result: $result ');
    } on PlatformException catch (e) {
      debugPrint("Error: '${e.message}'.");
    }
  }

  void getDataBadge() async {
    var localStorage = await SharedPreferences.getInstance();

    if (widget.dataP['aktivasi'] == '1') {
      badGas_3 = false;
    } else {
      badGas_3 = true;
    }

    if (localStorage.getString('ada_inbox').toString() == '1') {
      badGas_2 = true;
    } else {
      badGas_2 = false;
    }

    if (localStorage.getString('ada_aktivitas').toString() == '' ||
        localStorage.getString('ada_aktivitas').toString() == null ||
        localStorage.getString('ada_aktivitas').toString() == 'null' ||
        localStorage.getString('ada_aktivitas').toString() == '0') {
      badGas_1 = false;
    } else {
      badGas_1 = true;
    }
    // print(localStorage.getString('ada_aktivitas').toString());
  }

  void setDataBadge(int _index) async {
    var localStorage = await SharedPreferences.getInstance();
    if (_index == 2) {
      await localStorage.setString('ada_inbox', '');
      await localStorage.setString(
          'time_inbox', DateTime.now().millisecondsSinceEpoch.toString());

      ///print( DateTime.now());
      setState(() {
        badGas_2 = false;
      });
    }
  }

  void _tentukanPesanBaru(int _timeDb) async {
    var localStorage = await SharedPreferences.getInstance();
    var timeTerakhirBuka = DateTime.now().millisecondsSinceEpoch.toInt();
    if (localStorage.getString('time_inbox').toString() == null ||
        localStorage.getString('time_inbox').toString() == 'null') {
    } else {
      timeTerakhirBuka =
          int.parse(localStorage.getString('time_inbox').toString());
    }
    timeTerakhirBuka = timeTerakhirBuka * 1000;
    //print('time db   : $_time_db');
    //print('time buka : $time_terakhir_buka');
    if (_timeDb > timeTerakhirBuka) {
      await localStorage.setString('ada_inbox', '1');
      setState(() {
        badGas_2 = true;
      });
    }
  }

  void getFirestoreBadge() async {
    /* await Firestore.instance.collection("ada_inbox")
     .document("inbox_saja")
     .get().then((value){
      print(value.data);
    });*/
    ///flutter_inbox/cek_customer
    await Firestore.instance
        .collection('flutter_inbox')
        .document('cek_customer')
        //.where('ada', isEqualTo: true)
        .snapshots()
        .listen((result) {
      if (result.exists) {
        int timeDb =
            result.data['datetime'].toDate().microsecondsSinceEpoch.toInt();
        _tentukanPesanBaru(timeDb);
      }

      /* result.documentChanges.forEach((res) { 
            if (res.type == DocumentChangeType.added) {
              int time_db=res.document.data['datetime'].toDate().microsecondsSinceEpoch.toInt();
                 _tentukanPesanBaru(time_db) ;
            } else if (res.type == DocumentChangeType.modified) { 
               int time_db=res.document.data['datetime'].toDate().microsecondsSinceEpoch.toInt();
                 _tentukanPesanBaru(time_db) ; 
          
            } else if (res.type == DocumentChangeType.removed) {
              print('removed');
              print(res.document.data); 
            } 
          });*/
    });
  }

  void _onItemTapped(int index) {
    print("onTap $index");
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
        setDataBadge(index);
      });
    }
  }

  ///metode 2
  @override
  Widget build(BuildContext context) {
    print("build landing page");
    return Scaffold(
      body: _children[_currentIndex],
      // body: PageStorage(
      //   child: _children.elementAt(_currentIndex),
      //   bucket: bucket,
      // ),
      //body: _children.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        fixedColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child:
                    Image.asset('assets/icons/tabbawah/home.png', scale: 2.5),
              ),
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Image.asset('assets/icons/tabbawah/home-non.png',
                    scale: 2.5),
              ),
              title: Text('Beranda')),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: badGas_1
                    ? Badge(
                        badgeContent: Text(
                          ' ',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Icon(
                          Icons.receipt,
                          color: Colors.green,
                          size: 25,
                        ),
                      )
                    : Icon(
                        Icons.receipt,
                        color: Colors.green,
                        size: 25,
                      ),
              ),
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: badGas_1
                    ? Badge(
                        badgeContent: Text(
                          ' ',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Icon(
                          Icons.receipt,
                          color: Colors.grey[400],
                          size: 25,
                        ),
                      )
                    : Icon(
                        Icons.receipt,
                        color: Colors.grey[400],
                        size: 25,
                      ),
              ),
              title: Text('Pesanan')),
          /* BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Icon( Icons.account_balance_wallet,  color: Colors.green, size: 25, ),
                ),
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Icon( Icons.account_balance_wallet,  color: Colors.grey[400], size: 25, ),
                ),
                title: Text('Pembayaran')),*/
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: badGas_2
                    ? Badge(
                        badgeContent: Text(
                          ' ',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Image.asset(
                            'assets/icons/tabbawah/account-non.png',
                            scale: 2.5),
                      )
                    : Image.asset('assets/icons/tabbawah/inbox.png',
                        scale: 2.5),
              ),
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: badGas_2
                    ? Badge(
                        badgeContent: Text(
                          ' ',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Image.asset(
                            'assets/icons/tabbawah/account-non.png',
                            scale: 2.5),
                      )
                    : Image.asset('assets/icons/tabbawah/inbox-non.png',
                        scale: 2.5),
              ),
              title: Text('Inbox')),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: badGas_3
                    ? Badge(
                        badgeContent: Text(
                          ' ',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Image.asset('assets/icons/tabbawah/account.png',
                            scale: 2.5),
                      )
                    : Image.asset('assets/icons/tabbawah/account.png',
                        scale: 2.5),
              ),
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: badGas_3
                    ? Badge(
                        badgeContent: Text(
                          ' ',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Image.asset(
                            'assets/icons/tabbawah/account-non.png',
                            scale: 2.5),
                      )
                    : Image.asset('assets/icons/tabbawah/account-non.png',
                        scale: 2.5),
              ),
              title: Text(
                'Akun',
              ))
        ],
      ),
    );
  }

  /* metode 1
  @override
  Widget build(BuildContext context) {   
   // FlutterStatusbarcolor.setStatusBarColor( Colors.white,); 
    return   Scaffold(  
       //appBar: AppBar( 
       //      backgroundColor: Colors.white,  elevation: 1,
      //       brightness : Brightness.light,
        //  title: Text('Profil Saya'), 
     // ),
      body: getPage(_selectedIndex),
       //body:  _container[_selectedIndex]
     //_container[_bottomNavCurrentIndex],
      bottomNavigationBar: _buildBottomNavigation()
    );
  }
 
  ///metode 1 
  Widget _buildBottomNavigation(){
     return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        unselectedFontSize: 10,
        selectedFontSize:11 ,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex, 
        onTap: (index) {
          setState(() { 
              
              _selectedIndex = index;
              setDataBadge(index); 

          //using this page controller you can make beautiful animation effects
         /* _pageController.animateToPage(index,
              duration: Duration(milliseconds: 52000), curve: Curves.easeOut);
           */
           // _bottomNavCurrentIndex = index;

          });
        }, 
       // currentIndex: _bottomNavCurrentIndex,
        items: 
          [
            BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Image.asset('assets/icons/tabbawah/home.png', scale: 2.5),
                ),
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Image.asset('assets/icons/tabbawah/home-non.png', scale: 2.5),
                ),
                title: Text('Beranda')),
             BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: bad_gas_1 ? Badge( 
                      badgeContent: Text(' ',style: TextStyle(color: Colors.white),), 
                      child: Icon( Icons.receipt,  color: Colors.green,size: 25,  ),
                  ) :Icon( Icons.receipt,  color: Colors.green,size: 25,  ),
                ),
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: bad_gas_1 ? Badge( 
                      badgeContent: Text(' ',style: TextStyle(color: Colors.white),), 
                      child: Icon( Icons.receipt,  color: Colors.grey[400],size: 25,  ),
                  ) :Icon( Icons.receipt,  color: Colors.grey[400], size: 25, ),
                ),
                title: Text('Pesanan')), 
           /* BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Icon( Icons.account_balance_wallet,  color: Colors.green, size: 25, ),
                ),
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Icon( Icons.account_balance_wallet,  color: Colors.grey[400], size: 25, ),
                ),
                title: Text('Pembayaran')),*/
            BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: bad_gas_2 ? Badge( 
                      badgeContent: Text(' ',style: TextStyle(color: Colors.white),), 
                      child: Image.asset('assets/icons/tabbawah/account-non.png', scale: 2.5),
                  ) :Image.asset('assets/icons/tabbawah/inbox.png', scale: 2.5),
                ),
                icon: Padding( 
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: bad_gas_2 ? Badge( 
                      badgeContent: Text(' ',style: TextStyle(color: Colors.white),), 
                      child: Image.asset('assets/icons/tabbawah/account-non.png', scale: 2.5),
                  ) :Image.asset('assets/icons/tabbawah/inbox-non.png', scale: 2.5),
                ),
                title: Text('Inbox')),
            BottomNavigationBarItem( 
                activeIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child:bad_gas_3 ? Badge( 
                      badgeContent: Text(' ',style: TextStyle(color: Colors.white),), 
                      child: Image.asset('assets/icons/tabbawah/account.png', scale: 2.5),
                  ) : Image.asset('assets/icons/tabbawah/account.png', scale: 2.5),
                ),
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: bad_gas_3 ? Badge( 
                      badgeContent: Text(' ',style: TextStyle(color: Colors.white),), 
                      child: Image.asset('assets/icons/tabbawah/account-non.png', scale: 2.5),
                  ) : Image.asset('assets/icons/tabbawah/account-non.png', scale: 2.5),
                ),
                title: Text('Akun',))   
        ],  
      );
  }*/

}
