class Plate {
  final String plate;
  final String name;
  final String phone;
  final int age;
  final String email;
  final String imageUrl;

  Plate({
    required this.plate,
    required this.name,
    required this.phone,
    required this.age,
    required this.email,
    required this.imageUrl,
  });

  factory Plate.fromMap(Map<String, dynamic> map) {
    return Plate(
      plate: map['plate'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      age:
          map['age'] is int
              ? map['age']
              : int.tryParse(map['age']?.toString() ?? '0') ?? 0,
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plate': plate,
      'name': name,
      'phone': phone,
      'age': age,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}
