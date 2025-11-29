import 'package:flutter/material.dart';
import 'accountpage.dart';
import 'deliverymappage.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int selectedTab = 1; // 0 = Meal, 1 = Store
  String selectedDate = "24/08/2023";
  int expandedIndex = -1;
  String selectedStatus = "Select an option";

  final List<String> statusOptions = [
    "Pending",
    "Packed",
    "Out for Delivery",
    "Delivered",
    "Cancelled",
  ];

  // Store Orders
  final List<Map<String, dynamic>> orders = [
    {"orderId": "#11250", "status": "Pickup Pending", "color": Colors.orangeAccent},
    {"orderId": "#11251", "status": "Pickup Failed", "color": Colors.redAccent},
    {"orderId": "#11252", "status": "Pickup Rescheduled", "color": Colors.blueAccent},
    {"orderId": "#11251", "status": "Delivery Failed", "color": Colors.redAccent},
    {"orderId": "#11253", "status": "Delivered", "color": Colors.green},
    {"orderId": "#11250", "status": "Delivery Pending", "color": Colors.orangeAccent},
    {"orderId": "#11252", "status": "Delivery Rescheduled", "color": Colors.blueAccent},
  ];

  // Meal Pickup Centers
  final List<Map<String, dynamic>> pickupCenters = [
    {
      "centerName": "Pickup Center-1",
      "orders": [
        {"orderNo": "#1109", "mealTime": "Breakfast", "time": "09:30 PM", "status": "Pickup Pending", "color": Colors.orangeAccent},
        {"orderNo": "#1110", "mealTime": "Lunch", "time": "12:30 PM", "status": "Pickup Failed", "color": Colors.redAccent},
        {"orderNo": "#1120", "mealTime": "Dinner", "time": "07:30 PM", "status": "Pickup Rescheduled", "color": Colors.blueAccent},
      ]
    },
    {
      "centerName": "Pickup Center-2",
      "orders": [
        {"orderNo": "#1109", "mealTime": "Breakfast", "time": "09:30 PM", "status": "Delivery Failed", "color": Colors.redAccent},
        {"orderNo": "#1110", "mealTime": "Lunch", "time": "12:30 PM", "status": "Delivery Pending", "color": Colors.orangeAccent},
        {"orderNo": "#1120", "mealTime": "Dinner", "time": "07:30 PM", "status": "Delivery Rescheduled", "color": Colors.blueAccent},
      ]
    }
  ];

  void _showStatusBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Update Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...statusOptions.map(
                  (status) => ListTile(
                title: Text(status),
                onTap: () {
                  setState(() => selectedStatus = status);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
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
            Text("Orders",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF28C28),
                  fontSize: 20,
                )),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFF28C28), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                  child: Row(children: [_smallTab("Meal", 0), const SizedBox(width: 6), _smallTab("Store", 1)]),
                ),
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
                        Text(selectedDate, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: selectedTab == 0 ? 20 : (orders.isEmpty ? 40 : 20)),
          Expanded(
            child: selectedTab == 0
                ? _buildMealOrdersList()
                : orders.isEmpty
                ? _buildEmptyOrders()
                : _buildStoreOrdersList(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(color: Colors.black12.withOpacity(0.15), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, -2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bottomNavItem(
              Icons.shopping_bag,
              "Orders",
              true,
                  () {
                // Already on orders page – do nothing
              },
            ),
            _bottomNavItem(
              Icons.person_outline,
              "Account",
              false,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AccountPage()),
                );
              },
            ),
          ],
        )

      ),
    );
  }

  // ========================= MEAL ORDERS LIST =========================
  Widget _buildMealOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: pickupCenters.length,
      itemBuilder: (context, centerIndex) {
        final center = pickupCenters[centerIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(center['centerName'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...List.generate(center['orders'].length, (orderIndex) {
              final order = center['orders'][orderIndex];
              bool isExpanded = expandedIndex == orderIndex; // define isExpanded per order

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order No. ${order['orderNo']}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${order['mealTime']} | ${order['time']}",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: order['color'].withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order['status'],
                            style: TextStyle(color: order['color'], fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Expand / Collapse Icon
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => setState(() => expandedIndex = isExpanded ? -1 : orderIndex),
                        child: Icon(
                          isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    // Expanded Details using your existing widget
                    if (isExpanded) _buildExpandedOrderDetails(),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }


  // ========================= STORE ORDERS LIST =========================
  Widget _buildStoreOrdersList() => ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemCount: orders.length,
    itemBuilder: (context, index) {
      final order = orders[index];
      bool isExpanded = expandedIndex == index;

      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order No.", // use orderId
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      "${order['orderId']}", // use orderId
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    // Remove mealTime/time for store orders
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: order['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order['status'],
                    style: TextStyle(color: order['color'], fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Expand / Collapse Icon
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => setState(() => expandedIndex = isExpanded ? -1 : index),
                child: Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black54,
                ),
              ),
            ),

            // Expanded Details
            if (isExpanded) _buildExpandedOrderDetails(),
          ],
        ),
      );
    },
  );


  Widget _smallTab(String label, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(color: isSelected ? const Color(0xFFF28C28) : Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.redAccent : Colors.black54),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.redAccent : Colors.black54,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildEmptyOrders() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/png/no_order.png", height: 220),
        const SizedBox(height: 20),
        const Text("No New Orders", style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600)),
      ],
    ),
  );

  Widget _buildExpandedOrderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(children: const [Icon(Icons.person, color: Color(0xFFF28C28), size: 20), SizedBox(width: 8), Text("Aman Sharma", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
        const SizedBox(height: 12),
        Row(
          children: const [
            Icon(Icons.store, color: Color(0xFFF28C28), size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text("Pickup Centre-1\nNikita Stores, 201/8, Nirmal Apts, Andheri East 400059", style: TextStyle(fontSize: 13, height: 1.4)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(children: [
          Image.asset("assets/png/ladoo.jpg", height: 40),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text("Besan Ladoo", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Qty 2", style: TextStyle(fontSize: 12)),
          ]),
        ]),
        const SizedBox(height: 16),
        Row(
          children: const [
            Icon(Icons.location_on, color: Color(0xFFF28C28), size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text("Delivery\n201/D, Arnata Apts., Near Jai Bhawan, Andheri 400069", style: TextStyle(fontSize: 13, height: 1.4)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.currency_rupee, size: 18),
            const SizedBox(width: 4),
            const Text("2300", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: const Text("Paid", style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(14)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Delivery Pickup By", style: TextStyle(color: Color(0xFFF28C28), fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 4),
            const Text("Tomorrow\n5:30 PM, Thu, 25/08/2023", style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Color(0xFFF28C28)), borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.access_time, color: Color(0xFFF28C28), size: 18),
                  SizedBox(width: 6),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("TIME LEFT", style: TextStyle(color: Color(0xFFF28C28), fontSize: 12, fontWeight: FontWeight.bold)),
                    Text("1:04 Hrs", style: TextStyle(color: Colors.black87, fontSize: 12)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text("Update Status", style: TextStyle(color: Color(0xFFF28C28), fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _showStatusBottomSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedStatus, style: TextStyle(fontSize: 14, color: selectedStatus == "Select an option" ? Colors.black54 : Colors.black87)),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DeliveryMapPage(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(color: const Color(0xFFF28C28), borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text("Confirm Pickup", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          ),
        ),
      ],
    );
  }
}
