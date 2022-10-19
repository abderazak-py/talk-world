import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String path;
  final Widget roomRoute;
  const RoomCard({Key? key, required this.path, required this.roomRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => roomRoute));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            path,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
