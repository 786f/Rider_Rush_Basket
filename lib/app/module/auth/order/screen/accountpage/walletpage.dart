import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final Color primary = const Color(0xFFF28C28);
  int filterIndex = 0; // 0 = All, 1 = Credit, 2 = Debit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3E9),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("My Wallet", style: TextStyle(color: primary)),
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),

            // -------------------- WALLET CARD --------------------
            _walletCard(),

            const SizedBox(height: 20),

            // -------------------- FILTER CHIPS --------------------
            _filterChips(),

            const SizedBox(height: 20),

            // -------------------- TRANSACTION HISTORY --------------------
            _sectionHeading("Recent Transactions"),

            const SizedBox(height: 8),

            _buildTransactionList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // -------------------- WALLET CARD (ZEPO STYLE) --------------------
  Widget _walletCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, const Color(0xFFF7A64C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Available Balance",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),

          const SizedBox(height: 6),

          const Text(
            "₹ 1,250.00",
            style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primary,
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Withdraw Money",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- FILTER CHIPS --------------------
  Widget _filterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _chip("All", 0),
          const SizedBox(width: 8),
          _chip("Credit", 1),
          const SizedBox(width: 8),
          _chip("Debit", 2),
        ],
      ),
    );
  }

  Widget _chip(String label, int index) {
    final bool active = filterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => filterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? primary : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: active ? primary : Colors.black26),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // -------------------- SECTION HEADING --------------------
  Widget _sectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.history, size: 20, color: Colors.black54),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // -------------------- TRANSACTION LIST --------------------
  Widget _buildTransactionList() {
    List<Map<String, dynamic>> list = [
      {
        "title": "Delivery Payout",
        "amount": 450,
        "date": "Today, 10:20 AM",
        "credit": true,
        "icon": Icons.delivery_dining
      },
      {
        "title": "Order Incentive",
        "amount": 100,
        "date": "Today, 08:15 AM",
        "credit": true,
        "icon": Icons.local_fire_department
      },
      {
        "title": "Withdrawal",
        "amount": 250,
        "date": "Yesterday, 07:00 PM",
        "credit": false,
        "icon": Icons.currency_rupee_rounded
      },
      {
        "title": "Weekly Bonus",
        "amount": 700,
        "date": "28 Nov 2025",
        "credit": true,
        "icon": Icons.stars
      }
    ];

    // Apply filter
    if (filterIndex == 1) {
      list = list.where((e) => e["credit"] == true).toList();
    } else if (filterIndex == 2) {
      list = list.where((e) => e["credit"] == false).toList();
    }

    return Column(
      children: list
          .map((e) => _transactionTile(
        icon: e["icon"],
        title: e["title"],
        amount: e["amount"],
        date: e["date"],
        isCredit: e["credit"],
      ))
          .toList(),
    );
  }

  // -------------------- TRANSACTION TILE --------------------
  Widget _transactionTile({
    required IconData icon,
    required String title,
    required int amount,
    required String date,
    required bool isCredit,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: primary.withOpacity(0.15),
            child: Icon(icon, color: primary, size: 24),
          ),

          const SizedBox(width: 14),

          // TITLE + DATE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(date,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black45)),
              ],
            ),
          ),

          // AMOUNT
          Text(
            (isCredit ? "+₹" : "-₹") + amount.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCredit ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
