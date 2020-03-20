
class UserModel {
  int id;
  String first_name;
  String last_name;
  String phone;
  String image;
  int is_verified;
  String success;

  String lang;
  String messageError;


  UserModel(
      {this.id,
      this.first_name,
      this.last_name,
      this.phone,
      this.image,
      this.is_verified,
      this.success,
      this.lang,
      this.messageError});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      first_name: json["first_name"],
      last_name: json["last_name"],
      phone: json["phone"], 
      image: json["image"], 
      is_verified: json["is_verified"], 
      success: json['success'],

      lang: json['lang'],
      messageError: json['message'],
      
    );
  }


  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": first_name,
        "last_name": last_name,
        "phone": phone,
        "image": image,
        "is_verified": is_verified,
        "success": success,

        "lang": lang,
    "message": messageError
        
      };


}
