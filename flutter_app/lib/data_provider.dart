import 'package:flutter_app/http_client.dart';

class ImageModel {
  String url;
  int width;
  int height;
  String color;
  String thumbnail;
  String blurhash;

  ImageModel({
    this.url,
    this.width,
    this.height,
    this.color,
    this.thumbnail,
    this.blurhash,
  });

  ImageModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
    color = json['color'];
    thumbnail = json['thumbnail'];
    blurhash = json['blurhash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    data['color'] = this.color;
    data['thumbnail'] = this.thumbnail;
    data['blurhash'] = this.blurhash;
    return data;
  }
}

Future<List<ImageModel>> getImages() async {
  final _http = getHttpClient();

  final response = await _http.get('data');

  return (response.data as List).map((e) => ImageModel.fromJson(e)).toList();
}
