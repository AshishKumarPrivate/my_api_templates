class LoginResponseModel {
  bool? success;
  String? message;
  Data? data;

  LoginResponseModel({this.success, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? email;
  String? role;
  String? token;
  AllData? allData;

  Data({this.id, this.email, this.role, this.token, this.allData});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    role = json['role'];
    token = json['token'];
    allData =
    json['allData'] != null ? new AllData.fromJson(json['allData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['role'] = this.role;
    data['token'] = this.token;
    if (this.allData != null) {
      data['allData'] = this.allData!.toJson();
    }
    return data;
  }
}

class AllData {
  String? sId;
  String? name;
  String? email;
  String? phoneNo;
  String? whatsappNo;
  String? altNo;
  String? password;
  String? empId;
  String? role;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AllData(
      {this.sId,
        this.name,
        this.email,
        this.phoneNo,
        this.whatsappNo,
        this.altNo,
        this.password,
        this.empId,
        this.role,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AllData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phoneNo = json['phoneNo'];
    whatsappNo = json['whatsappNo'];
    altNo = json['altNo'];
    password = json['password'];
    empId = json['empId'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneNo'] = this.phoneNo;
    data['whatsappNo'] = this.whatsappNo;
    data['altNo'] = this.altNo;
    data['password'] = this.password;
    data['empId'] = this.empId;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
