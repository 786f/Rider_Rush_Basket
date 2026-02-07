class RiderJobModel {

  final String id;

  final String jobTitle;

  final int joiningBonus;
  
  final int onboardingFee;

  final String city;

  final String vendorName;

  final String storeName;

  RiderJobModel({
    required this.id,
    required this.jobTitle,
    required this.joiningBonus,
    required this.onboardingFee,
    required this.city,
    required this.vendorName,
    required this.storeName,
  });

  factory RiderJobModel.fromJson(Map<String, dynamic> json) {
    return RiderJobModel(
      id: json['_id'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      joiningBonus: json['joiningBonus'] ?? 0,
      onboardingFee: json['onboardingFee'] ?? 0,
      city: json['location']?['city'] ?? '',
      vendorName: json['vendor']?['vendorName'] ?? '',
      storeName: json['vendor']?['storeName'] ?? '',
    );
  }
}
