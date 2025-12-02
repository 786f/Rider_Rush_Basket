// AdvancedEarningDashboard.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../widget/bottomnav.dart';
import '../../onboarding/screen/onboarding_screen.dart';
import 'accountpage.dart';
import 'order_page.dart';

/// Advanced Earnings Dashboard with:
/// - Tabs (Today / This Week / This Month)
/// - Bar chart (per tab)
/// - Online/Offline toggle (persisted)
/// - Payout history page
/// - Download earnings as PDF
class AdvancedEarningDashboard extends StatefulWidget {
  const AdvancedEarningDashboard({super.key});

  @override
  State<AdvancedEarningDashboard> createState() => _AdvancedEarningDashboardState();
}

class _AdvancedEarningDashboardState extends State<AdvancedEarningDashboard> {
  int selectedTabIndex = 1; // 0=Today,1=ThisWeek,2=ThisMonth
  bool isOnline = true;

  // MOCK data (replace with real API)
  final Map<String, List<double>> mockEarnings = {
    "today": [120, 200, 80, 150, 90], // hourly or slot values for "Today"
    "week": [450, 380, 500, 620, 480, 520, 600], // 7 days
    "month": List.generate(30, (i) => (300 + (i % 7) * 20).toDouble()), // 30 days
  };

  // summary numbers (replace with API)
  double totalEarningsThisMonth = 14580;
  double cashCollected = 2800;
  double tips = 1250;
  double incentives = 3000;
  String nextSettlement = "₹ 4,800 arriving on 2 Dec";

  @override
  void initState() {
    super.initState();
    _loadOnlineStatus();
  }

