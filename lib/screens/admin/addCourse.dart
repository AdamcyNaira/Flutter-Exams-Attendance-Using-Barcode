import 'dart:async';

import 'package:attendance/screens/admin/successMsg.dart';
import 'package:attendance/util/constants.dart';
import 'package:attendance/widgets/users_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';


class AddCourse extends StatefulWidget {
  AddCourse({ this.selectedClass});
  final String selectedClass;

  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {

  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;

  TextEditingController courseController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();


  String classs;
  String courseName;
  String courseCode;
  var result;


   _showSuccessSnackBar() {
    final snackbar = new SnackBar(
      content: new Text('Course added sucessfuly',
          style: TextStyle(fontSize: 16.0, color: Colors.greenAccent)),
      onVisible: () {
        Timer(Duration(seconds: 3), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SuccessMsgCourse()));
        });
      },
      backgroundColor: Colors.black87,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }


  saveCourseData() async{
    if (formKey.currentState.validate()) {
      result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
           //_showDialog();
            formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      isLoading
          ? _showDialog()
          : Navigator.of(context, rootNavigator: true).pop('dialog');
      Timer(Duration(seconds: 3), () {});
          saveCourse();

        }else{
          _showerr();
                  }
      
    }
  }



      saveCourse() async {
          final response =
            await http.post('https://teamcoded.com.ng/attendance.php', body: {
            "request": "ADD COURSE",
            "course": courseName,
            "code": courseCode,
            "class": widget.selectedClass,  
      });

   
      setState(() {
        isLoading = false;
      });

      !isLoading
          ? Navigator.of(context, rootNavigator: true).pop('dialog')
          : _showDialog();
      _showSuccessSnackBar();
      clearForm();
    }

    clearForm(){
      courseController.clear();
      codeController.clear();
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new IconButton(
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
                icon: Icon(Icons.cancel, size: 40.0,),
                color: Constants.kPrimaryColor.withOpacity(0.5),
                iconSize: 10,
              ),
              SizedBox(
                width: 25.0,
              ),
              Flexible(child: new Text("No internet connection", style: TextStyle(fontSize: 14),)),
            ],
          ),
        );
      },
    );
  }





  @override
  void initState() {
    loadData ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: exAppBar(title: "", context: context),
      body: Container(
        color: Constants.kPrimaryColor.withOpacity(0.03),
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width, 
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Add Course',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Quando',
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 40.0,),
              Form(
                key: formKey,
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                        height: 10,
                      ),
                       Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                          child: Text(
                            "Course Title ",
                            style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: TextFormField(
                          controller: courseController,
                          onSaved: (val) => courseName = val,
                          validator: (val) => val.length == 0 ? 'Enter course name' : null,
                          style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'Raleway',),
                          decoration: InputDecoration(
                            hintText: 'Introduction to computer',
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
                        height: 20.0,
                      ),
                       Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                          child: Text(
                            "Course Code ",
                            style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: TextFormField(
                          controller: codeController,
                          onSaved: (val) => courseCode = val,
                          validator: (val) => val.length == 0 ? 'Enter course code' : null,
                          style: TextStyle(fontSize: 12, color: Colors.black,),
                          decoration: InputDecoration(
                            hintText: 'COM-111 ',
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
                      // SizedBox(
                      //   height: 20.0,
                      // ),
                      //  Padding(
                      //     padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                      //     child: Text(
                      //       "Lecturer Name ",
                      //       style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                      //     ),
                      //   ),
                      //   SizedBox(
                      //     height: 10.0,
                      //   ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                      //   child: TextFormField(
                      //     controller: lectureController,
                      //     onSaved: (val) => lecturer = val,
                      //     validator: (val) => val.length == 0 ? 'Enter lecturer name' : null,
                      //     style: TextStyle(fontSize: 12, color: Colors.black,),
                      //     decoration: InputDecoration(
                      //       hintText: 'Mr. Adamcy Naira',
                      //       contentPadding: const EdgeInsets.all(15.0),
                      //       filled: true,
                      //       focusedBorder: OutlineInputBorder(
                      //         borderSide: BorderSide.none,
                      //       ),
                      //       enabledBorder: OutlineInputBorder(
                      //         borderSide: BorderSide.none,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    //     SizedBox(
                    //     height: 10.0,
                    //   ),
                    //    Padding(
                    //       padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                    //       child: Text(
                    //         "Class Name ",
                    //         style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 10.0,
                    //     ),
                    //  Padding(
                    //    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    //    child: Container(
                    //               padding:
                    //                   EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    //               decoration: BoxDecoration(
                    //                 color: Colors.black12,
                    //                 borderRadius: BorderRadius.circular(3),
                    //               ),
                    //               child: DropdownButtonFormField(
                    //                 onTap: (){
                    //                   setState(() {
                    //                     // _enable = false;
                    //                   });
                    //                 },
                    //                // dropdownColor: Colors.red,
                    //                 decoration: InputDecoration(
                    //                  border: InputBorder.none, 
                    //                 ),
                    //                 items: classItems,
                    //                 value: selectedClass,
                    //                 validator: (val) =>
                    //                     val.length == 0 ? ' Select Class' : null,
                    //                 onSaved: (val) => classs = val,
                    //                 onChanged: (value) => selectedClass,
                    //                 hint: Text(
                    //                   "ND-I",
                    //                   style: formTextStyle(),
                    //                 ),
                    //               ),
                    //             ),
                    //  ),
                    //     SizedBox(
                    //     height: 10.0,
                    //   ),
                    //    Padding(
                    //       padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                    //       child: Text(
                    //         "Select Semester ",
                    //         style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 10.0,
                    //     ),
                    //    Padding(
                    //      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    //      child: Container(
                    //               padding:
                    //                   EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    //               decoration: BoxDecoration(
                    //                 color: Colors.black12,
                    //                 borderRadius: BorderRadius.circular(3),
                    //               ),
                    //               child: DropdownButtonFormField(
                    //                 onTap: (){
                    //                   setState(() {
                    //                     // _enable = false;
                    //                   });
                    //                 },
                    //                 decoration: InputDecoration(
                    //                  border: InputBorder.none, 
                    //                 ),
                    //                 items: semesterItems,
                    //                 value: selectedSemester,
                    //                 validator: (val) =>
                    //                     val.length == 0 ? ' Select Semester' : null,
                    //                 onSaved: (val) => semester = val,
                    //                 onChanged: (value) => selectedSemester,
                    //                 hint: Text(
                    //                   "First Semester",
                    //                   style: formTextStyle(),
                    //                 ),
                    //               ),
                    //             ),
                    //    ),
                      SizedBox(
                        height: 40,
                      ),
                       Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: FlatButton(
                          color: Constants.kPrimaryColor.withOpacity(0.6),
                          child: Text(
                            'ADD COURSE',
                            style: TextStyle(fontSize: 14),
                          ),
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.all(18),
                          textColor: Colors.white,
                          onPressed: () {
                             saveCourseData();
                          // Navigator.push((context), MaterialPageRoute(builder: (context) => SuccessMsgCourse()));
                          },
                        ),
                      ),
                  ],
                ),
              ),
           ], 
          ),
        ),
      ),
    );
  }
}

