import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/data_provider.dart';
import 'package:flutter_app/images_page.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  void _openImagesPage(BuildContext context, Widget Function(ImageModel) placeholderBuilder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImagesPage(
          placeholderBuilder: placeholderBuilder,
        ),
      ),
    );
  }

  Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor; // FF as the opacity value if you don't add it.
    }
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image loading techniques'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text('No placeholder'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _openImagesPage(context, (_) => SizedBox());
              },
            ),
            ListTile(
              title: Text('Asset placeholder'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _openImagesPage(
                  context,
                  (_) => Image.asset(
                    'assets/placeholder.png',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Solid color'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _openImagesPage(
                  context,
                  (image) => Container(
                    color: colorFromHex(image.color),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Blurhash'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _openImagesPage(
                  context,
                  (image) => Image(
                    image: BlurHashImage(image.blurhash),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Blurred thumbnail'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _openImagesPage(
                  context,
                  (image) => ClipRect(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Image.memory(
                        base64Decode(image.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
