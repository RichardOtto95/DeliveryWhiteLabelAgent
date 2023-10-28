import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String? avatar;
  String? fullname;
  String? username;
  Timestamp? birthday;
  String? cpf;
  String? rg;
  String? gender;
  String? id;
  String? phone;
  String? status;
  String? country;
  String? mainAddress;
  String? customerId;
  Timestamp? createdAt;
  int? newNotifications;
  List? tokenId;
  bool? connected;
  bool? notificationEnabled;
  String? email;
  String? userPromotionalCode;
  bool? wasInvited;

  Customer({
    this.createdAt,
    this.avatar,
    this.fullname,
    this.username,
    this.birthday,
    this.cpf,
    this.rg,
    this.gender,
    this.id,
    this.phone,
    this.status,
    this.newNotifications,
    this.tokenId,
    this.connected,
    this.notificationEnabled,
    this.country,
    this.mainAddress,
    this.email,
    this.userPromotionalCode,
    this.wasInvited,
    this.customerId,
  });

  factory Customer.fromDoc(DocumentSnapshot doc) {
    return Customer(
      createdAt: doc['created_at'],
      avatar: doc['avatar'],
      fullname: doc['fullname'],
      username: doc['username'],
      birthday: doc['birthday'],
      cpf: doc['cpf'],
      rg: doc['rg'],
      gender: doc['gender'],
      id: doc['id'],
      phone: doc['phone'],
      status: doc['status'],
      newNotifications: doc['new_notifications'],
      tokenId: doc['token_id'],
      connected: doc['connected'],
      country: doc['country'],
      notificationEnabled: doc['notification_enabled'],
      mainAddress: doc['main_address'],
      email: doc['email'],
      userPromotionalCode: doc['user_promotional_code'],
      wasInvited: doc['was_invited'],
      customerId: doc['customer_id'],
    );
  }

  Map<String, dynamic> toJson(Customer model) => {
        'created_at': model.createdAt,
        'avatar': model.avatar,
        'fullname': model.fullname,
        'username': model.username,
        'birthday': model.birthday,
        'cpf': model.cpf,
        'rg': model.rg,
        'gender': model.gender,
        'id': model.id,
        'phone': model.phone,
        'status': model.status,
        'new_notifications': model.newNotifications,
        'token_id': model.tokenId,
        'connected': model.connected,
        'country': model.country,
        'notification_enabled': model.notificationEnabled,
        'main_address': model.mainAddress,
        'email': model.email,
        'user_promotional_code': model.userPromotionalCode,
        'was_invited': model.wasInvited,
        'customer_id': model.customerId
      };
}
