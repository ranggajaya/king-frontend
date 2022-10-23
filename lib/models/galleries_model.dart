class GalleriesModel {
  int id;
  String url;

  GalleriesModel({
    this.id,
    this.url,
  });

  GalleriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}
