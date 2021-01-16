import 'package:flutter/material.dart';
import 'package:flutter_app/data_provider.dart';
import 'package:octo_image/octo_image.dart';

class ImagesPage extends StatefulWidget {
  final Widget Function(ImageModel) placeholderBuilder;

  ImagesPage({
    Key key,
    this.placeholderBuilder,
  }) : super(key: key);

  @override
  _ImagesPageState createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  bool _isLoading = true;
  bool _hasError = false;
  List<ImageModel> _images = [];
  Map<ImageModel, Widget> placeholders = Map();

  final _duration = Duration(milliseconds: 500);

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Widget _getPlaceholder(ImageModel item) {
    if (!placeholders.containsKey(item)) {
      placeholders.putIfAbsent(item, () => widget.placeholderBuilder(item));
    }
    return placeholders[item];
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
        title: Text('Images'),
      ),
      body: _isLoading || _hasError
          ? Center(
              child: _hasError ? Text('Something went wrong') : CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final item = _images[index];

                return ClipRRect(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: OctoImage(
                        image: NetworkImage(item.url),
                        fit: BoxFit.cover,
                        fadeInDuration: _duration,
                        fadeOutDuration: _duration,
                        progressIndicatorBuilder: (context, image) => Stack(
                          children: [
                            Positioned.fill(
                              child: _getPlaceholder(item),
                            ),
                            if (image != null)
                              Center(
                                child: CircularProgressIndicator(
                                  value: image.cumulativeBytesLoaded / image.expectedTotalBytes,
                                  strokeWidth: 1,
                                  backgroundColor: Colors.white.withOpacity(0.5),
                                  valueColor:
                                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                                ),
                              ),
                          ],
                        ),
                        // placeholderBuilder: (context) => widget.placeholderBuilder(item),
                        errorBuilder: OctoError.placeholderWithErrorIcon(
                            (context) => widget.placeholderBuilder(item)),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
