import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'current_order_controller.dart';

class CurrentOrderScreen extends StatelessWidget {
  CurrentOrderScreen({super.key});

  final CurrentOrderController controller =
  Get.put(CurrentOrderController());

  static const Color primaryOrange = Color(0xffF57C00);
  static const Color bgColor = Color(0xffFFF7F1);

  void _openCameraBottomSheet(
      BuildContext context, String orderId) {
    final picker = ImagePicker();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Upload Pick-Up Image",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              controller.selectedImage.value == null
                  ? GestureDetector(
                onTap: () async {
                  final picked =
                  await picker.pickImage(
                      source:
                      ImageSource.camera);
                  if (picked != null) {
                    controller.selectedImage.value =
                        File(picked.path);
                  }
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey),
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                  ),
                ),
              )
                  : ClipRRect(
                borderRadius:
                BorderRadius.circular(15),
                child: Image.file(
                  controller.selectedImage.value!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                controller.selectedImage.value ==
                    null
                    ? null
                    : () {
                  controller.uploadDeliveryImage(
                      orderId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xffF57C00),
                  minimumSize:
                  const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                    color: Colors.white)
                    : const Text(
                  "Upload & Pick-Up",
                  style: TextStyle(
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }),
      ),
      isScrollControlled: true,
    );
  }

  void _openDeliveredBottomSheet(
      BuildContext context, String orderId) {
    final picker = ImagePicker();

    controller.selectedImage.value = null;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Upload Delivery Image",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              controller.selectedImage.value == null
                  ? GestureDetector(
                onTap: () async {
                  final picked =
                  await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 40,
                      maxWidth: 800);
                  if (picked != null) {
                    controller.selectedImage.value =
                        File(picked.path);
                  }
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey),
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                  ),
                ),
              )
                  : ClipRRect(
                borderRadius:
                BorderRadius.circular(15),
                child: Image.file(
                  controller.selectedImage.value!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                controller.selectedImage.value ==
                    null
                    ? null
                    : () {
                  controller
                      .uploadDeliveredImage(
                      orderId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xffF57C00),
                  minimumSize:
                  const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                    color: Colors.white)
                    : const Text(
                  "Upload & Deliver",
                  style: TextStyle(
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }),
      ),
      isScrollControlled: true,
    );
  }


  Future<void> _openGoogleMap(double lat, double lng) async {
    final Uri googleUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(
        googleUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar(
        "Error",
        "Unable to open Google Maps",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryOrange,
        centerTitle: true,
        title: const Text(
          "Current Order",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = controller.orderData.value;

        if (order == null) {
          return const Center(
            child: Text(
              "No current order available",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              _title("Order #${order.orderNumber}"),
                              _statusChip(order.status),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _row("Payment", order.paymentMethod),
                          _row("Total Amount", "₹${order.total}"),
                          _row("Your Earnings", "₹${order.deliveryAmount}"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Customer Details"),
                          const SizedBox(height: 12),
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _callCustomer(order.userPhone),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: primaryOrange.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: primaryOrange,
                                    child: Icon(Icons.call,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      order.userPhone,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      size: 16)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on,
                                  color: primaryOrange),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${order.shippingAddress.line1}, ${order.shippingAddress.city}, ${order.shippingAddress.state} - ${order.shippingAddress.pinCode}",
                                  style:
                                  const TextStyle(height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Order Items"),
                          const SizedBox(height: 12),
                          ...order.items.map((item) {
                            return Container(
                              margin:
                              const EdgeInsets.only(bottom: 12),
                              padding:
                              const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    child: Image.network(
                                      item.image,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Qty: ${item.quantity}",
                                          style: const TextStyle(
                                              color:
                                              Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "₹${item.price}",
                                    style: const TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      color: primaryOrange,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (order.status == "rider_assign") {
                          _openGoogleMap(
                            order.vendor.storeAddress.latitude,
                            order.vendor.storeAddress.longitude,
                          );
                        } else {
                          _openGoogleMap(
                            order.shippingAddress.latitude,
                            order.shippingAddress.longitude,
                          );
                        }
                      },
                      icon: const Icon(Icons.navigation),
                      label: const Text("Navigate"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                            color: primaryOrange),
                        foregroundColor: primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (order.status == "rider_assign") {
                          _openCameraBottomSheet(context, order.id);
                        } else if (order.status == "out_for_delivery") {
                          _openDeliveredBottomSheet(context, order.id);
                        }
                      },
                      // onPressed: () {
                      //   if (order.status ==
                      //       "rider_assign") {
                      //     _openCameraBottomSheet(context, order.id);
                      //   } else {
                      //     _showDeliveredDialog(
                      //         context, order.id);
                      //   }
                      // },
                      icon:
                      const Icon(Icons.check_circle,color: Colors.white,),
                      label: Text(
                        order.status == "rider_assign"
                            ? "Pick-Up"
                            : order.status == "out_for_delivery"
                            ? "Delivered"
                            : "Completed",
                        style: const TextStyle(color: Colors.white),
                      ),
                      // label: Text(order.status == "rider_assign" ? "Pick-Up" : "Delivered",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        padding:
                        const EdgeInsets.symmetric(
                            vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: primaryOrange,
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style:
      const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
              const TextStyle(color: Colors.black54)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: primaryOrange)),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryOrange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: primaryOrange,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _callCustomer(String phone) async {
    final Uri url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar(
        "Error",
        "Unable to open dialer",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

