
class PaymentRequest{

  String paymentRequestId;
  String url;
  String errorMessage;



  //{"paymentRequestId":"0d2de8ce-04ff-4ce0-ab7a-0c79cf929502","url":"https://pay.ozow.com/0d2de8ce-04ff-4ce0-ab7a-0c79cf929502/Secure","errorMessage":null}
  PaymentRequest(
      {
        this.paymentRequestId,
        this.url,
        this.errorMessage,
      });


  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      paymentRequestId: json['paymentRequestId'],
      url: json['url'],
      errorMessage: json['errorMessage'],
    );
  }
}