  Future<void> _loadOnlineStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isOnline = prefs.getBool('rider_online') ?? true;
    });
  }

  Future<void> _saveOnlineStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rider_online', value);
  }

  List<double> get activeSeries {
    switch (selectedTabIndex) {
      case 0:
        return mockEarnings['today']!;
      case 1:
        return mockEarnings['week']!;
      case 2:
      default:
        return mockEarnings['month']!;
    }
  }

  String get activeTitle {
    switch (selectedTabIndex) {
      case 0:
        return "Today";
      case 1:
        return "This Week";
      case 2:
      default:
        return "This Month";
    }
  }

  // ---------------- PDF EXPORT ----------------
  Future<void> _exportPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Earnings Report", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("$activeTitle Summary"),
              pw.SizedBox(height: 6),
              pw.Text("Total Earnings: ₹ ${totalEarningsThisMonth.toStringAsFixed(0)}"),
              pw.Text("Cash Collected: ₹ ${cashCollected.toStringAsFixed(0)}"),
              pw.Text("Tips: ₹ ${tips.toStringAsFixed(0)}"),
              pw.Text("Incentives: ₹ ${incentives.toStringAsFixed(0)}"),
              pw.SizedBox(height: 12),
              pw.Text("Detailed values:"),
              pw.SizedBox(height: 6),
              pw.Bullet(text: activeSeries.map((e) => e.toStringAsFixed(0)).join(", ")),
            ],
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }

  // ---------------- NAV TO PAYOUT HISTORY ----------------
  Future<void> _openPayoutHistory() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const PayoutHistoryPage()));
    // If you want to refresh after returning, call setState
    setState(() {});
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final series = activeSeries;
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 2),

      backgroundColor: const Color(0xFFFFF7EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7EF),
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Earnings",
          style: TextStyle(color: const Color(0xFFF28C28), fontWeight: FontWeight.bold),
        ),
        actions: [
          // Online toggle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
            child: Row(
              children: [
                Text(isOnline ? "Online" : "Offline", style: const TextStyle(color: Colors.black54)),
                const SizedBox(width: 8),
                Switch(
                  activeColor: const Color(0xFFF28C28),
                  value: isOnline,
                  onChanged: (val) {
                    setState(() => isOnline = val);
                    _saveOnlineStatus(val);
                    // TODO: notify backend that rider is online/offline
                  },
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFF28C28), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Top summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: boxDecoration(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(activeTitle, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 8),
              Text("₹ ${totalEarningsThisMonth.toStringAsFixed(0)}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(children: const [
                Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                SizedBox(width: 6),
                Text("+8% vs last period", style: TextStyle(color: Colors.green)),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _smallStat("Rides", "162"),
                _smallStat("Tips", "₹ ${tips.toStringAsFixed(0)}"),
                _smallStat("Incentives", "₹ ${incentives.toStringAsFixed(0)}"),
              ])
            ]),
          ),

          const SizedBox(height: 18),

          // Tabs: Today / This Week / This Month
          // Tabs: Today / This Week / This Month
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                _tabButton("Today", 0),
                const SizedBox(width: 8), // more spacing
                _tabButton("This Week", 1),
                const SizedBox(width: 8), // more spacing
                _tabButton("This Month", 2),

              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _exportPdf,
                icon: const Icon(Icons.download_rounded, color: Color(0xFFF28C28)),
                tooltip: "Download report as PDF",
              ),
              IconButton(
                onPressed: _openPayoutHistory,
                icon: const Icon(Icons.history, color: Color(0xFFF28C28)),
                tooltip: "Payout history",
              ),
            ],
          ),


          const SizedBox(height: 12),

          // Bar Chart area
          Container(
            padding: const EdgeInsets.all(10),
            decoration: boxDecoration(),
            child: Column(children: [
              SizedBox(
                height: 220,
                child: _buildBarChart(series),
              ),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("$activeTitle breakdown", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Total: ₹ ${series.fold(0.0, (p, n) => p + n).toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ]),
          ),

          const SizedBox(height: 18),

          // Cash + Settlement row
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: boxDecoration(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Cash Collected", style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Text("₹ ${cashCollected.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Cash to bank", style: TextStyle(color: Colors.black54))
                ]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: boxDecoration(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Next Settlement", style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Text(nextSettlement, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ]),

          const SizedBox(height: 18),

          // Incentive breakdown
          Container(
            padding: const EdgeInsets.all(12),
            decoration: boxDecoration(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Incentive Breakdown", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _incentiveRow("Peak hours bonus", "₹ 800"),
              _incentiveRow("Rain incentive", "₹ 400"),
              _incentiveRow("Streak bonus", "₹ 180"),
            ]),
          ),
        ]),
      ),

    );

  }
  Widget _bottomNavItem(
      IconData icon, String label, bool active, VoidCallback onTap) {
    final Color primary = const Color(0xFFF28C28);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26, color: active ? primary : Colors.black45),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: active ? primary : Colors.black54,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  Widget _incentiveRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: const TextStyle(color: Colors.black87)),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
    );
  }

  // ---------------- small helpers ----------------
  Widget _smallStat(String title, String value) {
    return Column(children: [Text(title, style: const TextStyle(color: Colors.black54)), const SizedBox(height: 6), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]);
  }

  Widget _tabButton(String label, int idx) {
    final selected = selectedTabIndex == idx;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: selected ? const Color(0xFFF28C28) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? const Color(0xFFF28C28) : Colors.grey.shade300)),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black54, fontWeight: selected ? FontWeight.bold : FontWeight.w500)),
      ),
    );
  }

  // ---------------- Bar chart builder ----------------
  Widget _buildBarChart(List<double> data) {
    final maxY = (data.isEmpty)
        ? 100.0
        : (data.reduce((a, b) => a > b ? a : b) * 1.2);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY.toDouble(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: (maxY / 4).toDouble(),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();

                if (selectedTabIndex == 1) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (i >= 0 && i < days.length) {
                    return Text(days[i],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600));
                  }
                  return const Text('');
                }

                if (selectedTabIndex == 0) {
                  const slots = ['6AM', '9AM', '12PM', '3PM', '6PM'];
                  if (i >= 0 && i < slots.length) {
                    return Text(slots[i],
                        style: const TextStyle(fontSize: 11));
                  }
                  return const Text('');
                }

                if (selectedTabIndex == 2) {
                  if (i % 5 == 0) {
                    return Transform.rotate(
                      angle: -0.5, // rotate 30 degrees
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    );
                  }
               //   return const Text('');
                }


                return const Text('');
              },
            ),
          ),
        ),
        barGroups: List.generate(data.length, (i) {
          final y = data[i];

          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: y.toDouble(),
                color: const Color(0xFFF28C28),
                width: selectedTabIndex == 2 ? 6.0 : (selectedTabIndex == 1 ? 18.0 : 10.0),
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY.toDouble(),
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          );
        }),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            //color: Colors.white,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '₹ ${rod.toY.toStringAsFixed(0)}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }


  BoxDecoration boxDecoration() {
    return BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 4))]);
  }
}

// -------------------- Payout History Page --------------------
class PayoutHistoryPage extends StatefulWidget {
  const PayoutHistoryPage({super.key});

  @override
  State<PayoutHistoryPage> createState() => _PayoutHistoryPageState();
}

class _PayoutHistoryPageState extends State<PayoutHistoryPage> {
  // mock payout items
  List<Map<String, String>> payouts = [
    {"date": "2025-11-29", "amount": "₹ 4,800", "status": "Completed"},
    {"date": "2025-11-22", "amount": "₹ 5,200", "status": "Completed"},
    {"date": "2025-11-15", "amount": "₹ 4,500", "status": "Failed"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payout History", style: TextStyle(color: Color(0xFFF28C28))),
        backgroundColor: const Color(0xFFFFF7EF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFFFF7EF),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Expanded(
            child: ListView.separated(
              itemCount: payouts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final p = payouts[idx];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p['date']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(p['amount']!, style: const TextStyle(color: Colors.black87)),
                    ]),
                    Row(children: [
                      Text(p['status']!, style: TextStyle(color: p['status'] == "Completed" ? Colors.green : Colors.red)),
                      const SizedBox(width: 12),
                      if (p['status'] == "Failed")
                        ElevatedButton(
                          onPressed: () {
                            // try resend payout (mock)
                            setState(() {
                              payouts[idx]['status'] = "Completed";
                            });
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF28C28)),
                          child: const Text("Retry"),
                        ),
                    ])
                  ]),
                );
              },
            ),
          ),
        ]),

      ),

    );
  }

}
