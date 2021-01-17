import 'package:flutter/material.dart';
import 'package:flutter_app/app_network_image.dart';
import 'package:flutter_app/images_page.dart';

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

  void _openImagesPage(BuildContext context, PlaceholderType placeholderType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImagesPage(
          placeholderType: placeholderType,
          title: placeholderType.toString(),
        ),
      ),
    );
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
                _openImagesPage(context, PlaceholderType.nothing);
              },
            ),
            ListTile(
              title: Text('Asset placeholder'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _openImagesPage(context, PlaceholderType.assetPlaceholder);
              },
            ),
            ListTile(
              title: Text('Solid color'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _openImagesPage(context, PlaceholderType.solidColor);
              },
            ),
            ListTile(
              title: Text('Blurhash'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _openImagesPage(context, PlaceholderType.blurhash);
              },
            ),
            ListTile(
              title: Text('Blurred thumbnail'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _openImagesPage(context, PlaceholderType.blurredThumbnail);
              },
            ),
          ],
        ),
      ),
    );
  }
}
