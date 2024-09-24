class UserModel {
  String? id;
  String? chooseType;
  String? name;
  String? user;
  String? password;
  String? nameShop;
  String? address;
  String? phone;
  String? urlPicture;
  String? lat;
  String? lng;
  String? token;

  UserModel(
      {this.id,
      this.chooseType,
      this.name,
      this.user,
      this.password,
      this.nameShop,
      this.address,
      this.phone,
      this.urlPicture,
      this.lat,
      this.lng,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chooseType = json['chooseType'];
    name = json['name'];
    user = json['user'];
    password = json['password'];
    nameShop = json['name_shop'];
    address = json['address'];
    phone = json['phone'];
    urlPicture = json['url_picture'];
    lat = json['lat'];
    lng = json['lng'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chooseType'] = this.chooseType;
    data['name'] = this.name;
    data['user'] = this.user;
    data['password'] = this.password;
    data['name_shop'] = this.nameShop;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['url_picture'] = this.urlPicture;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['token'] = this.token;
    return data;
  }
}