class EmployeeModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String position;
  final String department;
  final String address;
  final String image;

  EmployeeModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.position,
    required this.department,
    this.address = '',
    this.image = '',
  });

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isNotEmpty ? name : 'Unnamed Employee';
  }

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return f.isNotEmpty ? '$f$l' : 'E';
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    // Handle position from company.title or flat position/role
    String pos = '';
    String dept = '';
    if (json['company'] is Map) {
      final comp = json['company'] as Map<String, dynamic>;
      pos = comp['title']?.toString() ?? '';
      dept = comp['department']?.toString() ?? '';
    }
    if (pos.isEmpty) {
      pos = json['position']?.toString() ?? json['role']?.toString() ?? 'Staff';
    }
    if (dept.isEmpty) {
      dept = json['department']?.toString() ?? 'Operations';
    }

    // Handle address from address object or flat string
    String addr = '';
    if (json['address'] is Map) {
      final addrMap = json['address'] as Map<String, dynamic>;
      final street = addrMap['address']?.toString() ?? '';
      final city = addrMap['city']?.toString() ?? '';
      addr = [street, city].where((s) => s.isNotEmpty).join(', ');
    } else if (json['address'] is String) {
      addr = json['address'];
    }

    // Handle name split if only 'name' provided
    String fName = json['firstName']?.toString() ?? '';
    String lName = json['lastName']?.toString() ?? '';
    if (fName.isEmpty && json['name'] != null) {
      final parts = json['name'].toString().split(' ');
      fName = parts.first;
      lName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }

    return EmployeeModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      firstName: fName,
      lastName: lName,
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      position: pos,
      department: dept,
      address: addr,
      image: json['image']?.toString() ?? json['avatar']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'name': fullName,
      'email': email,
      'phone': phone,
      'position': position,
      'department': department,
      'address': address,
      'image': image,
      'company': {
        'title': position,
        'department': department,
      },
    };
  }

  EmployeeModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? position,
    String? department,
    String? address,
    String? image,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      position: position ?? this.position,
      department: department ?? this.department,
      address: address ?? this.address,
      image: image ?? this.image,
    );
  }
}

