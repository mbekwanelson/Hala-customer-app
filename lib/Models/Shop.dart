
class Shop{

  String shopName;
  String shopBackground;
  List<dynamic> categories;
  String category;
  double latitude;
  double longitude;
  bool isShopOperating;
  String openingTime;
  String closingTime;

  Shop({this.shopName,this.shopBackground,this.categories,this.category, this.latitude,this.longitude,this.isShopOperating = true, this.openingTime, this.closingTime});
}