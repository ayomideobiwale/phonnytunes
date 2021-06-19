import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonnytunes_application/controllers/user_controller.dart';

import '../colors.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  UserController _userController = Get.find();

  String error = ('Password lenght must be greater than 6');
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(hintText: 'change password'),
          controller: _userController.passwordController,
          validator: (value) {
            if (value.length <= 8) {
              return error;
            }
            else
             return value.isNotEmpty ? null : "Field Cannot be Empty";
          },
        ),
          TextFormField(
            key: _userController.formKey2,
          decoration: InputDecoration(hintText: 'confirm password'),
          controller: _userController.confirmPasswordController,
          validator: (value) {
            if (value.length <= 8) {
              return error;
            }
            else
             return value.isNotEmpty ? null : "Field Cannot be Empty";
          },
        ),
       
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
                            'Update Password',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
      ],
    ));
  }
}
