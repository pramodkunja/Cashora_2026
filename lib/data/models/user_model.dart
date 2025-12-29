class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final String orgName;
  final String orgCode;
  final String phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.orgName = '',
    this.orgCode = '',
    this.phoneNumber = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final org = json['organization'] is Map ? json['organization'] : <String, dynamic>{};

    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['full_name']?.toString() ?? json['name']?.toString() ?? 'Unknown',
      role: json['role']?.toString() ?? 'requestor',
      orgName: org['name']?.toString() ?? json['org_name']?.toString() ?? '',
      orgCode: org['org_code']?.toString() ?? json['org_code']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'full_name': name, // Maintain compatibility
      'role': role,
      'org_name': orgName,
      'org_code': orgCode,
      'phone_number': phoneNumber,
    };
  }
}
