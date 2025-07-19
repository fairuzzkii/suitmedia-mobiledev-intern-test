class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    print('Parsing user: ${json['first_name']} ${json['last_name']}');
    
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }
}

class UserResponse {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<User> data;

  UserResponse({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    print('Parsing UserResponse: page ${json['page']}, total ${json['total']}');
    
    return UserResponse(
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 6,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
      data: (json['data'] as List?)
          ?.map((user) => User.fromJson(user))
          .toList() ?? [],
    );
  }
}