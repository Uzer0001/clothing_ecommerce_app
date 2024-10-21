class Orders {
  final String productid;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String productImage;
  final double price;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int productQuntity;
  final double productTotalPrice;
  final String customerId;
  final bool status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerDeviceToken;

  Orders({
    required this.productid,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.productImage,
    required this.price,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.productQuntity,
    required this.productTotalPrice,
    required this.customerId,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerDeviceToken,
  });

  Map<String,dynamic> toMap(){
    return{
      'productid': productid,
      'categoryId':categoryId,
      'productName':productName, 
      'categoryName':categoryName, 
      'productImage':productImage, 
      'price':price,
      'productDescription':productDescription, 
      'createdAt':createdAt, 
      'updatedAt':updatedAt, 
      'productQuntity':productQuntity, 
      'productTotalPrice':productTotalPrice, 
      'customerId':customerId, 
      'status':status, 
      'customerName':customerName, 
      'customerPhone':customerPhone, 
      'customerAddress':customerAddress, 
      'customerDeviceToken':customerDeviceToken,
    };
  }
  factory Orders.fromMap(Map<String,dynamic> json){
    return Orders(
      productid: json['productid'],
      categoryId:json['categoryId'],
      productName:json['productName'], 
      categoryName:json['categoryName'], 
      productImage:json['productImage'], 
      price: json['price'],
      productDescription:json['productDescription'], 
      createdAt:json['createdAt'], 
      updatedAt:json['updatedAt'], 
      productQuntity:json['productQuntity'], 
      productTotalPrice:json['productTotalPrice'], 
      customerId:json['customerId'], 
      status:json['status'], 
      customerName:json['customerName'], 
      customerPhone:json['customerPhone'], 
      customerAddress:json['customerAddress'], 
      customerDeviceToken:json['customerDeviceToken'],
      );
  }
  
}
