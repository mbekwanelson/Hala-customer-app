
class Transaction{

  String TransactionId;
  String MerchantCode;
  String SiteCode;
  String TransactionRefrences;
  double Amount;
  String Status;
  String StatusMessage;
  DateTime CreatedDate;


  Transaction(
      {
        this.Amount,
        this.CreatedDate,
        this.MerchantCode,
        this.SiteCode,
        this.Status,
        this.StatusMessage,
        this.TransactionId,
        this.TransactionRefrences
      }
      );


  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
     TransactionRefrences:json['TransactionRefrences'],
      Amount:json['Amount'],
      CreatedDate:json['CreatedDate'],
      MerchantCode:json['MerchantCode'],
      SiteCode:json['SiteCode'],
      Status:json['Status'],
      StatusMessage:json['StatusMessage'],
      TransactionId:json[' TransactionId'],
    );
  }










}