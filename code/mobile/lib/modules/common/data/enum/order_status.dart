/// Enum representing the status of an order.
///
/// The possible statuses are:
/// - `pending`: The order is awaiting processing.
/// - `accepted`: The order has been accepted.
/// - `onCourse`: The order is currently being delivered.
/// - `delivered`: The order has been successfully delivered.
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