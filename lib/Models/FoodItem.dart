




class FoodItem {
  String id;
  String title;
  String category;
  double price;
  String image;
  int quantity;
  String shop;

  FoodItem({
    this.id,
    this.title,
    this.category,
    this.price,
    this.image,
    this.quantity=1,
    this.shop

  });

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }
}