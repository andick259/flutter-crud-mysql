import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nearco/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  String username = '';
  String email = '';
  String id_user = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
      id_user = prefs.getString('id_user') ?? '';

      _username.text = prefs.getString('username') ?? '';
      _email.text = prefs.getString('email') ?? '';
      _password.text = prefs.getString('password') ?? '';
    });
  }

  Future<void> _logoutProfile(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear(); // Clear all saved user data

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }

  Future<void> _setupUser(BuildContext context) async {
    final String apiUrl = 'https://mitrasite.com/nearco/api/edit-profil.php';

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'username': _username.text,
        'email': _email.text,
        'password': _password.text,
      });

      final result = json.decode(response.body);
      if (result['status'] == 200) {
        // Navigator.of(context).pushReplacement(
        // MaterialPageRoute(
        // builder: (context) => Login(),
        // ),
        // );
        _logoutProfile(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${result['message']}')),
        );

        //_saveUserDataLocally();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed : ${result['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the server')),
      );
    }
  }

  void _saveUserDataLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _username.text);
    prefs.setString('email', _email.text);
    prefs.setString('password', _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(48, 56, 65, 1),
                      Color.fromRGBO(48, 56, 65, 1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.02,
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'My Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Color.fromRGBO(48, 56, 65, 1),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _username,
                            readOnly: true,
                            decoration: InputDecoration(
                              suffixIcon:
                                  Icon(Icons.person, color: Colors.grey),
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(48, 56, 65, 1),
                              ),
                              enabled: false,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _email,
                            readOnly: true,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.email, color: Colors.grey),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(48, 56, 65, 1),
                              ),
                              enabled: false,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.visibility_off,
                                  color: Colors.grey),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(48, 56, 65, 1),
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: () {
                              _setupUser(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromRGBO(48, 56, 65, 1),
                                    Color.fromRGBO(63, 71, 80, 1),
                                  ],
                                ),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                    minHeight: 55, minWidth: 300),
                                alignment: Alignment.center,
                                child: Text(
                                  'UPDATE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
