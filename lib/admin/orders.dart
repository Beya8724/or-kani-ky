import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, String>> orders = [
    {"orderId": "ORD-00125", "customer": "John Mark", "status": "Preparing"},
    {"orderId": "ORD-00126", "customer": "Angela Cruz", "status": "Completed"},
    {"orderId": "ORD-00127", "customer": "Marvin Reyes", "status": "Pending"},
    {"orderId": "ORD-00128", "customer": "Bea Dela Cruz", "status": "Out for Delivery"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Orders",
            style: TextStyle(
              color: Color(0xFFD4A056),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return OrderTile(
                  orderId: order["orderId"]!,
                  customer: order["customer"]!,
                  status: order["status"]!,
                  onStatusChanged: (newStatus) {
                    setState(() {
                      orders[index]["status"] = newStatus;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------
//               ORDER TILE WITH EDITABLE STATUS
// ------------------------------------------------------
class OrderTile extends StatelessWidget {
  final String orderId;
  final String customer;
  final String status;
  final Function(String) onStatusChanged;

  const OrderTile({
    super.key,
    required this.orderId,
    required this.customer,
    required this.status,
    required this.onStatusChanged,
  });

  Color getStatusColor(String s) {
    switch (s.toLowerCase()) {
      case "completed":
        return Colors.greenAccent;
      case "preparing":
        return Colors.amberAccent;
      case "pending":
        return Colors.orangeAccent;
      case "out for delivery":
        return Colors.lightBlueAccent;
      default:
        return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color badgeColor = getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ORDER DETAILS
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderId,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                customer,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),

          // STATUS DROPDOWN
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: badgeColor),
            ),
            child: DropdownButton<String>(
              value: status,
              dropdownColor: Colors.black87,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              items: const [
                DropdownMenuItem(
                  value: "Pending",
                  child: Text("Pending", style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: "Preparing",
                  child: Text("Preparing", style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: "Out for Delivery",
                  child: Text("Out for Delivery", style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: "Completed",
                  child: Text("Completed", style: TextStyle(color: Colors.white)),
                ),
              ],

              onChanged: (value) {
                if (value != null) onStatusChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
