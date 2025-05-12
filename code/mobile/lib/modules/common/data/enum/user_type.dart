enum UserType {
  customer,
  driver;

  factory UserType.fromString(String value) {
    switch (value.toUpperCase()) {
      case 'CUSTOMER': // valor vindo da API/banco
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
        return 'CUSTOMER'; // valor que será enviado para a API/banco
      case UserType.driver:
        return 'DRIVER';
    }
  }
}