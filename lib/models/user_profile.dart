class UserProfile {
  String id;
  String name;
  String? firstName;
  String? lastName;
  int age;
  double height; // cm
  double weight; // kg
  String goal; // 'lose'|'gain'|'maintain'
  String activityLevel; // 'sedentary'|'active'
  String? birthDate; // e.g. "01.01.1990"

  UserProfile({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    required this.age,
    required this.height,
    required this.weight,
    required this.goal,
    required this.activityLevel,
    this.birthDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'height': height,
        'weight': weight,
        'goal': goal,
        'activityLevel': activityLevel,
        'birthDate': birthDate,
      };

  static UserProfile fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'],
        name: json['name'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        age: json['age'],
        height: (json['height'] as num).toDouble(),
        weight: (json['weight'] as num).toDouble(),
        goal: json['goal'],
        activityLevel: json['activityLevel'],
        birthDate: json['birthDate'],
      );
}
