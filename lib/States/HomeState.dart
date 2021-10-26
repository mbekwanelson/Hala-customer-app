import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mymenu/Models/FoodItem.dart';
import 'package:mymenu/Models/Meal.dart';
import 'package:mymenu/Models/MealOption.dart';
import 'package:mymenu/Models/Shop.dart';

class HomeState with ChangeNotifier {
  List<Meal> meals = [];
  List<FoodItem> food = [];
  List<FoodItem> pizzas = [];
  List<FoodItem> desserts = [];
  List<FoodItem> drinks = [];
  int tab = 0;
  List<FoodItem> selectedCategory = [];

  category(Shop shop, String category) async {
    //selectedCategory = [];
    tab = 1;

    await FirebaseFirestore.instance
        .collection("Options")
        .doc(shop.category)
        .collection(shop.category)
        .doc(shop.shopName)
        .collection("Items")
        .where("category", isEqualTo: category)
        .get()
        .then((QuerySnapshot categoryItems) {
      selectedCategory = [];
      for (int item = 0; item < categoryItems.docs.length; item++) {
        selectedCategory.add(FoodItem(
            //! TODO sya : needs testing : removed .data
            // title: categoryItems.docs[item].data["title"] ?? "no",
            title: categoryItems.docs[item]["title"] ?? "no",
            image: categoryItems.docs[item]["image"] ??
                "https://cdn.pixabay.com/photo/2018/03/04/20/08/burger-3199088__340.jpg",
            price: categoryItems.docs[item]["price"] ?? 0,
            id: categoryItems.docs[item]["id"] ?? "ai",
            category: categoryItems.docs[item]["category"] ?? "nja",
            shop: shop.shopName,
            inStock: categoryItems.docs[item]["inStock"] ?? true));
      }
      notifyListeners();
    });

    await Future.delayed(const Duration(seconds: 1), () => "1");

    notifyListeners();
  }

  Future<List<Meal>> allMeals(Shop shop, String category) async {
    List<MealOption> options = [];
    Meal meal;
    List<dynamic> compulsoryOptions = [];
    Map<dynamic, dynamic> numberPerOption = {};
    meals = [];

    await FirebaseFirestore.instance
        .collection("Options")
        .doc(shop.category)
        .collection(shop.category)
        .doc(shop.shopName)
        .collection("Meals")
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        doc.data().forEach((key, value) {
          if (key == 'compulsoryOptions') {
            compulsoryOptions = value.toList();
          }
        });

        meal = Meal(
            shop: shop.shopName,
            //! TODO sya : needs testing : removed .data
            // title: doc.data['title'],
            title: doc['title'],
            initialPrice: doc['initial Price'].toDouble(),
            image: doc['image']);

        doc.data().forEach((key, value) {
          if (key == 'Options') {
            // Different options
            for (int optionName = 0;
                optionName < compulsoryOptions.length;
                optionName++) {
              numberPerOption = value[compulsoryOptions[optionName]];
              for (int optionValue = 1;
                  optionValue < numberPerOption.length + 1;
                  optionValue++) {
                options.add(MealOption(
                    //! TODO sya : needs testing : removed .data
                    title: doc['Options'][compulsoryOptions[optionName]]
                        ['Item $optionValue']['title'],
                    price: doc['Options'][compulsoryOptions[optionName]]
                            ['Item $optionValue']['price']
                        .toDouble(),
                    category: compulsoryOptions[optionName]));
              }
              meal.addOption(options);
              options = [];
            }
          }
        });
        meals.add(meal);
      });
    });
    tab = 2;
    notifyListeners();
    return meals;
  }
}
