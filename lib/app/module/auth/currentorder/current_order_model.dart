class CurrentOrderResponse {
  final bool success;
  final bool hasCurrentOrder;
  final OrderData? data;

  CurrentOrderResponse({
    required this.success,
    required this.hasCurrentOrder,
    this.data,
  });

  factory CurrentOrderResponse.fromJson(Map<String, dynamic> json) {
    return CurrentOrderResponse(
      success: json['success'] ?? false,
      hasCurrentOrder: json['hasCurrentOrder'] ?? false,
      data: json['data'] != null
          ? OrderData.fromJson(json['data'])
          : null,
    );
  }
}

class OrderData {
  final String id;
  final String orderNumber;
  final String status;
  final double total;
  final int deliveryAmount;
  final String paymentMethod;
  final String userPhone;
  final Address shippingAddress;
  final Vendor vendor;
  final List<OrderItem> items;

  OrderData({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.total,
    required this.deliveryAmount,
    required this.paymentMethod,
    required this.userPhone,
    required this.shippingAddress,
    required this.vendor,
    required this.items,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List? ?? []);

    return OrderData(
      id: json['_id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      status: json['status'] ?? '',
      total: (json['pricing']?['total'] ?? 0).toDouble(),
      deliveryAmount: json['pricing']?['deliveryAmount'] ?? 0,
      paymentMethod: json['payment']?['method'] ?? '',
      userPhone: json['user']?['contactNumber'] ?? '',
      shippingAddress:
      Address.fromJson(json['shippingAddress'] ?? {}),
      vendor: itemsList.isNotEmpty
          ? Vendor.fromJson(itemsList[0]['vendor'] ?? {})
          : Vendor.empty(),
      items: itemsList
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }
}

class OrderItem {
  final String productName;
  final int quantity;
  final double price;
  final String image;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['totalPrice'] ?? 0).toDouble(),
      image: json['image']?['url'] ??
          json['thumbnail']?['url'] ??
          '',
    );
  }
}

class Address {
  final String line1;
  final String city;
  final String state;
  final String pinCode;
  final double latitude;
  final double longitude;

  Address({
    required this.line1,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      line1: json['line1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pinCode: json['pinCode'] ?? '',
      latitude:
      (json['latitude'] ?? 0).toDouble(),
      longitude:
      (json['longitude'] ?? 0).toDouble(),
    );
  }
}

class Vendor {
  final String id;
  final String storeName;
  final String vendorName;
  final VendorAddress storeAddress;

  Vendor({
    required this.id,
    required this.storeName,
    required this.vendorName,
    required this.storeAddress,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['_id'] ?? '',
      storeName: json['storeName'] ?? '',
      vendorName: json['vendorName'] ?? '',
      storeAddress: VendorAddress.fromJson(
          json['storeAddress'] ?? {}),
    );
  }

  factory Vendor.empty() {
    return Vendor(
      id: '',
      storeName: '',
      vendorName: '',
      storeAddress: VendorAddress.empty(),
    );
  }
}

class VendorAddress {
  final String line1;
  final String city;
  final String state;
  final String pinCode;
  final double latitude;
  final double longitude;

  VendorAddress({
    required this.line1,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.latitude,
    required this.longitude,
  });

  factory VendorAddress.fromJson(Map<String, dynamic> json) {
    return VendorAddress(
      line1: json['line1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pinCode: json['pinCode'] ?? '',
      latitude:
      (json['latitude'] ?? 0).toDouble(),
      longitude:
      (json['longitude'] ?? 0).toDouble(),
    );
  }

  factory VendorAddress.empty() {
    return VendorAddress(
      line1: '',
      city: '',
      state: '',
      pinCode: '',
      latitude: 0,
      longitude: 0,
    );
  }
}
