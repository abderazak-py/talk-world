import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  final bool isSender;
  final String imagePath;
  const ImageMessage(
      {Key? key, required this.isSender, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => InteractiveViewer(
            panEnabled: false,
            boundaryMargin: EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 6,
            child: CachedNetworkImage(
              imageUrl: imagePath,
              placeholder: (context, url) => Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: isSender ? 170 : 2,
            right: isSender ? 17 : 130,
            bottom: 5,
            top: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: imagePath,
            width: 240,
            fit: BoxFit.cover,
            placeholder: (context, url) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
