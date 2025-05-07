enum OrderStatus {
  pending,
  accepted,
  onCourse,
  delivered;

  factory OrderStatus.fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return OrderStatus.pending;
      case 'ACCEPTED':
        return OrderStatus.accepted;
      case 'ON_COURSE':
        return OrderStatus.onCourse;
      case 'DELIVERED':
        return OrderStatus.delivered;
      default:
        throw ArgumentError('Invalid status: $value');
    }
  }

  String toJson() => name.toUpperCase();
}