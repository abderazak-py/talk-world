import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  final bool isSender;
  final String imagePath;
  const ImageMessage({Key? key, required this.isSender, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: (){
          showDialog(
              context: context,
              builder: (context) =>
              Image.network(imagePath),
          );
        },
        child: Padding(
        padding: EdgeInsets.only(left: isSender?170:17,right: isSender?17:170,bottom: 5,top: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(imagePath,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
    ),
      );

  }
}
