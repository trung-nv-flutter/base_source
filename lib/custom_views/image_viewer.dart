import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../extensions/string_extensions.dart';

// ignore: must_be_immutable
class ImageViewer extends StatefulWidget {
  _ImageViewerState _currentState;
  File file;
  String url;
  double height = 100;
  Color backgroundColor = Colors.white;

  ImageViewer(
      {this.file,
      this.url,
      this.backgroundColor = Colors.white,
      this.height = 100});

  setFile(File _file) {
    this.url = null;
    this.file = _file;
    reload();
  }

  setURL(String _url) {
    this.url = _url;
    this.file = null;
    reload();
  }

  @override
  State<StatefulWidget> createState() {
    _currentState = _ImageViewerState();
    return _currentState;
  }

  reload() {
    _currentState?.reload();
  }
}

class _ImageViewerState extends State<ImageViewer> {
  Widget _image;
  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void dispose() {
    _image = null;
    // _image?.dispose();
    super.dispose();
  }

  reload() async {
    if (widget.url.isValid()) {
      setState(() {
        try {
          _image = CachedNetworkImage(
            imageUrl: widget.url,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Container(),
          );

          // _image = Image.network(
          //   widget.url,
          //   loadingBuilder: (context, child, loadingProgress) {
          //     return loadingProgress == null
          //         ? child
          //         : CircularProgressIndicator();
          //   },
          // );
        } catch (e) {}
      });
      // カ
    } else if (widget.file != null) {
      final exist = await widget.file.exists();
      if (exist) {
        setState(() {
          _image = Image.file(widget.file);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) return Container();
    return Container(
      color: widget.backgroundColor,
      width: double.infinity,
      height: widget.height,
      padding: EdgeInsets.all(10),
      child: Center(
        child: _image,
      ),
    );
  }
}
