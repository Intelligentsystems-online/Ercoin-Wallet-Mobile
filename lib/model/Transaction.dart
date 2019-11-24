class Transaction
{
  final String receiverAddress;
  final String senderAddress;
  final int coins;
  final String message;
  final int timestamp;

  Transaction(this.receiverAddress, this.senderAddress, this.coins, this.message, this.timestamp);

  factory Transaction.fromMap(Map<String, dynamic> json) => new Transaction(
      json["receiverAddress"],
      json["senderAddress"],
      json["coins"],
      json["message"],
      json["timestamp"]);

  Map<String, dynamic> toMap() => {
    'receiverAddress' : receiverAddress,
    'senderAddress' : senderAddress,
    'coins' : coins,
    'message' : message,
    'timestamp' : timestamp
  };
}