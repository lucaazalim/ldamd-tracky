/// Enum representing the type of user in the system.
/// 
/// This can either be a customer or a driver. Provides methods for
/// converting to and from string representations.
enum UserType {
  customer,
  driver;

  factory UserType.fromString(String value) {
    switch (value.toUpperCase()) {
      case 'CUSTOMER':
        return UserType.customer;
      case 'DRIVER':
        return UserType.driver;
      default:
        throw ArgumentError('Invalid user type: $value');
    }
  }

  String toJson() {
    switch (this) {
      case UserType.customer:
        return 'CUSTOMER';
      case UserType.driver:
        return 'DRIVER';
    }
  }
}