import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'product_main.dart';
import 'orders.dart';
import 'reports.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const DashboardScreen(),
    const ProductMainScreen(),
    const OrdersScreen(),
    const ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111111),

      body: Row(
        children: [
          // ---------------- SIDEBAR ----------------
          Container(
            width: 230,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.70),
              border: const Border(
                right: BorderSide(color: Colors.white24, width: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                Center(
                  child: Text(
                    "ADMIN PANEL",
                    style: TextStyle(
                      color: const Color(0xFFD4A056),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                buildMenuItem(Icons.dashboard, "Dashboard", 0),
                buildMenuItem(Icons.coffee, "Products", 1),
                buildMenuItem(Icons.shopping_bag, "Orders", 2),
                buildMenuItem(Icons.bar_chart, "Reports", 3),

                const Spacer(),
                buildMenuItem(Icons.logout, "Logout", 999),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // ---------------- CONTENT AREA ----------------
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff1A1A1A), Color(0xff0D0D0D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, int index) {
    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        if (index == 999) {
          // TODO: Add logout logic
          return;
        }
        setState(() => selectedIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4A056).withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: const Color(0xFFD4A056),
                size: 22),

            const SizedBox(width: 15),

            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
