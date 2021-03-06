import 'dart:async';
import 'dart:convert';
import 'package:attendance/screens/student/studentDashboard.dart';
import 'package:attendance/util/constants.dart';
import 'package:attendance/screens/admin/adminDashboard.dart';
import 'package:attendance/widgets/users_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoadingAdmin = false;
bool isLoading = false;
bool _passwordViewAdmin = true;
bool isLoggedIn ;
bool isLoggedInAdmin;

class StudentLogin extends StatefulWidget {
  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {

  
  
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController(); 
  String username; 
  String password;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final formKey = new GlobalKey<FormState>();

  _showIncorrectSnackBar() {
    final snackbar = new SnackBar(
      content: new Text(
        'Incorrect login details!',
        style: TextStyle(fontSize: 16.0, color: Colors.redAccent),
      ),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.black87,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _showSuccessSnackBar() {
    final snackbar = new SnackBar(
      content: new Text('Login Successful!',
          style: TextStyle(fontSize: 16.0, color: Colors.greenAccent)),
      onVisible: () {
        Timer(Duration(seconds: 3), () {
        Future.delayed(Duration.zero, () {
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNav()), (Route<dynamic> route) => false);
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminBottomNav()));
          });
        });
      },
      backgroundColor: Colors.black87,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }


  _studentLogin() async{

    if (formKey.currentState.validate()) {
    
       var result = await Connectivity().checkConnectivity();
 
  if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
    formKey.currentState.save(); 
     setState(() {
       isLoading = true;
    });
    isLoading
          ? _showDialog()
          : Navigator.of(context, rootNavigator: true).pop('dialog');
      Timer(Duration(seconds: 3), () {});
    _login(); 
    }else{ 

      _showerr();

    }
  }
  }


   _login() async {
  final response = await http.post("https://teamcoded.com.ng/attendance.php", body: {
    "request": "STUDENT LOGIN",
    "username": username,
    "password": password,
  });

  List datauser = json.decode(response.body);
  print(datauser);

  if(datauser.length==0){
    setState(() {
          isLoading = false;
        });
         !isLoading
          ? Navigator.of(context, rootNavigator: true).pop('dialog')
          : _showDialog();
        _showIncorrectSnackBar();

  }else{
 
       if (response.statusCode==200) {
         Constants.sharedPref = await SharedPreferences.getInstance();
          setState(() {
          Constants.sharedPref.setString("student", datauser[0]['student_id']) ;
          Constants.sharedPref.setString("student_name", datauser[0]['student_name']);
          Constants.sharedPref.setString("regno", datauser[0]['regno']);
          Constants.sharedPref.setBool("isLoggedInStudent", true);
          isLoading = false;
            });
          !isLoading
          ? Navigator.of(context, rootNavigator: true).pop('dialog')
          : _showDialog();
        _showSuccessSnackBar();
       }
  }

  return datauser;
}

@override
  void initState() {
    super.initState();
   getData();
   checkLoginState();
    
  }

    getData() {
      setState(() {
      isLoggedIn = Constants.sharedPref.getBool("isLoggedInStudent");
      });
  }

      checkLoginState()  { 
    if (isLoggedIn != null) {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
       Future.delayed(Duration.zero, () async{
           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNav()), (Route<dynamic> route) => false);
        // await  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminBottomNav()));
          });
    }else{

    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              new CircularProgressIndicator(),
              SizedBox(
                width: 25.0,
              ),
              new Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }

   void _showerr() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              new Icon(Icons.cancel, size: 30.0, color: Colors.deepOrange[200]),
              SizedBox(
                width: 20.0,
              ),
              new Text("No internet connection!"),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: loginAppBar(title: " ", context: context),
      body: Container(
        color: Constants.kPrimaryColor.withOpacity(0.01),
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          primary: false,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
                  SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Constants.kPrimaryColor.withOpacity(0.6),
                        fontFamily: 'Quando',
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 15.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                  'Secure login to student portal',
                  style: TextStyle(
                    color: Colors.black38,
                    fontFamily: 'raleway',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
              ),
                ),
                   SizedBox(
                      height: 50,
                    ),
                     Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Text(
                          "Username ",
                          style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: TextFormField(
                        controller: user,
                        onSaved: (val) => username = val,
                        validator: (val) => val.length == 0 ? 'Please enter your username' : null,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, size: 20.0,),
                          hintText: 'csc/16/0000',
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                     Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Text(
                          "Password ",
                          style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: TextFormField(
                        controller: pass,
                        onSaved: (val) => password = val,
                        validator: (val) => val.length == 0 ? 'Please enter your passward' : null,
                         obscureText: true,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, size: 20.0,),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye, size: 20.0,),
                              onPressed: () {
                               if(_passwordViewAdmin){
                                  setState(() {
                                  _passwordViewAdmin = false;
                                });
                                }else{
                                  setState(() {
                                  _passwordViewAdmin = true;
                                });
                                }
                              }),
                          hintText: '***********',
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                      SizedBox(height: 60.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: FlatButton(
                        color: Constants.kPrimaryColor.withOpacity(0.6),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 14),
                        ),
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(18),
                        textColor: Colors.white,
                        onPressed: () {
                          _studentLogin();
                         //Navigator.pushReplacement((context), MaterialPageRoute(builder: (context) => AdminBottomNav()));
                        },
                      ),
                    ),
                     SizedBox(
                    height: 20,
                  ),
                   Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                          //  Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => AdminForgottenPassword()));
                          },
                          child: Text(
                            'Forgotten your password? ',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color:  Constants.kPrimaryColor.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
             ], 
            ),
          ),
        ),
      ),
    );
  }
}



