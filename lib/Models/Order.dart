class Order {
  String title;
  double price;
  String foodId;
  String image;
  int quantity;
  int numOrders;

  Order(
      {this.title,
      this.image,
      this.price,
      this.foodId,
      this.quantity = 1,
      this.numOrders});
}
