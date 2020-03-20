class PresenterModel {
  String id;
  String name_en;
  String image;
  String facebook;
  String twitter;
  String instagram;
  String about2_en;
  String about2_ar;

  PresenterModel(
      {this.id,
      this.name_en,
      this.image,
      this.facebook,
      this.twitter,
      this.instagram,
      this.about2_en,
      this.about2_ar});

  factory PresenterModel.fromJson(Map<String, dynamic> json) {
    return PresenterModel(
      id: json["id"],
      name_en: json["name_en"],
      image: json["image"],
      facebook: json["facebook"],
      twitter: json["twitter"],
      instagram: json["instagram"],
      about2_en: json["about2_en"],
      about2_ar: json["about2_ar"],
    );
  }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name_en": name_en,
        "image": image,
        "facebook": facebook,
        "twitter": twitter,
        "instagram": instagram,
        "about2_en": about2_en,
        "about2_ar": about2_ar,
      };
}
