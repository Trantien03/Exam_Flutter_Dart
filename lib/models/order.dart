class AppOrder {
  int? id;
  String dishName;
  int votes;
  String note;
  int quantity;

  AppOrder({
    this.id,
    required this.dishName,
    required this.votes,
    required this.note,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dishName': dishName,
      'votes': votes,
      'note': note,
      'quantity': quantity,
    };
  }

  factory AppOrder.fromMap(Map<String, dynamic> map) {
    return AppOrder(
      id: map['id'] as int?,
      dishName: map['dishName'] as String,
      votes: map['votes'] is int
          ? map['votes'] as int
          : int.tryParse(map['votes'].toString()) ?? 0,
      note: map['note'] as String,
      quantity: map['quantity'] is int
          ? map['quantity'] as int
          : int.tryParse(map['quantity'].toString()) ?? 0,
    );
  }
}