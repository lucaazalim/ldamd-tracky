class Address {
  final String street;
  final String number;
  final String district;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;

  Address({
    required this.street,
    required this.number,
    required this.district,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return '$street, $number - $district, $city - $state, $zipCode';
  }
}