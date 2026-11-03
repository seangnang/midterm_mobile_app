class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.discountPercentage = 0.0,
    this.rating = 0.0,
    this.stock = 0,
    this.brand = '',
    this.category = '',
    this.thumbnail = '',
    this.images = const [],
  });

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  String get displayImage {
    if (thumbnail.isNotEmpty) return thumbnail;
    if (images.isNotEmpty) return images.first;
    return '';
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var rawImages = json['images'];
    List<String> imagesList = [];
    if (rawImages is List) {
      imagesList = rawImages.map((e) => e.toString()).toList();
    }

    return ProductModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? json['name']?.toString() ?? 'Unnamed Product',
      description: json['description']?.toString() ?? '',
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      discountPercentage: (json['discountPercentage'] is num)
          ? (json['discountPercentage'] as num).toDouble()
          : double.tryParse(json['discountPercentage']?.toString() ?? '0') ?? 0.0,
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      stock: (json['stock'] is int)
          ? json['stock']
          : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      brand: json['brand']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
      thumbnail: json['thumbnail']?.toString() ?? (imagesList.isNotEmpty ? imagesList.first : ''),
      images: imagesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
    };
  }
}

