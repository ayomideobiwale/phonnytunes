import 'package:flutter/material.dart';
import 'package:phonnytunes_application/widgets/colors.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
        _editprofile(text: 'Update Username')
        ],
      )
    );
  }
}

Widget _editprofile({String text}) {
  return Container(
    child: TextFormField(
      decoration: InputDecoration(
        border:OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: ColorConstants.primaryColor)),
        hintText: text,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          
        )
      ),
    ),
  );
}
