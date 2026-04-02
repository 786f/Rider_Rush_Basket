// class RiderJobModel {
//
//   final String id;
//
//   final String jobTitle;
//
//   final int joiningBonus;
//
//   final int onboardingFee;
//
//   final String city;
//
//   final String vendorName;
//
//   final String storeName;
//
//   RiderJobModel({
//     required this.id,
//     required this.jobTitle,
//     required this.joiningBonus,
//     required this.onboardingFee,
//     required this.city,
//     required this.vendorName,
//     required this.storeName,
//   });
//
//   factory RiderJobModel.fromJson(Map<String, dynamic> json) {
//     return RiderJobModel(
//       id: json['_id'] ?? '',
//       jobTitle: json['jobTitle'] ?? '',
//       joiningBonus: json['joiningBonus'] ?? 0,
//       onboardingFee: json['onboardingFee'] ?? 0,
//       city: json['location']?['city'] ?? '',
//       vendorName: json['vendor']?['vendorName'] ?? '',
//       storeName: json['vendor']?['storeName'] ?? '',
//     );
//   }
// }

class RiderJobModel {
  final String id;
  final String jobTitle;

  final double joiningBonus;   // ✅ changed
  final double onboardingFee;  // ✅ changed

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

      // 🔥 MAIN FIX
      joiningBonus:
      (json['joiningBonus'] as num?)?.toDouble() ?? 0.0,

      onboardingFee:
      (json['onboardingFee'] as num?)?.toDouble() ?? 0.0,

      city: json['location']?['city'] ?? '',
      vendorName: json['vendor']?['vendorName'] ?? '',
      storeName: json['vendor']?['storeName'] ?? '',
    );
  }
}