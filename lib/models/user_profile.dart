class UserProfile {
  String id;
  String name;
  int age;
  double height; // cm
  double weight; // kg
  String goal; // 'lose'|'gain'|'maintain'
  String activityLevel; // 'sedentary'|'active'

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.goal,
    required this.activityLevel,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'height': height,
        'weight': weight,
        'goal': goal,
        'activityLevel': activityLevel,
      };

  static UserProfile fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        height: (json['height'] as num).toDouble(),
        weight: (json['weight'] as num).toDouble(),
        goal: json['goal'],
        activityLevel: json['activityLevel'],
      );
}
