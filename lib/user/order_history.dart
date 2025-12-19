import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  // Sample data for Order History
  final List<Map<String, dynamic>> allOrders = [
    {"id": 105, "date": "Nov 19, 2025", "total": 290, "status": "Pending", "icon": Icons.access_time},
    {"id": 104, "date": "Nov 17, 2025", "total": 450, "status": "Delivered", "icon": Icons.check_circle_outline},
    {"id": 103, "date": "Nov 15, 2025", "total": 120, "status": "Delivered", "icon": Icons.check_circle_outline},
    {"id": 102, "date": "Nov 1, 2025", "total": 240, "status": "Cancelled", "icon": Icons.cancel_outlined},
    {"id": 101, "date": "Oct 25, 2025", "total": 170, "status": "Delivered", "icon": Icons.check_circle_outline},
  ];

  String selectedFilter = 'All'; // State for the filter chip
  
  // Helper to determine status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green.shade400;
      case 'Cancelled':
        return Colors.red.shade400;
      case 'Pending':
        return Colors.amber.shade400;
      default:
        return Colors.white70;
    }
  }

  // Filter the list based on the selected chip
  List<Map<String, dynamic>> get filteredOrders {
    if (selectedFilter == 'All') {
      return allOrders;
    }
    return allOrders.where((order) => order['status'] == selectedFilter).toList();
  }

  void _selectFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white, // Ensure back button is visible
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/yes.jpg'), // Consistent background
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black87,
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            // Padding to clear the transparent AppBar
            const SizedBox(height: 100),

            // FILTER CHIPS (Hot / Cold equivalent for Order History)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                children: [
                  _OrderFilterChip(
                      label: 'All', 
                      isSelected: selectedFilter == 'All', 
                      onTap: () => _selectFilter('All')),
                  _OrderFilterChip(
                      label: 'Pending', 
                      isSelected: selectedFilter == 'Pending', 
                      onTap: () => _selectFilter('Pending')),
                  _OrderFilterChip(
                      label: 'Delivered', 
                      isSelected: selectedFilter == 'Delivered', 
                      onTap: () => _selectFilter('Delivered')),
                  _OrderFilterChip(
                      label: 'Cancelled', 
                      isSelected: selectedFilter == 'Cancelled', 
                      onTap: () => _selectFilter('Cancelled')),
                ],
              ),
            ),
            
            // ORDER LIST
            Expanded(
              child: filteredOrders.isEmpty
                  ? Center(
                      child: Text(
                        "No '$selectedFilter' orders found.",
                        style: const TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        final statusColor = _getStatusColor(order['status']);

                        return Card(
                          color: Colors.black38, // Slightly darker card for more depth
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            // Status Icon as Leading
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(order['icon'] as IconData, color: statusColor, size: 24),
                            ),
                            
                            // Order ID and Date
                            title: Text('Order #${order['id']}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                            subtitle: Text(
                                '${order['date']} | Status: ${order['status']}', 
                                style: TextStyle(color: statusColor, fontWeight: FontWeight.w500)),
                                
                            // Total Price
                            trailing: Text("₱${order['total']}",
                                style: const TextStyle(
                                    color: Color(0xFFD4A056),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            onTap: () {
                              // Action to view detailed receipt
                              _showOrderDetails(context, order);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Simple modal to show mock details on tap
  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text('Order Details #${order['id']}',
                    style: const TextStyle(color: Color(0xFFD4A056), fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const Divider(color: Colors.white38),
              _detailRow('Date:', order['date'], Colors.white),
              _detailRow('Total Paid:', '₱${order['total']}', const Color(0xFFD4A056)),
              _detailRow('Status:', order['status'], _getStatusColor(order['status'])),
              _detailRow('Items:', '2 items (Mock Data)', Colors.white70),
              const SizedBox(height: 20),
              // You can add more detailed item lists here
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(value, style: TextStyle(color: valueColor, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}


// Custom Chip Widget for filtering categories
class _OrderFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OrderFilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: isSelected ? const Color(0xFFD4A056) : Colors.black38,
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isSelected ? BorderSide.none : const BorderSide(color: Colors.white38),
        ),
      ),
    );
  }
}