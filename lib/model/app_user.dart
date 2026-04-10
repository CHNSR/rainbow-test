class AppUser {
  String id;
  String name;
  String role;
  String pin;
  bool isActive;

  AppUser(
      {required this.id,
      required this.name,
      required this.role,
      required this.pin,
      this.isActive = true});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'pin': pin,
        'isActive': isActive,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'],
        name: json['name'],
        role: json['role'],
        pin: json['pin'],
        isActive: json['isActive'] ?? true,
      );
}
