class Location {
  final int id;
  final String title;
  final String direccion;

  Location({required this.id, required this.title, required this.direccion});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      title: json['title'],
      direccion: json['direccion'],
      
    );
  }
}