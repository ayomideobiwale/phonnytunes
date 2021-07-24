import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phonnytunes_application/controllers/user_controller.dart';
import 'package:phonnytunes_application/widgets/colors.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      height: 170,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 60),
                        child: Text('Sign Up...',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            )),
                      )),
                  SizedBox(height: 0),
                  Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: Form(
                        key: _userController.formKey2,
                        child: Column(
                          children: [
                            _textinput(
                                text: 'Username', icon: Icons.person),
                            SizedBox(height: 10),
                            _textinput(
                                controller: _userController.emailController,
                                text: 'Email',
                                input: TextInputType.emailAddress,
                                icon: Icons.mail),
                            SizedBox(height: 10),
                            _textpasskeyinput(
                                controller:
                                    _userController.passwordController,
                                text: 'Enter Password',
                                icon: Icons.lock),
                            SizedBox(height: 10),
                            _textpasskeyinput(
                                controller: _userController
                                    .confirmPasswordController,
                                text: 'Confirm Password',
                                icon: Icons.lock),
                            SizedBox(height: 10),
                            _textinput(
                                controller:
                                    _userController.phoneNoController,
                                text: 'Phone number',
                                icon: Icons.call,
                                input: TextInputType.phone),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: ColorConstants.primaryColor,
                        shape: BoxShape.rectangle),
                    child: TextButton(
                        onPressed: () {
                          if (_userController.passwordController.text
                                  .trim() ==
                              _userController.confirmPasswordController.text
                                  .trim()) {
                            _userController.validateAndSubmit2();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already a user',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/auth');
                            },
                            child: Text('Log In',
                                style: TextStyle(
                                    color: ColorConstants.primaryColor,
                                    fontStyle: FontStyle.italic)))
                      ],
                    ),
                  )
                ],
              )))),
    );
  }

  bool obscure = true;

  Widget _textinput(
      {String text,
      TextInputType input,
      icon,
      TextEditingController controller}) {
    return Container(
        child: TextFormField(
      validator: (value) {
        return value.isNotEmpty ? null : "Field Cannot be Empty";
      },
      controller: controller,
      keyboardType: input,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(
          icon,
          color: ColorConstants.primaryColor,
        ),
        hintText: text,
        hintStyle: TextStyle(fontSize: 15, color: Colors.black),
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

  Widget _textpasskeyinput(
      {String text, icon, TextEditingController controller}) {
    return Container(
        child: TextField(
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
          icon: Icon(!obscure ? Icons.visibility : Icons.visibility_off,
              color: ColorConstants.primaryColor),
        ),
        hintText: text,
        hintStyle: TextStyle(fontSize: 15, color: Colors.black),
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
