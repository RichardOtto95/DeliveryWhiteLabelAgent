import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  List<dynamic> images;
  String title;
  String description;
  String category;
  String option;
  String type;
  String id;
  String status;
  bool isNew;
  bool paused;
  bool highlighted;
  int ratings;
  int likeCount;
  double price;
  double? oldPrice;
  Timestamp? createdAt;

  AnnouncementModel({
    this.oldPrice = 0,
    this.ratings = 0,
    this.likeCount = 0,
    this.status = '',
    this.highlighted = false,
    this.createdAt,
    this.paused = false,
    this.id = '',
    this.option = '',
    this.images = const [],
    this.title = '',
    this.description = '',
    this.category = '',
    this.type = '',
    this.isNew = true,
    this.price = 0,
  });

  factory AnnouncementModel.fromDoc(DocumentSnapshot ds) => AnnouncementModel(
        category: ds['category'],
        description: ds['description'],
        images: ds['images'],
        isNew: ds['new'],
        price: ds['price'],
        title: ds['title'],
        type: ds['type'],
        option: ds['option'],
        id: ds['id'],
        paused: ds['paused'],
        createdAt: ds['created_at'],
        highlighted: ds['highlighted'],
        status: ds['status'],
        ratings: ds['ratings'],
        likeCount: ds['likeCount'],
        oldPrice: ds['old_price'].toDouble(),
      );

  Map<String, dynamic> toJson(AnnouncementModel announcement) => {
        'category': announcement.category,
        'description': announcement.description,
        'images': announcement.images,
        'new': announcement.isNew,
        'price': announcement.price,
        'title': announcement.title,
        'type': announcement.type,
        'option': announcement.option,
        'id': announcement.id,
        'created_at': announcement.createdAt,
        'paused': announcement.paused,
        'highlighted': announcement.highlighted,
        'status': announcement.status,
        'ratings': announcement.ratings,
        'likeCount': announcement.likeCount,
        'old_price': announcement.oldPrice,
      };
}