class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {


  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  String username; 
  String password;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final formKey = new GlobalKey<FormState>();

  _showIncorrectSnackBar() {
    final snackbar = new SnackBar(
      content: new Text(
        'Incorrect login details!',
        style: TextStyle(fontSize: 16.0, color: Colors.redAccent),
      ),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.black87,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _showSuccessSnackBar() {
    final snackbar = new SnackBar(
      content: new Text('Login Successful!',
          style: TextStyle(fontSize: 16.0, color: Colors.greenAccent)),
      onVisible: () {
        Timer(Duration(seconds: 3), () {
        Future.delayed(Duration.zero, () {
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AdminBottomNav()), (Route<dynamic> route) => false);
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminBottomNav()));
          });
        });
      },
      backgroundColor: Colors.black87,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }


  adminLogin() async{

    if (formKey.currentState.validate()) {
    
       var result = await Connectivity().checkConnectivity();
 
  if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
    formKey.currentState.save(); 
     setState(() {
       isLoadingAdmin = true;
    });
    isLoadingAdmin
          ? _showDialog()
          : Navigator.of(context, rootNavigator: true).pop('dialog');
      Timer(Duration(seconds: 3), () {});
    _login(); 
    }else{ 

      _showerr();

    }
  }
  }


   _login() async {
  final response = await http.post("https://teamcoded.com.ng/attendance.php", body: {
    "request": "ADMIN LOGIN",
    "username": username,
    "password": password,
  });

  List datauser = json.decode(response.body);
  print(datauser);

  if(datauser.length==0){
    setState(() {
          isLoadingAdmin = false;
        });
         !isLoadingAdmin
          ? Navigator.of(context, rootNavigator: true).pop('dialog')
          : _showDialog();
        _showIncorrectSnackBar();

  }else{
 
       if (response.statusCode==200) {
          setState(() {
          Constants.sharedPref.setString("user", datauser[0]['id']);
          Constants.sharedPref.setBool("isLoggedIn", true);
          isLoadingAdmin = false;
            });
          !isLoadingAdmin
          ? Navigator.of(context, rootNavigator: true).pop('dialog')
          : _showDialog();
        _showSuccessSnackBar();
       }
  }

  return datauser;
}

@override
  void initState() {
    super.initState();
  getData();
   checkLoginState();
    
  }

    getData() {
      setState(() {
      isLoggedInAdmin = Constants.sharedPref.getBool("isLoggedIn");
      });
  }

      checkLoginState()  { 
    if (isLoggedInAdmin != null) {
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
       Future.delayed(Duration.zero, () async{
           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AdminBottomNav()), (Route<dynamic> route) => false);
        // await  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminBottomNav()));
          });
    }else{

    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              new CircularProgressIndicator(),
              SizedBox(
                width: 25.0,
              ),
              new Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }

   void _showerr() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              new Icon(Icons.cancel, size: 30.0, color: Colors.deepOrange[200]),
              SizedBox(
                width: 20.0,
              ),
              new Text("No internet connection!"),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: loginAppBar(title: " ", context: context),
      body: Container(
        color: Constants.kPrimaryColor.withOpacity(0.01),
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          primary: false,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
                  SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Constants.kPrimaryColor.withOpacity(0.6),
                        fontFamily: 'Quando',
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 15.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                  'Secure login to attendance system',
                  style: TextStyle(
                    color: Colors.black38,
                    fontFamily: 'raleway',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
              ),
                ),
                   SizedBox(
                      height: 50,
                    ),
                     Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Text(
                          "Username ",
                          style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: TextFormField(
                        controller: user,
                        onSaved: (val) => username = val,
                        validator: (val) => val.length == 0 ? 'Please enter your username' : null,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, size: 20.0,),
                          hintText: 'AdamcyNaira',
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                     Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Text(
                          "Password ",
                          style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: TextFormField(
                        controller: pass,
                        onSaved: (val) => password = val,
                        validator: (val) => val.length == 0 ? 'Please enter your passward' : null,
                         obscureText: true,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, size: 20.0,),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye, size: 20.0,),
                              onPressed: () {
                               if(_passwordViewAdmin){
                                  setState(() {
                                  _passwordViewAdmin = false;
                                });
                                }else{
                                  setState(() {
                                  _passwordViewAdmin = true;
                                });
                                }
                              }),
                          hintText: '***********',
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                      SizedBox(height: 60.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: FlatButton(
                        color: Constants.kPrimaryColor.withOpacity(0.6),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 14),
                        ),
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(18),
                        textColor: Colors.white,
                        onPressed: () {
                           adminLogin();
                         //Navigator.pushReplacement((context), MaterialPageRoute(builder: (context) => BottomNav()));
                        },
                      ),
                    ),
                     SizedBox(
                    height: 20,
                  ),
                   Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                          //  Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => AdminForgottenPassword()));
                          },
                          child: Text(
                            'Forgotten your password? ',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color:  Constants.kPrimaryColor.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
             ], 
            ),
          ),
        ),
      ),
    );
  }
}