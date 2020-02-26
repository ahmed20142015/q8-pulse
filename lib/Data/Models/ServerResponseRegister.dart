class ServerResponseRegisterPhone {
  String success;
  
  String message;

  ServerResponseRegisterPhone({this.success,  this.message});

  factory ServerResponseRegisterPhone.fromJson(Map<String, dynamic> json) {
    return new ServerResponseRegisterPhone(
      success: json['success'],
      
      message: json['message'],
    );
  }
}
