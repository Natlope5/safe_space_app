class Shelter {
  final String name;
  final String address;
  final String city;
  final String state;
  final String zip;

  Shelter({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory Shelter.fromJson(Map<String, dynamic> json) {
    return Shelter(
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
    );
  }
}
