import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test_mkm/config/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//import 'newscreen.dart';
class PushMessagingExample extends StatefulWidget {
  @override
  _PushMessagingExampleState createState() => _PushMessagingExampleState();
}

enum LoginStatus { notSignIn, signIn }
String _homeScreenText = "Waiting for token...";
String siap = "siap...";

class _PushMessagingExampleState extends State<PushMessagingExample>{
   final scaffoldState = GlobalKey<ScaffoldState>();
   LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;
  
  //final List<Message> messages = [];

  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

 static String dataName = '';
  static String dataAge = '';

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String namaAPI = data['nama'];
    String id = data['id'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, namaAPI, id);
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }


  savePref(int value, String username, String nama, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("username", username);
      preferences.setString("id", id);
      //preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      print("val init === $value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      //preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
      preferences.setInt("value", 2);
    });
  }

  

  @override
  void initState() { 
    getPref();
   
     super.initState();
  }


  @override
  Widget build(BuildContext context) {
     switch (_loginStatus) {
      case LoginStatus.notSignIn: 
      print("staus login $_loginStatus");
      return Scaffold(
       key: scaffoldState,
      appBar: AppBar(
        title: const Text('Push Messaging Demo'),
      ),
     
      body: Material(
        child: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Please insert username";
                    }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(
                    labelText: "Username",
                  ),
                ),
                TextFormField(
                  obscureText: _secureText,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: showHide,
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    check();
                  },
                  child: Text("Login"),
                ),
                InkWell(
                  onTap: () {
                    //Navigator.of(context).push(
                        //MaterialPageRoute(builder: (context) => Register())
                       // );
                  },
                  child: Text(
                    "Create a new account, in here",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        // Column(
        //   children: <Widget>[
        //     Center(
        //       child: Text(_homeScreenText),
        //     ),
        //     Center(
        //       child: Text(siap),
        //     ),
        //     Divider(thickness: 1),
        //     Text(
        //       'DATA',
        //       style: TextStyle(fontWeight: FontWeight.bold),
        //     ),
        //     _buildWidgetTextDataFcm(),
        //   ],
        // ),
      ),
    );
    break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
     }
  }

  // Widget _buildWidgetTextDataFcm() {
  //   if (dataName == null || dataName.isEmpty || dataAge == null || dataAge.isEmpty) {
  //     return Text('Your data FCM is here');
  //   } else {
  //     return Text('Name: $dataName & Age: $dataAge');
  //   }
  // }

void getDataFcm(Map<String, dynamic> message) {
    String name = '';
    String age = '';
    if (Platform.isIOS) {
      name = message['name'];
      age = message['age'];
    } else if (Platform.isAndroid) {
      var data = message['data'];
      name = data['name'];
      age = data['age'];
    }
    if (name.isNotEmpty && age.isNotEmpty) {
      setState(() {
        dataName = name;
        dataAge = age;
      });
    }
    debugPrint('getDataFcm: name: $name & age: $age');
  }

}



class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", nama = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      nama = preferences.getString("nama");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.lock_open),
            )
          ],
          
        ),
        body: Material(
        child: Text("U're login!")
        ),
      ),
    );
  }
}
