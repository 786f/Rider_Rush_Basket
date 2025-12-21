import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:riderrushbasketapp/app/module/auth/document/screen/document_page.dart';
import 'package:riderrushbasketapp/app/module/auth/workdetail/citypage/screen/successcompletedpage.dart';

import '../../../document/screen/document_upload_status.dart';
import 'selectcitypage.dart';

class SelectStorePage extends StatefulWidget {
  @override
  _SelectStorePageState createState() => _SelectStorePageState();
}

class _SelectStorePageState extends State<SelectStorePage> {
  String? selectedStore;
  String searchText = "";

  List<Map<String, dynamic>> allStores = [
    {
      "name": "BLR-JP Nagar New",
      "address": "JP Nagar, Bengaluru, Karnataka",
      "bonus": "₹10,000",
      "fees": "Free · ₹0",
      "recommended": true,
    },
    {
      "name": "BLR-VIJAY NAGAR",
      "address":
          "1st Main Rd, opp. Nisarga Restaurant, SBI Staff Colony, Hosahalli Extension, Bengaluru 560040",
      "bonus": "₹10,000",
      "fees": "Free · ₹0",
      "recommended": true,
    },
    {
      "name": "BLR-Arekere",
      "address":
          "VJP5+87C, Indira Gandhi Housing Colony, Arekere, Bengaluru, Karnataka",
      "bonus": "₹8,000",
      "fees": "Free · ₹0",
      "recommended": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // FILTER STORE BASED ON SEARCH
    List<Map<String, dynamic>> filteredStores = allStores
        .where((store) => store["name"]
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFF7EF),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Select Store",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color(0xFFF28C28),
            fontSize: 20,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Icon(Icons.help_outline, color: Colors.black),
                SizedBox(width: 4),
                Text(
                  "Help",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 15),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (value) {
                setState(() => searchText = value);
              },
              decoration: InputDecoration(
                hintText: "Search stores in your city",
                prefixIcon: Icon(Icons.search, color: Color(0xFFF28C28)),
                suffixIcon: searchText.isNotEmpty
                    ? GestureDetector(
                        onTap: () => setState(() => searchText = ""),
                        child: Icon(Icons.close, color: Colors.black54),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      BorderSide(color: Colors.orange.shade200, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Color(0xFFF28C28), width: 2),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // ================================================================
          //     IF NO STORE FOUND — SHOW THIS UI
          // ================================================================
          if (filteredStores.isEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 90),
                    SizedBox(height: 20),
                    Text(
                      "No stores found in Bengaluru",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "We will notify you once stores are available\n in your city",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Change City Button
                        GestureDetector(
                          onTap: () => Get.to(() => SelectCityPage()),
                          child: Container(
                            height: 45,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text("Change City"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.orange.shade500,
                                side: BorderSide(color: Colors.orange.shade100),
                                backgroundColor: Colors.orange.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 20),

                        // Notify me button
                        Container(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.snackbar(
                                "", // No title
                                "You will be notified once shifts are available",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange.shade100,
                                margin: EdgeInsets.all(12),
                                borderRadius: 12,
                              );
                            },
                            child: Text(
                              "Notify Me",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),



                      ],
                    ),
                  ],
                ),
              ),
            )
          else

            // ================================================================
            //      STORE LIST WHEN SEARCH MATCHES
            // ================================================================
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredStores.length,
                itemBuilder: (context, index) {
                  return _storeCard(filteredStores[index]);
                },
              ),
            ),

          // Continue Button
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: GestureDetector(
              onTap: selectedStore == null
                  ? null
                  : () {
                Get.to(() => SuccessCompletedPage(
                  message: "Work Details Completed!",
                ));
                UploadStatus.workDetailsCompleted = true;
                UploadStatus.saveStatus();
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: selectedStore == null
                      ? null
                      : const LinearGradient(
                    colors: [
                      Color(0xFFF28C28),
                      Color(0xFFE37814),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  color: selectedStore == null
                      ? Colors.grey.shade300
                      : null,
                  boxShadow: selectedStore == null
                      ? []
                      : [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: selectedStore == null
                          ? Colors.grey
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  // Step bar UI
  Widget _stepBar({required bool active}) {
    return Expanded(
      child: Container(
        height: 5,
        margin: EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: active ? Color(0xFFF28C28) : Colors.orange.shade100,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  // Store Card UI
  Widget _storeCard(Map<String, dynamic> store) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (store["recommended"] == true)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "RECOMMENDED",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          SizedBox(height: 10),

          Row(
            children: [
              Radio<String>(
                value: store["name"],
                groupValue: selectedStore,
                activeColor: Color(0xFFF28C28),
                onChanged: (value) {
                  setState(() => selectedStore = value);
                },
              ),
              Expanded(
                child: Text(
                  store["name"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Text(
              store["address"],
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),

          SizedBox(height: 8),

          // Bonus Bar
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.card_giftcard, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  "Joining Bonus up to ${store["bonus"]}",
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.lock_outline, size: 20, color: Color(0xFFF28C28)),
              SizedBox(width: 10),
              Text(
                "Onboarding Fees",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  store["fees"],
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
