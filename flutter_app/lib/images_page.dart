import 'package:flutter/material.dart';
import 'package:flutter_app/app_network_image.dart';
import 'package:flutter_app/data_provider.dart';

class ImagesPage extends StatefulWidget {
  final PlaceholderType placeholderType;
  final String title;

  ImagesPage({
    Key key,
    this.placeholderType,
    this.title = 'Images',
  }) : super(key: key);

  @override
  _ImagesPageState createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  bool _isLoading = true;
  bool _hasError = false;
  List<ImageModel> _images = [];

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      _isLoading = true;
      _hasError = false;
      final images = await getImages();
      setState(() {
        _images = images;
      });
    } catch (e) {
      print(e);
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading || _hasError
          ? Center(
              child: _hasError ? Text('Something went wrong') : CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final item = _images[index];

                return AspectRatio(
                  aspectRatio: 1.85,
                  child: AppNetworkImage(
                    url: item.url,
                    placeholderType: widget.placeholderType,
                    blurhash: item.blurhash,
                    hexColor: item.color,
                    thumbnailData: item.thumbnail,
                  ),
                );
              },
            ),
    );
  }
}
