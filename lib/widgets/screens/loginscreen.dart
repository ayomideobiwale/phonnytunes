import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonnytunes_application/controllers/user_controller.dart';
import 'package:phonnytunes_application/widgets/colors.dart';
import 'package:flutter/services.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: ColorConstants.primaryColor,
        ));
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            ColorConstants.primaryColor,
            ColorConstants.primaryColor,
          ], begin: Alignment.topLeft, end: Alignment.centerRight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.w800,
                        )),
                    SizedBox(height: 10),
                    Text("Make my deliveries",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _userController.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _textEmailInput(
                            text: 'Enter email username',
                            icon: Icons.mail,
                            controller: _userController.emailController),
                        SizedBox(height: 20),
                        _textInput(
                          controller: _userController.passwordController,
                          text: 'Password',
                          icon: Icons.lock,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                   
                                  },
                                  child: Text('Forgot your password?',
                                      style: TextStyle(
                                        color: ColorConstants.primaryColor,
                                        decoration: TextDecoration.underline,
                                      ))),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: ColorConstants.primaryColor,
                              shape: BoxShape.rectangle),
                          child: TextButton(
                              onPressed: () {
                                 _userController.loginuseraccount();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Dont have an account yet?'),
                              // SizedBox(
                              //   width: 4,
                              // ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/SignUp');
                                },
                                child: Text('Register',
                                    style: TextStyle(
                                        color: ColorConstants.primaryColor,
                                        fontStyle: FontStyle.italic)),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
      backgroundColor: Colors.white,
      // body:SafeArea(
      //   child: Container (
      //     padding:EdgeInsets.only(left: 16, right:16),
      //     child: Column
      //      (
      //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //        crossAxisAlignment: CrossAxisAlignment.start,
      //        children:<Widget> [
      //          Column(
      //          crossAxisAlignment:CrossAxisAlignment.start,
      //           children:<Widget> [
      //             SizedBox(height: 30,),
      //             Text('Welcome',
      //               style: TextStyle(
      //                 fontSize: 30,
      //                 fontWeight: FontWeight.bold,
      //                 fontStyle: FontStyle.italic
      //               )
      //             ),
      //             SizedBox(height: 10),
      //             Text('Sign In to continue...',
      //             style: TextStyle(
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold,
      //               color:Colors.grey
      //             ))
      //           ],
      //          ),
      //          Column(children: [
      //  TextField(

      //    decoration: InputDecoration(
      //      prefixIcon: Icon(Icons.mail,
      //      color: ColorConstants.primaryColor,),
      //     hintText: 'Email',
      //      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade200),
      //     enabledBorder: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(10),
      //       borderSide: BorderSide(
      //         color:ColorConstants.primaryColor
      //       )
      //     ),
      //     focusedBorder: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(10),
      //       borderSide: BorderSide(
      //         style: BorderStyle.solid,
      //         color: Colors.brown[200]
      //       )
      //     )
      //    ),
      //  ),
      //            SizedBox(height: 20),
      //           TextField(
      //              decoration: InputDecoration(
      //               hintText: 'Password',
      //               hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade200),
      //               enabledBorder: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(10),
      //                 borderSide: BorderSide(
      //                   color:ColorConstants.primaryColor
      //                 )
      //               ),
      //               focusedBorder: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(10),
      //                 borderSide: BorderSide(
      //                   color: Colors.brown[200]
      //                 )
      //               )
      //              ),
      //            )
      //          ],)
      //     ],
      //     ),

      //   ),
      // )
    );
  }

  bool obscure = true;
  Widget _textEmailInput({
    String text,
    IconData icon,
    TextEditingController controller,
  }) {
    return Container(
        child: TextFormField(
      validator: (value) {
        return value.isNotEmpty ? null : "Field Cannot be Empty";
      },
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(
          icon,
          color: ColorConstants.primaryColor,
        ),
        hintText: text,
        hintStyle: TextStyle(fontSize: 15, color: Colors.white),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white)),
        filled: true,
        fillColor: Colors.grey[100],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: ColorConstants.primaryColor,
          ),
        ),
      ),
    ));
  }

  Widget _textInput({
    String text,
    IconData icon,
    TextEditingController controller,
  }) {
    return Container(
        child: TextFormField(
      validator: (value) {
        return value.isNotEmpty ? null : "Field Cannot be Empty";
      },
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(
          icon,
          color: ColorConstants.primaryColor,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          },
          icon: Icon(!obscure ? Icons.visibility : Icons.visibility_off),
        ),
        hintText: text,
        hintStyle: TextStyle(fontSize: 15, color: Colors.white),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white)),
        filled: true,
        fillColor: Colors.grey[100],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: ColorConstants.primaryColor,
          ),
        ),
      ),
    ));
  }
}
