class Pet {
  final String id;
  final String name;
  final String breed;
  final String description;
  final String imageUrl;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.description,
    required this.imageUrl,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      description: json['description'],
      imageUrl: json['imageBase64'],
    );
  }
}
