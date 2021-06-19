import 'package:flutter/material.dart';
import 'package:phonnytunes_application/widgets/colors.dart';
import 'package:flutter/services.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  double xOffset = 0;
  double yOffset = 0;
  double scalefactor = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: ColorConstants.primaryColor,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildTopView(),
          ],
        ));
  }
}

Widget _buildTopView() {
  return Positioned.fill(
    
   child:Container( decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(21),
                  bottomRight: Radius.circular(21)
                  )
                  )
                  ),
  );
}
