class Producto {
  final int productId;
  final String productName;
  final num productPrice;
  final String productImage;
  final String? productState;

  Producto({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    this.productState,
  });

  factory Producto.fromJson(Map<String, dynamic> j) => Producto(
        productId: j['product_id'] ?? 0,
        productName: j['product_name'] ?? '',
        productPrice: j['product_price'] ?? 0,
        productImage: j['product_image'] ?? '',
        productState: j['product_state'],
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'product_price': productPrice,
        'product_image': productImage,
        if (productState != null) 'product_state': productState,
      };
}

List<Producto> productosFromJson(List<dynamic> list) =>
    list.map((e) => Producto.fromJson(e as Map<String, dynamic>)).toList();
