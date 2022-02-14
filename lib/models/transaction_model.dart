class TransactionModel {
  String? senderUid,
      senderName,
      receiverName,
      receiverUid,
      souceCurrency,
      targetCurrency;

  double? exchanchangerate, amount, charge;

  TransactionModel(
      {this.amount,
      this.charge,
      this.exchanchangerate,
      this.receiverUid,
      this.senderUid,
      this.souceCurrency,
      this.targetCurrency});
}
