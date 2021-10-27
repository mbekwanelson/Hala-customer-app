class Transaction {
  String transactionId;
  String merchantCode;
  String siteCode;
  String transactionRefrences;
  double amount;
  String status;
  String statusMessage;
  DateTime createdDate;

  Transaction(
      {this.amount,
      this.createdDate,
      this.merchantCode,
      this.siteCode,
      this.status,
      this.statusMessage,
      this.transactionId,
      this.transactionRefrences});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionRefrences: json['TransactionRefrences'],
      amount: json['Amount'],
      createdDate: json['CreatedDate'],
      merchantCode: json['MerchantCode'],
      siteCode: json['SiteCode'],
      status: json['Status'],
      statusMessage: json['StatusMessage'],
      transactionId: json[' TransactionId'],
    );
  }
}
