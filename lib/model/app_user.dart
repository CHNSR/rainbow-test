class Employee {
  String id;
  String name;
  String role;
  String pin;
  bool isActive;
  double? hourlyWage;

  Employee(
      {required this.id,
      required this.name,
      required this.role,
      required this.pin,
      this.isActive = true,
      this.hourlyWage});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'pin': pin,
        'isActive': isActive,
        'hourlyWage': hourlyWage,
      };

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json['id'],
        name: json['name'],
        role: json['role'],
        pin: json['pin'],
        isActive: json['isActive'] ?? true,
        hourlyWage: (json['hourlyWage'] as num?)?.toDouble(),
      );
}
