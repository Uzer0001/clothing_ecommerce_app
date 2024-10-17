class Cart {
  final String productid;
  final String categoryId;
  final String productName;
  final double price;
  final double quntity;
  final String productImageUrl;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int productQuntity;
  final double productTotalPrice;

  Cart(
      {required this.productid,
      required this.categoryId,
      required this.productName,
      required this.price,
      required this.quntity,
      required this.productImageUrl,
      required this.productDescription,
      required this.createdAt,
      required this.updatedAt,
      required this.productQuntity,
      required this.productTotalPrice});
  Map<String, dynamic> toMap() {
    return {
      'productid': productid,
      'categoryId': categoryId,
      'productName': productName,
      'price': price,
      'quntity': quntity,
      'productImageUrl': productImageUrl,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productQuntity': productQuntity,
      'productTotalPrice': productTotalPrice,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> json) {
    return Cart(
        productid: json['productid'],
        categoryId: json['categoryId'],
        productName: json['productName'],
        price: json['price'],
        quntity: json['quntity'],
        productImageUrl: json['productImageUrl'],
        productDescription: json['productDescription'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        productQuntity: json['productQuntity'],
        productTotalPrice: json['productTotalPrice']);
  }
}
