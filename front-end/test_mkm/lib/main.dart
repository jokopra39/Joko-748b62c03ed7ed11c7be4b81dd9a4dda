import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_mkm/config/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum LoginStatus { notSignIn, signIn }
Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;
  String username, password;
  LoginStatus _loginStatus = LoginStatus.notSignIn;
   final scaffoldState = GlobalKey<ScaffoldState>();
  
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;
  
  //final List<Message> messages = [];

  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

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

  @override
  Widget build(BuildContext context) {
 
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

      ),
    );
    
  }
}
