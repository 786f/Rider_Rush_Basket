import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../widget/bottomnav.dart';
import 'deliverymappage.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int selectedTab = 0; // New / Active / Completed
  int mealStoreTab = 1; // Meal / Store
  int expandedIndex = -1;

  String selectedDate = "01/12/2025";
  String selectedStatus = "Select an option";

  final List<String> statusOptions = [
    "Pending",
    "Packed",
    "Out for Delivery",
    "Delivered",
    "Cancelled",
  ];

  // ------------------ STORE NEW ORDERS ------------------
  List<Map<String, dynamic>> newOrders = [
    {
      "customer": "Aman Sharma",
      "pickup": "Nikita Stores, Andheri East",
      "drop": "Arnata Apts, Andheri West",
      "distance": "1.6 km",
      "pay": "₹45",
      "timeLeft": 15,
    },
    {
      "customer": "Rahul Jain",
      "pickup": "Freshco Market, Andheri",
      "drop": "Hiranandani, Powai",
      "distance": "2.1 km",
      "pay": "₹55",
      "timeLeft": 30,
    },
  ];

  // ------------------ STORE ACTIVE ------------------
  List<Map<String, dynamic>> activeOrders = [
    {
      "orderId": "#11250",
      "stageIndex": 0,
      "pickup": "Freshco Market, Andheri",
      "drop": "Jai Bhawan, Andheri West",
      "earnings": "₹28"
    },
    {
      "orderId": "#11251",
      "stageIndex": 1,
      "pickup": "SRS Store, Powai",
      "drop": "Near Hiranandani",
      "earnings": "₹38"
    }
  ];

  // ------------------ STORE COMPLETED ------------------
  List<Map<String, dynamic>> completedOrders = [
    {
      "orderId": "#11210",
      "earnings": "₹42",
      "date": "26 Nov 2023",
      "time": "4:20 PM"
    }
  ];

  // ------------------ MEAL ORDERS ------------------
  List<Map<String, dynamic>> mealNewOrders = [
    {
      "customer": "Vikas Singh",
      "pickup": "Biryani House, Andheri",
      "drop": "Sai Darshan Apt, Andheri West",
      "distance": "1.2 km",
      "pay": "₹35",
      "timeLeft": 25,
    }
  ];

  List<Map<String, dynamic>> mealActiveOrders = [
    {
      "orderId": "#M5501",
      "stageIndex": 0,
      "pickup": "Pizza Plaza, Powai",
      "drop": "Lake Homes, Powai",
      "earnings": "₹48"
    }
  ];

  List<Map<String, dynamic>> mealCompletedOrders = [
    {
      "orderId": "#M5401",
      "earnings": "₹40",
      "date": "25 Nov 2023",
      "time": "5:10 PM"
    }
  ];

  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        for (var order in newOrders) {
          if (order["timeLeft"] > 0) order["timeLeft"]--;
        }
        for (var order in mealNewOrders) {
          if (order["timeLeft"] > 0) order["timeLeft"]--;
        }
      });
    });
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFF28C28),
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        selectedDate =
        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      backgroundColor: const Color(0xFFFFF7EF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shopping_bag_outlined, color: Color(0xFFF28C28)),
            SizedBox(width: 6),
            Text(
              "Orders",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF28C28),
                  fontSize: 20),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color(0xFFF28C28), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Store Row + Date Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Only Store tab container (can even remove the row if not needed)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _smallTab("Store", 0, 0), // Only Store tab, fixed index
                ),

                // Date Picker
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(selectedDate,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 20, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          _topTabs(),

          Expanded(
            child: selectedTab == 0
                ? _newOrdersList(newOrders) // Only Store new orders
                : selectedTab == 1
                ? _activeOrdersList(activeOrders) // Only Store active orders
                : _completedOrdersList(completedOrders), // Only Store completed orders
          ),

        ],
      ),
    );
  }

  // ------------------ TOP TABS ------------------
  Widget _topTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 4)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tab("New Orders", 0),
          _tab("Active", 1),
          _tab("Completed", 2),
        ],
      ),
    );
  }

  Widget _tab(String title, int index) {
    bool selected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
            color: selected ? const Color(0xFFF28C28) : Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          title,
          style: TextStyle(
              color: selected ? Colors.white : Colors.black54,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500),
        ),
      ),
    );
  }

  Widget _smallTab(String label, int index, int currentTab) {
    bool isSelected = currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => mealStoreTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF28C28) : Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
      ),
    );
  }

  // ------------------ NEW ORDERS ------------------
  Widget _newOrdersList(List<Map<String, dynamic>> list, {bool isMeal = false}) {
    if (list.isEmpty) return _buildEmptyOrders();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final order = list[index];
        return _newOrderCard(order, parentList: list, isMeal: isMeal);
      },
    );
  }

  Widget _newOrderCard(Map order,
      {required List parentList, bool isMeal = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(order["customer"],
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _locRow(Icons.store, "Pickup", order["pickup"]),
          const SizedBox(height: 10),
          _locRow(Icons.location_on, "Drop", order["drop"]),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _badge("${order["distance"]}"),
              _badge("Pay ${order["pay"]}"),
              _badge("Time: ${order["timeLeft"]}s"),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              // Reject button: removes order from newOrders list
              _btn("Reject", Color(0xFF1A3C6E), Colors.white, () {
                setState(() {
                  parentList.remove(order); // Remove the order from the list
                });
              }),

              const SizedBox(width: 12),

              // Accept button: moves order to activeOrders
              _btn("Accept", const  Color(0xFFE57D16), Colors.white, () {
                setState(() {
                  // Add the order to activeOrders
                  activeOrders.add({
                    "orderId": "#${DateTime.now().millisecondsSinceEpoch}",
                    "stageIndex": 0,
                    "pickup": order["pickup"],
                    "drop": order["drop"],
                    "earnings": order["pay"]
                  });

                  // Remove from newOrders
                  parentList.remove(order);
                });
              }),
            ],
          )

        ],
      ),
    );
  }

  // ------------------ ACTIVE ORDERS ------------------
  Widget _activeOrdersList(List<Map<String, dynamic>> list,
      {bool isMeal = false}) {
    if (list.isEmpty) return _buildEmptyOrders();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final order = list[index];
        bool isExpanded = expandedIndex == index;

        int stage = order["stageIndex"] ?? 0;
        String stageText =
        stage == 0 ? "Accepted" : stage == 1 ? "Picked" : "Delivered";

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: _box(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order["orderId"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17)),
                  GestureDetector(
                    onTap: () =>
                        setState(() => expandedIndex = isExpanded ? -1 : index),
                    child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black54),
                  )
                ],
              ),
              const SizedBox(height: 8),

              _locRow(Icons.store, "Pickup", order["pickup"]),
              const SizedBox(height: 8),
              _locRow(Icons.location_on, "Drop", order["drop"]),
              const SizedBox(height: 12),

              _badge("Status: $stageText"),
              const SizedBox(height: 10),
              _badge("Earnings: ${order["earnings"]}"),
              const SizedBox(height: 10),

              // Stage Progress Button
              if (stage < 2)
                _fullWidthBtn("Next Stage", const Color(0xFFF28C28),
                    Colors.white, () {
                      setState(() => order["stageIndex"]++);

                      if (order["stageIndex"] == 2) {
                        // Move to completed
                        if (isMeal) {
                          mealCompletedOrders.add({
                            "orderId": order["orderId"],
                            "earnings": order["earnings"],
                            "date": "Today",
                            "time": "Now"
                          });
                          mealActiveOrders.remove(order);
                        } else {
                          completedOrders.add({
                            "orderId": order["orderId"],
                            "earnings": order["earnings"],
                            "date": "Today",
                            "time": "Now"
                          });
                          activeOrders.remove(order);
                        }
                      }
                    }),

              // Track on Map
              if (isExpanded)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DeliveryMapPage()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF28C28),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text("Track on Map",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  // ------------------ COMPLETED ------------------
  Widget _completedOrdersList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) return _buildEmptyOrders();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final order = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: _box(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order["orderId"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17)),
              const SizedBox(height: 6),
              Text("Delivered on ${order["date"]} at ${order["time"]}",
                  style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 10),
              _badge("Earned: ${order["earnings"]}"),
            ],
          ),
        );
      },
    );
  }

  // ------------------ WIDGET HELPERS ------------------
  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: Color(0xFFF28C28))),
    );
  }

  Widget _locRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFFF28C28)),
        const SizedBox(width: 8),
        Expanded(
            child: Text("$label:\n$value",
                style: const TextStyle(height: 1.3)))
      ],
    );
  }

  Widget _btn(String text, Color bg, Color fg, VoidCallback onTap) {
    return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(text,
                    style: TextStyle(color: fg, fontWeight: FontWeight.w600))),
          ),
        ));
  }

  Widget _fullWidthBtn(String text, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration:
        BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(text,
                style: TextStyle(color: fg, fontWeight: FontWeight.w600))),
      ),
    );
  }

  Widget _buildEmptyOrders() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(height: 20),
        Text("No Orders",
            style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w600)),
      ],
    ),
  );

  BoxDecoration _box() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2))
      ]);
}
