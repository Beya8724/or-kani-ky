import 'package:flutter/material.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  // 0: Order Placed, 1: Preparing, 2: On The Way, 3: Delivered
  // Value must come from ADMIN (Backend or DB)
  final int _currentStep = 1; 
  final String _orderId = "BB-20251120-1045";

  // Order timeline labels
  final List<String> _orderStatuses = [
    "Order Placed",
    "Preparing (Brewing your coffee!)",
    "On The Way (Rider assigned)",
    "Delivered (Enjoy your bliss!)",
  ];

  // USER CAN'T EDIT, ONLY DISPLAY
  Widget _buildStatusTile({
    required int stepIndex,
    required String title,
    required IconData icon,
    bool isLast = false,
  }) {
    final bool isActive = stepIndex <= _currentStep;
    final Color activeColor = const Color(0xFFD4A056);
    final Color inactiveColor = Colors.white38;
    final Color iconColor = isActive ? activeColor : inactiveColor;
    final Color textColor = isActive ? Colors.white : Colors.white60;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Icon + Line
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? activeColor.withOpacity(0.2) : Colors.black45,
                shape: BoxShape.circle,
                border: Border.all(color: isActive ? activeColor : inactiveColor, width: 2),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 60,
                color: isActive && stepIndex < _currentStep ? activeColor : inactiveColor,
              ),
          ],
        ),
        const SizedBox(width: 15),

        // Status Text
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: isLast ? 0 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (stepIndex == _currentStep && stepIndex < 3)
                Text(
                  stepIndex == 1 ? "Estimated: 5-10 mins" : "Estimated arrival: 15 mins",
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 13),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Your Order"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/yes.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black87,
              BlendMode.darken,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100, left: 25, right: 25, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Order Status",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFFD4A056)),
              ),
              const SizedBox(height: 5),
              Text(
                "Order ID: $_orderId",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),

              // Order Timeline (Display Only)
              _buildStatusTile(stepIndex: 0, title: _orderStatuses[0], icon: Icons.receipt_long),
              _buildStatusTile(stepIndex: 1, title: _orderStatuses[1], icon: Icons.access_time_filled),
              _buildStatusTile(stepIndex: 2, title: _orderStatuses[2], icon: Icons.delivery_dining),
              _buildStatusTile(stepIndex: 3, title: _orderStatuses[3], icon: Icons.check_circle_outline, isLast: true),

              const SizedBox(height: 30),

              // Order History Button
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/orderHistory'),
                  child: const Text(
                    "View Order History",
                    style: TextStyle(color: Colors.white70, decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}