// To parse this JSON data, do
//
//     final showModel = showModelFromJson(jsonString);

import 'dart:convert';

List<ShowModel> showModelFromJson(String str) => List<ShowModel>.from(json.decode(str).map((x) => ShowModel.fromJson(x)));

String showModelToJson(List<ShowModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowModel {
    int id;
    String titleEn;
    String titleAr;
    String descriptionEn;
    String descriptionAr;
    String image;
    dynamic facebook;
    dynamic twitter;
    dynamic instagram;
    String status;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;
    String description2En;
    String description2Ar;
    Pivot pivot;

    ShowModel({
        this.id,
        this.titleEn,
        this.titleAr,
        this.descriptionEn,
        this.descriptionAr,
        this.image,
        this.facebook,
        this.twitter,
        this.instagram,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.description2En,
        this.description2Ar,
        this.pivot,
    });

    factory ShowModel.fromJson(Map<String, dynamic> json) => ShowModel(
        id: json["id"] == null ? null : json["id"],
        titleEn: json["title_en"] == null ? null : json["title_en"],
        titleAr: json["title_ar"] == null ? null : json["title_ar"],
        descriptionEn: json["description_en"] == null ? null : json["description_en"],
        descriptionAr: json["description_ar"] == null ? null : json["description_ar"],
        image: json["image"] == null ? null : json["image"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        description2En: json["description2_en"] == null ? null : json["description2_en"],
        description2Ar: json["description2_ar"] == null ? null : json["description2_ar"],
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title_en": titleEn == null ? null : titleEn,
        "title_ar": titleAr == null ? null : titleAr,
        "description_en": descriptionEn == null ? null : descriptionEn,
        "description_ar": descriptionAr == null ? null : descriptionAr,
        "image": image == null ? null : image,
        "facebook": facebook,
        "twitter": twitter,
        "instagram": instagram,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "description2_en": description2En == null ? null : description2En,
        "description2_ar": description2Ar == null ? null : description2Ar,
        "pivot": pivot == null ? null : pivot.toJson(),
    };
}

class Pivot {
    int dayId;
    int showId;
    String fromTime;
    String toTime;

    Pivot({
        this.dayId,
        this.showId,
        this.fromTime,
        this.toTime,
    });

    factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        dayId: json["day_id"] == null ? null : json["day_id"],
        showId: json["show_id"] == null ? null : json["show_id"],
        fromTime: json["from_time"] == null ? null : json["from_time"],
        toTime: json["to_time"] == null ? null : json["to_time"],
    );

    Map<String, dynamic> toJson() => {
        "day_id": dayId == null ? null : dayId,
        "show_id": showId == null ? null : showId,
        "from_time": fromTime == null ? null : fromTime,
        "to_time": toTime == null ? null : toTime,
    };
}