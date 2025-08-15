class UserModel {
  final int? id;
  final String? name;
  final int? age;
  final String? gender;
  final String? bio;
  final String? location;
  final String? interests;
  final String? profileImageUrl;
  final bool? isLikedByMe;
  final double? height;
  final String? sports;
  final String? games;
  final String? relationshipType;
  final bool? goesGym;
  final bool? shortHair;
  final bool? wearGlasses;
  final bool? drink;
  final bool? smoke;
  final int? score;

  UserModel({
    this.id,
    this.name,
    this.age,
    this.gender,
    this.bio,
    this.location,
    this.interests,
    this.profileImageUrl,
    this.isLikedByMe,
    this.height,
    this.sports,
    this.games,
    this.relationshipType,
    this.goesGym,
    this.shortHair,
    this.wearGlasses,
    this.drink,
    this.smoke,
    this.score,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      bio: json['bio'],
      location: json['location'],
      interests: json['interests'],
      profileImageUrl: json['profileImageUrl'],
      isLikedByMe: json['isLikedByMe'] ?? false,
      height: json['height']?.toDouble(),
      sports: json['sports'],
      games: json['games'],
      relationshipType: json['relationshipType'],
      goesGym: json['goesGym'],
      shortHair: json['shortHair'],
      wearGlasses: json['wearGlasses'],
      drink: json['drink'],
      smoke: json['smoke'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'bio': bio,
      'location': location,
      'interests': interests,
      'profileImageUrl': profileImageUrl,
      'height': height,
      'sports': sports,
      'games': games,
      'relationshipType': relationshipType,
      'goesGym': goesGym,
      'shortHair': shortHair,
      'wearGlasses': wearGlasses,
      'drink': drink,
      'smoke': smoke,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    int? age,
    String? gender,
    String? bio,
    String? location,
    String? interests,
    String? profileImageUrl,
    bool? isLikedByMe,
    double? height,
    String? sports,
    String? games,
    String? relationshipType,
    bool? goesGym,
    bool? shortHair,
    bool? wearGlasses,
    bool? drink,
    bool? smoke,
    int? score,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      height: height ?? this.height,
      sports: sports ?? this.sports,
      games: games ?? this.games,
      relationshipType: relationshipType ?? this.relationshipType,
      goesGym: goesGym ?? this.goesGym,
      shortHair: shortHair ?? this.shortHair,
      wearGlasses: wearGlasses ?? this.wearGlasses,
      drink: drink ?? this.drink,
      smoke: smoke ?? this.smoke,
      score: score ?? this.score,
    );
  }
}