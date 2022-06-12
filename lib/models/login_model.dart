/// status : true
/// message : "تم تسجيل الدخول بنجاح"
/// data : {"id":2951,"name":"Ali Fadel Hassan","email":"alyfadel67@gmail.com","phone":"1225010913","image":"https://student.valuxapps.com/storage/assets/defaults/user.jpg","points":0,"credit":0,"token":"clg1M5VxttHFP9uEjp9mnl3dLYz46ySGR290HCelVz8xegBSajAJgCEU43gWzCYxuas3y0"}

class LoginModel {

  LoginModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Data? data;


}

/// id : 2951
/// name : "Ali Fadel Hassan"
/// email : "alyfadel67@gmail.com"
/// phone : "1225010913"
/// image : "https://student.valuxapps.com/storage/assets/defaults/user.jpg"
/// points : 0
/// credit : 0
/// token : "clg1M5VxttHFP9uEjp9mnl3dLYz46ySGR290HCelVz8xegBSajAJgCEU43gWzCYxuas3y0"

class Data {

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    points = json['points'];
    credit = json['credit'];
    token = json['token'];
  }
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? points;
  int? credit;
  String? token;


}