import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          const Text(
            "Dashboard Overview",
            style: TextStyle(
              color: Color(0xFFD4A056),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          // METRIC CARDS
          Row(
            children: [
              _DashboardCard(
                title: "Total Orders",
                value: "125",
                icon: Icons.shopping_cart,
              ),
              const SizedBox(width: 20),
              _DashboardCard(
                title: "Revenue",
                value: "₱12,450",
                icon: Icons.monetization_on,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              _DashboardCard(
                title: "Products",
                value: "34",
                icon: Icons.coffee,
              ),
              const SizedBox(width: 20),
              _DashboardCard(
                title: "Pending Orders",
                value: "8",
                icon: Icons.pending_actions,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // BIG PANEL
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sales Overview",
                  style: TextStyle(
                    color: Color(0xFFD4A056),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Charts and analytics can go here...",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ REUSABLE CARD WIDGET ------------------

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFD4A056), size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
