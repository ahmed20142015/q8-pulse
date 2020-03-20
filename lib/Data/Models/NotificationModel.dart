class NotificationModel{
  int id;
  bool notified;
  NotificationModel({ this.id , this.notified });

factory NotificationModel.fromJson(Map<String , dynamic> json){
  return NotificationModel(
    id: json["id"],
    notified: json["notified"]
  );
}
Map<String , dynamic> toJson() => {
  "id" : id ,
  "notified" : notified
};

}